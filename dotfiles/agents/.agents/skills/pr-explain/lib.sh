# Helpers for fetch.sh. Sourced, not executed.

die() {
  echo "error: $*" >&2
  exit 2
}

# Accepts https://github.com/OWNER/REPO/pull/N[/...] or OWNER/REPO#N.
# Sets OWNER, REPO, NUMBER.
parse_pr() {
  local url_re='^https://github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/pull/([0-9]+)(/.*)?$'
  local short_re='^([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)#([0-9]+)$'
  if [[ "$1" =~ $url_re || "$1" =~ $short_re ]]; then
    OWNER=${BASH_REMATCH[1]}
    REPO=${BASH_REMATCH[2]}
    NUMBER=${BASH_REMATCH[3]}
  else
    die "not a PR reference: $1 (want https://github.com/owner/repo/pull/123 or owner/repo#123)"
  fi
}

# Accepts OWNER/REPO. Sets OWNER, REPO.
parse_repo() {
  local re='^([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)$'
  [[ "$1" =~ $re ]] || die "not a repo: $1 (want owner/repo)"
  OWNER=${BASH_REMATCH[1]}
  REPO=${BASH_REMATCH[2]}
}
