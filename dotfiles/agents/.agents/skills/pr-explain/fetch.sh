#!/usr/bin/env bash
# Read-only GitHub access for the pr-explain skill. Every call here is a GET.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

usage() {
  cat >&2 <<'EOF'
usage:
  fetch.sh current-repo                       owner/repo of the current directory
  fetch.sh meta     [<pr>]                    title, body, author, branches, head sha, files, linked issues
                                              (no <pr>: the PR for the checked-out branch)
  fetch.sh diff     <pr>                      unified diff
  fetch.sh commits  <pr>                      short sha and headline of each commit
  fetch.sh comments <pr>                      existing reviews and line comments
  fetch.sh issue    <owner/repo> <number>     issue title and body
  fetch.sh file     <owner/repo> <ref> <path> file contents at a commit or branch
  fetch.sh search   <owner/repo> <query>      code search within the repo (default branch)

<pr> is https://github.com/owner/repo/pull/123 or owner/repo#123
EOF
  exit 2
}

[[ $# -ge 1 ]] || usage
cmd=$1
shift

case "$cmd" in
  current-repo)
    [[ $# -eq 0 ]] || usage
    gh repo view --json nameWithOwner --jq .nameWithOwner
    ;;
  meta)
    [[ $# -le 1 ]] || usage
    fields=number,url,title,body,author,state,isDraft,baseRefName,headRefName,headRefOid,additions,deletions,changedFiles,files,closingIssuesReferences,labels
    if [[ $# -eq 0 ]]; then
      gh pr view --json "$fields"
    else
      parse_pr "$1"
      gh pr view "$NUMBER" -R "$OWNER/$REPO" --json "$fields"
    fi
    ;;
  diff)
    [[ $# -eq 1 ]] || usage
    parse_pr "$1"
    gh pr diff "$NUMBER" -R "$OWNER/$REPO"
    ;;
  commits)
    [[ $# -eq 1 ]] || usage
    parse_pr "$1"
    gh pr view "$NUMBER" -R "$OWNER/$REPO" --json commits \
      --jq '.commits[] | "\(.oid[0:7]) \(.messageHeadline)"'
    ;;
  comments)
    [[ $# -eq 1 ]] || usage
    parse_pr "$1"
    echo "## reviews"
    gh api --method GET --paginate "repos/$OWNER/$REPO/pulls/$NUMBER/reviews?per_page=100" \
      --jq '.[] | select(.body != "") | {user: .user.login, state, body}'
    echo "## line comments"
    gh api --method GET --paginate "repos/$OWNER/$REPO/pulls/$NUMBER/comments?per_page=100" \
      --jq '.[] | {user: .user.login, path, line, body}'
    ;;
  issue)
    [[ $# -eq 2 ]] || usage
    parse_repo "$1"
    [[ "$2" =~ ^[0-9]+$ ]] || die "not an issue number: $2"
    gh issue view "$2" -R "$OWNER/$REPO" --json number,url,title,body,state
    ;;
  file)
    [[ $# -eq 3 ]] || usage
    parse_repo "$1"
    [[ "$2" =~ ^[A-Za-z0-9._/-]+$ && "$2" != -* ]] || die "bad ref: $2"
    [[ "$3" =~ ^[A-Za-z0-9._@+/-]+$ && "$3" != /* && "$3" != -* && "$3" != *..* ]] || die "bad path: $3"
    gh api --method GET -H "Accept: application/vnd.github.raw" "repos/$OWNER/$REPO/contents/$3?ref=$2"
    ;;
  search)
    [[ $# -eq 2 ]] || usage
    parse_repo "$1"
    gh search code --repo "$OWNER/$REPO" --limit 30 --json path,textMatches -- "$2"
    ;;
  *)
    usage
    ;;
esac
