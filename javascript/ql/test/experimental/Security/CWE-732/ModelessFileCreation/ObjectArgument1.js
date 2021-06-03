import fs from 'fs'

fs.createReadStream('/tmp/file1')
fs.createReadStream('/tmp/file2', {})
fs.createReadStream('/tmp/file3', { mode: undefined })
fs.createReadStream('/tmp/file4', { mode: 0o777 })
fs.createReadStream('/tmp/file5', { mode: '777' })
