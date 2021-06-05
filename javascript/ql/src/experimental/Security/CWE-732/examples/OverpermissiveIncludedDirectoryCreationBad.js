import fs from 'fs'

fs.mkdirSync('/etc/froznator', {
    mode: fs.constants.S_IRWXU | fs.constants.S_IRWXG | fs.constants.S_IRWXO
})
