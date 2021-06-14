import moveFile from 'move-file'

moveFile('source', 'destination', { directoryMode: 0o777 })
moveFile('source', 'destination', { directoryMode: 0o700 })
