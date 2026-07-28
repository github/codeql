const express = require('express')
const jwtJsonwebtoken = require('jsonwebtoken');

function getSecret() {
    return "A Safe generated random key"
}

function aJWT() {
    return "A JWT provided by user"
}

(function () {
    const UserToken = aJwt() // $ Alert

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken) // $ Sink // NOT OK
})();

(function () {
    const UserToken = aJwt() // $ Alert

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken) // $ Sink // NOT OK
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256", "none"] }) // $ Sink // NOT OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: with signature verification
    jwtJsonwebtoken.verify(UserToken, getSecret())  // OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken)  // OK
    jwtJsonwebtoken.verify(UserToken, getSecret())  // OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken) // OK
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256"] }) // OK
})();