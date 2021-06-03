import fs from 'fs'

fs.writeFile('/tmp/file1', '', () => {})
fs.writeFile('/tmp/file2', '', {}, () => {})
fs.writeFile('/tmp/file3', '', { mode: undefined }, () => {})
fs.writeFile('/tmp/file4', '', { mode: 0o777 }, () => {})
fs.writeFile('/tmp/file5', '', { mode: '777' }, () => {})
