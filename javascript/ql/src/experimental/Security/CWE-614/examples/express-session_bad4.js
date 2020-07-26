const app = express()
const session = require('express-session')

const sess = {
    secret: 'secret',
    cookie: { secure: false } // BAD
}

app.use(session(sess))