import makeDir from 'make-dir'

makeDir('/tmp/dir1')
makeDir('/tmp/dir2', {})
makeDir('/tmp/dir3', { mode: undefined })
makeDir('/tmp/dir4', { mode: 0o777 })
makeDir('/tmp/dir6', { mode: '777' })
