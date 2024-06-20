const express = require('express')
const jwt_simple = require('jwt-simple');

function getSecret() {
    return "A Safe generated random key"
}

function aJWT() {
    return "A JWT provided by user"
}

(function () {
    const UserToken = aJwt()

    // BAD: no signature verification
    jwt_simple.decode(UserToken, getSecret(), true); // NOT OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: all with with signature verification
    jwt_simple.decode(UserToken, getSecret(), false); // OK
    jwt_simple.decode(UserToken, getSecret()); // OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwt_simple.decode(UserToken, getSecret(), true); // OK
    jwt_simple.decode(UserToken, getSecret()); // OK
})();