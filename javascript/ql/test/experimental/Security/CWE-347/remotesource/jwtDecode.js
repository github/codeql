const express = require('express')
const app = express()
const jwt_decode = require('jwt-decode');
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
