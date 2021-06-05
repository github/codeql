import fs from 'fs'

const mode = 0o777

fs.writeFileSync('/etc/froznator.conf', '', { mode })
