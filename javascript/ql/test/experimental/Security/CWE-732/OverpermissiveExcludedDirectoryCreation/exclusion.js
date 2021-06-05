import fs from 'fs'

const safe = 0o777 & ~fs.constants.S_IRWXO
const unsafe = 0o777 & ~fs.constants.S_IRWXG
const transported = 0o777

fs.mkdir('/tmp/dir1', safe, () => {})
fs.mkdir('/tmp/dir2', unsafe, () => {})
fs.mkdir('/tmp/dir3', unsafe ^ fs.constants.S_IRWXO, () => {})
fs.mkdir('/tmp/dir4', unsafe - 1, () => {})
fs.mkdir('/tmp/dir5', 0o777, () => {})
fs.mkdir('/tmp/dir6', transported, () => {})
