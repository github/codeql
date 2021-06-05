import fs from 'fs'

const mode = 0o700

fs.mkdirSync('/etc/froznator', { mode })
