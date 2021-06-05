import fs from 'fs'

const safe = fs.constants.S_IRWXU | fs.constants.S_IRWXG
const unsafe = fs.constants.S_IRWXU | fs.constants.S_IRWXO
const transported = 0o777

fs.mkdir('/tmp/dir1', { mode: safe }, () => {})
fs.mkdir('/tmp/dir2', { mode: unsafe }, () => {})
fs.mkdir('/tmp/dir3', { mode: unsafe - 1 }, () => {})
fs.mkdir('/tmp/dir4', { mode: 0o777 }, () => {})
fs.mkdir('/tmp/dir5', { mode: transported }, () => {})
