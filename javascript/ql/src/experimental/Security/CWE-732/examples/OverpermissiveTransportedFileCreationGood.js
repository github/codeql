import fs from 'fs'

const mode = 0o600

fs.writeFileSync('/etc/froznator.conf', '', { mode })
