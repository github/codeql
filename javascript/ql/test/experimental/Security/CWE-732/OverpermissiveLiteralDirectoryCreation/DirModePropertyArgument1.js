import fs from 'secure-fs-extra'

fs.ensureFile('/tmp/file', { dirMode: 0o777 })
fs.ensureFile('/tmp/file', { dirMode: '777' })
fs.ensureFile('/tmp/file', { dirMode: 0o700 })
fs.ensureFile('/tmp/file', { dirMode: '700' })
