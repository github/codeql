import fs from 'fs'

fs.mkdir('/tmp/dir1', 0o777, () => {})
fs.mkdir('/tmp/dir2', '777', () => {})
fs.mkdir('/tmp/dir3', 0o700, () => {})
fs.mkdir('/tmp/dir4', '700', () => {})
fs.mkdir('/tmp/dir5', { mode: 0o777 }, () => {})
fs.mkdir('/tmp/dir6', { mode: '777' }, () => {})
fs.mkdir('/tmp/dir7', { mode: 0o700 }, () => {})
fs.mkdir('/tmp/dir8', { mode: '700' }, () => {})
