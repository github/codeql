import fs from 'fs'

fs.writeFileSync('/etc/froznator.conf', '', { mode: 0o600 })
