import fs from 'fs'

fs.writeFileSync('/etc/froznator.conf', '', {
    mode: 0o777 & ~fs.constants.S_IRWXG
})
