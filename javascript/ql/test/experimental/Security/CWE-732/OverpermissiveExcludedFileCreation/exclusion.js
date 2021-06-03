import fs from 'fs'

const safe = 0o777
  ^ fs.constants.S_IWOTH
  ^ fs.constants.S_IXOTH
const unsafe = 0o777 ^ fs.constants.S_IXOTH

fs.createReadStream('/tmp/file1', {
  mode: safe
})
fs.createReadStream('/tmp/file2', {
  mode: unsafe
})
fs.createReadStream('/tmp/file3', {
  mode: unsafe ^ fs.constants.S_IRWXU
})