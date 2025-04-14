const express = require('express')
const app = express()
const jwtJsonwebtoken = require('jsonwebtoken');
const port = 3000

function getSecret() {
    return "A Safe generated random key"
}
app.get('/jwtJsonwebtoken1', (req, res) => {
    const UserToken = req.headers.authorization;

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken) // NOT OK
})

app.get('/jwtJsonwebtoken2', (req, res) => {
    const UserToken = req.headers.authorization;

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken) // NOT OK
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256", "none"] }) // NOT OK
})

app.get('/jwtJsonwebtoken3', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: with signature verification
    jwtJsonwebtoken.verify(UserToken, getSecret()) // OK
})

app.get('/jwtJsonwebtoken4', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken) // OK
    jwtJsonwebtoken.verify(UserToken, getSecret()) // OK
})

app.get('/jwtJsonwebtoken5', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken) // OK
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256"] }) // OK
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
