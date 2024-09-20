const express = require('express')
const jwt_decode = require('jwt-decode');

function getSecret() {
    return "A Safe generated random key"
}

function aJWT() {
    return "A JWT provided by user"
}

(function () {
    const UserToken = aJwt()

    // jwt-decode
    // no signature verification
    jwt_decode(UserToken) // NOT OK
})();