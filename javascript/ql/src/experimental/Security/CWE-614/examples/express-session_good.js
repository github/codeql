const app = express()
const session = require('express-session')

app.set('trust proxy', 1)

app.use(session({
    secret: 'secret',
    cookie: { secure: true } // GOOD
}))
