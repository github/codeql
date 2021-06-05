import fs from 'fs'

const unsafe = 0o777
const safe = 0o700

fs.mkdir('/tmp/dir1', unsafe, () => {})
fs.mkdir('/tmp/dir2', { mode: unsafe }, () => {})
fs.mkdir('/tmp/dir3', safe, () => {})
fs.mkdir('/tmp/dir4', { mode: safe }, () => {})
fs.mkdir('/tmp/dir5', { mode: 0o777 }, () => {})
