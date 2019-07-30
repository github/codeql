(function() {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser',
        host: 'database.server.com',
        database: 'mydb',
        password: 'secretpassword',
        port: 3211,
    }); // NOT OK
    client.connect();
})();

(function() {
    require("http").request({auth: "user:password"});  // NOT OK
    require("https").request({auth: "user:password"}); // NOT OK
    function getCredentials() {
        return "user:password";
    }
    require("http").request({auth: getCredentials()}); // NOT OK
    require("http").request({auth: getUnknownCredentials()}); // OK
})();

(function() {
    var basicAuth = require('express-basic-auth');

    basicAuth({users: { 'admin': 'supersecret' }});  // NOT OK
    var users = {};
    users['unknown-admin-name'] = 'supersecret';
    basicAuth({users: users})  // NOT OK
})();

(function() {
    var basicAuth = require('basic-auth-connect');
    basicAuth('username', 'password'); // NOT OK
    basicAuth(function(){}); // OK
})();

(function() {
    var AWS = require('aws-sdk');
    AWS.config.update({ accessKeyId: 'username', secretAccessKey: 'password'}); // NOT OK
    new AWS.Config({ accessKeyId: 'username', secretAccessKey: 'password'}); // NOT OK
    var config = new AWS.Config();
    config.update({ accessKeyId: 'username', secretAccessKey: 'password'}); // NOT OK
    var o = {};
    o.secretAccessKey = 'password';
    config.update(o); // NOT OK
})();

(function() {
    var request = require('request');

    request.get(url).auth('username', 'password'); // NOT OK
    request.get(url, { // NOT OK
        'auth': {
            'user': 'username',
            'pass': 'password'
        }
    });

    request.get(url).auth(null, null, _, 'bearerToken'); // NOT OK

    request.get(url, { // NOT OK
        'auth': {
            'bearer': 'bearerToken'
        }
    });

    request.post(url).auth('username', 'password'); // NOT OK
    request.head(url).auth('username', 'password'); // NOT OK

    request(url).auth('username', 'password'); // NOT OK
    request(url, { // NOT OK
        'auth': {
            'user': 'username',
            'pass': 'password'
        }
    });
})();

(function() {
    const MsRest = require('ms-rest-azure');

    MsRest.loginWithUsernamePassword('username', 'password', function(){}); // NOT OK
    MsRest.loginWithUsernamePassword(process.env.AZURE_USER, process.env.AZURE_PASS, function(){}); // OK
    MsRest.loginWithServicePrincipalSecret('username', 'password', function(){}); // NOT OK
})();

(function() {
    var digitalocean = require('digitalocean');
    digitalocean.client('TOKEN'); // NOT OK
    digitalocean.client(process.env.DIGITAL_OCEAN_TOKEN); // OK
})();

(function() {
    var pkgcloud = require('pkgcloud');
    pkgcloud.compute.createClient({ // NOT OK
        account: 'x1',
        keyId: 'x2',
        storageAccount: 'x3',
        username: 'x4',
        key: 'y1',
        apiKey: 'y2',
        storageAccessKey: 'y3',
        password: 'y4',
        token: 'z1'
    });
    pkgcloud.compute.createClient({ // OK
        INNOCENT_DATA: '42'
    });
    pkgcloud.providers.SOME_PROVIDER.compute.createClient({  // NOT OK
        username: 'x5',
        password: 'y5'
    });
    pkgcloud.UNKNOWN_SERVICE.createClient({  // OK
        username: 'x6',
        password: 'y6'
    });
    pkgcloud.providers.SOME_PROVIDER.UNKNOWN_SERVICE.createClient({  // OK
        username: 'x7',
        password: 'y7'
    });
    pkgcloud.compute.createClient({ // OK
        username: process.env.USERNAME,
        password: process.env.PASSWORD
    });
})();

(function(){
    require('crypto').createHmac('sha256', 'crypto secret');
    require("crypto-js/aes").encrypt('my message', 'crypto-js/aes secret');
})()

(function(){
    require("cookie-session")({ secret: "cookie-session secret" });
})()

(function(){
    var request = require('request');
    request.get(url, { // OK
        'auth': {
            'user': '',
            'pass': process.env.PASSWORD
        }
    });
})();

(function(){
    var request = require('request');
    let pass = getPassword() || '';
    request.get(url, { // OK
        'auth': {
            'user': process.env.USER || '',
            'pass': pass,
        }
    });
})();
