import fs from 'fs'

fs.mkdirSync('/etc/froznator', { recursive: true, mode: 0o700 })
fs.writeFileSync('/etc/froznator/main.conf', '', { mode: 0o600 })
