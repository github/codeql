import fs from 'secure-fs-extra'

fs.outputFile('/tmp/file', '', { dirMode: 0o777 })
fs.outputFile('/tmp/file', '', { dirMode: '777' })
fs.outputFile('/tmp/file', '', { dirMode: 0o700 })
fs.outputFile('/tmp/file', '', { dirMode: '700' })
