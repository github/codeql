import fs from 'fs'
import fsPromises from 'fs/promises'
import fsExtra from 'fs-extra'
import makeDir from 'make-dir'
import mkdirp from 'mkdirp'
import moveFile from 'move-file'
import secureFs from 'secure-fs'
import secureFsPromises from 'secure-fs/promises'

fs.mkdir()
fs.mkdirSync()
fsPromises.mkdir()
fsExtra.ensureDir()
fsExtra.ensureDirSync()
fsExtra.mkdirp()
fsExtra.mkdirpSync()
fsExtra.mkdirs()
fsExtra.mkdirsSync()
makeDir()
makeDir.sync()
mkdirp()
mkdirp.manual()
mkdirp.manualSync()
mkdirp.native()
mkdirp.nativeSync()
mkdirp.sync()
mkdirp.mkdirP()
mkdirp.mkdirp()
moveFile()
moveFile.sync()
secureFs.mkdir()
secureFs.mkdirSync()
secureFsPromises.mkdir()
fs.accessSync()
