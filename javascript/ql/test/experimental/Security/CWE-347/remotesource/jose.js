const express = require('express')
const app = express()
const jose = require('jose')
const port = 3000

function getSecret() {
    return "A Safe generated random key"
}

app.get('/jose1', (req, res) => {
    const UserToken = req.headers.authorization;
    // no signature verification
    jose.decodeJwt(UserToken) // NOT OK
})


app.get('/jose2', async (req, res) => {
    const UserToken = req.headers.authorization;
    // with signature verification
    await jose.jwtVerify(UserToken, new TextEncoder().encode(getSecret())) // OK
})

app.get('/jose3', async (req, res) => {
    const UserToken = req.headers.authorization;
    // first without signature verification then with signature verification for same UserToken
    jose.decodeJwt(UserToken)  // OK
    await jose.jwtVerify(UserToken, new TextEncoder().encode(getSecret())) // OK
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
