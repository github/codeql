const express = require('express')
const app = express()
const jwtJsonwebtoken = require('jsonwebtoken');
const jwt_decode = require('jwt-decode');
const jwt_simple = require('jwt-simple');
const jose = require('jose')
const port = 3000

function getSecret() {
    return "A Safe generated random key"
}
app.get('/jwtJsonwebtoken1', (req, res) => {
    const UserToken = req.headers.authorization;

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken)
})

app.get('/jwtJsonwebtoken2', (req, res) => {
    const UserToken = req.headers.authorization;

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken)
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256", "none"] })
})

app.get('/jwtJsonwebtoken3', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: with signature verification
    jwtJsonwebtoken.verify(UserToken, getSecret())
})

app.get('/jwtJsonwebtoken4', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken)
    jwtJsonwebtoken.verify(UserToken, getSecret())
})

app.get('/jwtJsonwebtoken5', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken)
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256"] })
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
