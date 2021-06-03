import fs from 'fs'

fs.open('/tmp/file1', () => {})
fs.open('/tmp/file2', 'r', () => {})
fs.open('/tmp/file3', 'r', undefined, () => {})
fs.open('/tmp/file4', 'r', 0o777, () => {})
fs.open('/tmp/file5', 'r', '777', () => {})
