import fs from 'fs'

fs.createReadStream('/tmp/file1', { mode: 0o777 })
fs.createReadStream('/tmp/file2', { mode: 0o600 })
