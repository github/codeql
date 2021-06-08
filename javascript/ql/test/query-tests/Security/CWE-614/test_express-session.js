const express = require('express')
const app = express()
const session = require('express-session')

app.use(session({
    secret: 'secret',
    cookie: { secure: false } // NOT OK
}))

app.use(session({
    secret: 'secret'
    // NOT OK
}))

app.use(session({
    secret: 'secret',
    cookie: {} // NOT OK
}))

const sess = {
    secret: 'secret',
    cookie: { secure: false } // NOT OK
}

app.use(session(sess))


app.set('trust proxy', 1)
app.use(session({
    secret: 'secret',
    cookie: { secure: true } // OK
}))

