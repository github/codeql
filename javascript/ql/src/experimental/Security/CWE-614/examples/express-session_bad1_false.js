const app = express()
const session = require('express-session')

app.use(session({
    secret: 'secret',
    cookie: { secure: false } // BAD
}))
