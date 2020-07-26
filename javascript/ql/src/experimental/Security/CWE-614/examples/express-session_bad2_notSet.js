const app = express()
const session = require('express-session')

app.use(session({
    secret: 'secret'
    // BAD: in this case the default value of `secure` flag is `false`
}))