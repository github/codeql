import fs from 'fs'

const safe = fs.constants.S_IRWXU | fs.constants.S_IRWXG
const unsafe = fs.constants.S_IRWXU | fs.constants.S_IRWXO
const transported = 0o777

fs.createReadStream('/tmp/file1', { mode: safe })
fs.createReadStream('/tmp/file2', { mode: unsafe })
fs.createReadStream('/tmp/file4', { mode: unsafe + 1 })
fs.createReadStream('/tmp/file5', { mode: 0o777 })
fs.createReadStream('/tmp/file6', { mode: transported })
