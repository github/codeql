import fs from 'fs'

const safe = fs.constants.S_IRWXU | fs.constants.S_IRWXG
const unsafe = fs.constants.S_IWOTH | fs.constants.S_IXOTH

fs.mkdir('/tmp/dir1', { mode: safe }, () => {})
fs.mkdir('/tmp/dir2', { mode: unsafe }, () => {})
