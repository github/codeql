import fs from 'fs'
import fsExtra from 'fs-extra'
import fsPromises from 'fs/promises'
import jsonfile from 'jsonfile'

fs.createReadStream('/tmp/file1')
fs.createWriteStream('/tmp/file2')
fs.open('/tmp/file3', () => {})
fs.openSync('/tmp/file4')
fsPromises.open('/tmp/file5')
fs.appendFile('/tmp/file6', '', () => {})
fs.appendFileSync('/tmp/file7', '')
fs.writeFile('/tmp/file8', '', () => {})
fs.writeFileSync('/tmp/file9', '')
fsPromises.appendFile('tmp/file10', '')
fsPromises.writeFile('tmp/file11', '')
jsonfile.writeFile('/tmp/file12', {}, () => {})
jsonfile.writeFileSync('/tmp/file13', {})
fsExtra.writeJSON('/tmp/file14', {})
fsExtra.writeJSONSync('/tmp/file15', {})
fsExtra.writeJson('/tmp/file16', {})
fsExtra.writeJsonSync('/tmp/file17', {})
fs.accessSync('/tmp/none')
