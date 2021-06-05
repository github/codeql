import fs from 'fs'

fs.writeFileSync('/etc/froznator.conf', '', {
    mode: fs.constants.S_IRWXU | fs.constants.S_IRWXG | fs.constants.S_IRWXO
})
