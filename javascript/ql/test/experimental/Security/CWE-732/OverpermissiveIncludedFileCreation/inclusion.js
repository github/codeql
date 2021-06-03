import fs from 'fs'

const safe = fs.constants.S_IRWXU | fs.constants.S_IRWXG
const unsafe = fs.constants.S_IWOTH | fs.constants.S_IXOTH

fs.createReadStream('/tmp/file1', {
  mode: safe
})
fs.createReadStream('/tmp/file2', {
  mode: unsafe
})
