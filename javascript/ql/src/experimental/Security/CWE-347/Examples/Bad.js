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
app.get('/jose', (req, res) => {
    const UserToken = req.headers.authorization;
    // BAD: no signature verification
    jose.decodeJwt(UserToken)
})

app.get('/jwtDecode', (req, res) => {
    const UserToken = req.headers.authorization;
    // BAD: no signature verification
    jwt_decode(UserToken)
})

app.get('/jwtSimple', (req, res) => {
    const UserToken = req.headers.authorization;
    // jwt.decode(token, key, noVerify, algorithm)
    // BAD: no signature verification
    jwt_simple.decode(UserToken, getSecret(), true);
})

app.get('/jwtJsonwebtoken', (req, res) => {
    const UserToken = req.headers.authorization;
    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken)
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
