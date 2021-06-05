import fs from 'fs'

const safe = 0o777 & ~fs.constants.S_IRWXO
const unsafe = 0o777 & ~fs.constants.S_IRWXG
const transported = 0o777

fs.createReadStream('/tmp/file1', { mode: safe })
fs.createReadStream('/tmp/file2', { mode: unsafe })
fs.createReadStream('/tmp/file3', { mode: unsafe ^ fs.constants.S_IRWXO })
fs.createReadStream('/tmp/file4', { mode: unsafe + 1 })
fs.createReadStream('/tmp/file5', { mode: 0o777 })
fs.createReadStream('/tmp/file6', { mode: transported })
