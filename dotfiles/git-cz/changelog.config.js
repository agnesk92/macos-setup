module.exports = {
  disableEmoji: false,
  format: '{type}{scope}: {emoji}{subject}',
  list: ['test', 'init', 'delete', 'wip', 'feat', 'fix', 'security', 'chore', 'docs', 'refactor', 'style', 'ci', 'perf', 'release'],
  maxMessageLength: 64,
  minMessageLength: 3,
  questions: ['type', 'subject'],
  scopes: [],
  types: {
    chore: {
      description: 'Build process or auxiliary tool changes',
      emoji: '🤖',
      value: 'chore'
    },
    delete: {
      description: 'Remove code or files',
      emoji: '🔥',
      value: 'delete'
    },
    ci: {
      description: 'CI related changes',
      emoji: '🎡',
      value: 'ci'
    },
    security: {
      description: 'security',
      emoji: '🔒️',
      value: 'security',
    },
    badcode: {
      description: 'badcode',
      emoji: '💩',
      value: 'badcode',
    },
    wip: {
      description: 'WIP',
      emoji: '🚧',
      value: 'wip',
    },
    docs: {
      description: 'Documentation changes',
      emoji: '✏️',
      value: 'docs'
    },
    feat: {
      description: 'Introduce new features',
      emoji: '✨',
      value: 'feat'
    },
    init: {
      description: 'Begin a new project',
      emoji: '🎉',
      value: 'init'
    },
    fix: {
      description: 'A bug fix',
      emoji: '🐛',
      value: 'fix'
    },
    perf: {
      description: 'Improve performance',
      emoji: '⚡️',
      value: 'perf'
    },
    refactor: {
      description: 'Refactor code',
      emoji: '♻️',
      value: 'refactor'
    },
    release: {
      description: 'Create a release commit',
      emoji: '🏹',
      value: 'release'
    },
    style: {
      description: 'UI and style fixes',
      emoji: '💄',
      value: 'style'
    },
    test: {
      description: 'Adding missing tests',
      emoji: '🧪',
      value: 'test'
    },
  }
};
