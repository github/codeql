import fs from 'fs'

fs.appendFile('/tmp/file1', '', { mode: 0o777 }, () => {})
fs.appendFile('/tmp/file2', '', { mode: 0o600 }, () => {})
