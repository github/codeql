import fs from 'fs'

fs.mkdirSync('/etc/froznator', {
    mode: 0o777 & ~fs.constants.S_IRWXG & ~fs.constants.S_IRWXO
})
