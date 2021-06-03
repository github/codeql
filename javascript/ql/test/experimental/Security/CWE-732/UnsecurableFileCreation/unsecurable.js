import fsExtra from 'fs-extra'
import trash from 'trash'

fsExtra.createFile('/tmp/file1')
fsExtra.createFileSync('/tmp/file2')
fsExtra.ensureFile('/tmp/file3')
fsExtra.ensureFileSync('/tmp/file4')
trash('/tmp/file5')
fsExtra.accessSync('/tmp/none')
