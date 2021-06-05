import fs from 'fs'

const unsafe = 0o777
const safe = 0o600

fs.createReadStream('/tmp/file1', { mode: unsafe })
fs.createReadStream('/tmp/file2', { mode: safe })
fs.open('/tmp/file3', 'r', unsafe, () => {})
fs.open('/tmp/file4', 'r', safe, () => {})
fs.writeFile('/tmp/file5', '', { mode: unsafe }, () => {})
fs.writeFile('/tmp/file6', '', { mode: safe }, () => {})
fs.open('/tmp/file7', 'r', 0o777)
