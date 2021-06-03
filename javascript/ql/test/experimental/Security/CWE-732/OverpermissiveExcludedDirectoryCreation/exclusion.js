import fs from 'fs'

const safe = 0o777
  ^ fs.constants.S_IWOTH
  ^ fs.constants.S_IXOTH
const unsafe = 0o777 ^ fs.constants.S_IRWXG
const unsafeMasked = 0o777 & ~fs.constants.S_IRWXG

fs.mkdir('/tmp/dir1', safe, () => {})
fs.mkdir('/tmp/dir2', unsafe, () => {})
fs.mkdir('/tmp/dir3', unsafeMasked & ~fs.constants.S_IRWXU + 1, () => {})
