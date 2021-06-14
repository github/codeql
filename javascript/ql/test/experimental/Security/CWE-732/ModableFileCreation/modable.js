import fs from 'fs'
import fsExtra from 'fs-extra'
import fsPromises from 'fs/promises'
import jsonfile from 'jsonfile'
import secureFs from 'secure-fs'
import secureFsPromises from 'secure-fs/promises'

fs.createReadStream('/tmp/file1')
fs.createWriteStream('/tmp/file2')
fs.open('/tmp/file3', () => {})
fs.openSync('/tmp/file4')
fsPromises.open('/tmp/file5')
fs.appendFile('/tmp/file6', '', () => {})
fs.appendFileSync('/tmp/file7', '')
fs.writeFile('/tmp/file8', '', () => {})
fs.writeFileSync('/tmp/file9', '')
fsPromises.appendFile('/tmp/file10', '')
fsPromises.writeFile('/tmp/file11', '')
jsonfile.writeFile('/tmp/file12', {}, () => {})
jsonfile.writeFileSync('/tmp/file13', {})
fsExtra.writeJSON('/tmp/file14', {})
fsExtra.writeJSONSync('/tmp/file15', {})
fsExtra.writeJson('/tmp/file16', {})
fsExtra.writeJsonSync('/tmp/file17', {})
secureFs.createReadStream('/tmp/file')
secureFs.createWriteStream('/tmp/file')
secureFs.open('/tmp/file', () => {})
secureFs.openSync('/tmp/file')
secureFsPromises.open('/tmp/file')
secureFs.appendFile('/tmp/file', '', () => {})
secureFs.appendFileSync('/tmp/file', '')
secureFs.writeFile('/tmp/file', '', () => {})
secureFs.writeFileSync('/tmp/file', '')
secureFsPromises.appendFile('/tmp/file', '')
secureFsPromises.writeFile('/tmp/file', '')
fs.accessSync('/tmp/none')
