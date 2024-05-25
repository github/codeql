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

app.get('/jwtDecode', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-decode
    // no signature verification
    jwt_decode(UserToken) // NOT OK
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})

function aJWT() {
    return "A JWT provided by user"
}

(function () {
    const UserToken = aJwt()

    // jwt-decode
    // no signature verification
    jwt_decode(UserToken) // NOT OK
})();