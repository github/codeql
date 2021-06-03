import fs from 'fs'

fs.open('/tmp/file1', 'r', 0o777, () => {})
fs.open('/tmp/file2', 'r', 0o600, () => {})
