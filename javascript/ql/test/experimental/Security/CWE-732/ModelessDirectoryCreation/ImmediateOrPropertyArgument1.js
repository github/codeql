import fs from 'fs'

fs.mkdir('/tmp/dir1', () => {})
fs.mkdir('/tmp/dir2', undefined, () => {})
fs.mkdir('/tmp/dir3', 0o777, () => {})
fs.mkdir('/tmp/dir4', '777', () => {})
fs.mkdir('/tmp/dir5', {}, () => {})
fs.mkdir('/tmp/dir6', { mode: undefined }, () => {})
fs.mkdir('/tmp/dir7', { mode: 0o777 }, () => {})
fs.mkdir('/tmp/dir8', { mode: '777' }, () => {})
