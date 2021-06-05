import fs from 'fs'

const mode = 0o777

fs.mkdirSync('/etc/froznator', { mode })
