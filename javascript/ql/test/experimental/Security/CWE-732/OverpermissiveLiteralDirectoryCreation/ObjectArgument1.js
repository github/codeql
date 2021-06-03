import makeDir from 'make-dir'

makeDir('/tmp/dir1', { mode: 0o777 })
makeDir('/tmp/dir2', { mode: '777' })
makeDir('/tmp/dir3', { mode: 0o700 })
makeDir('/tmp/dir4', { mode: '700' })
