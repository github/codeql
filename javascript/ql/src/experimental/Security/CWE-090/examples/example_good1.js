const http = require('http');
const url = require('url');
const ldap = require('ldapjs');
const client = ldap.createClient({
    url: 'ldap://127.0.0.1:1389'
});


// https://github.com/vesse/node-ldapauth-fork/commit/3feea43e243698bcaeffa904a7324f4d96df60e4
const sanitizeInput = function (input) {
    return input
        .replace(/\*/g, '\\2a')
        .replace(/\(/g, '\\28')
        .replace(/\)/g, '\\29')
        .replace(/\\/g, '\\5c')
        .replace(/\0/g, '\\00')
        .replace(/\//g, '\\2f');
};

const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true);

    let username = q.query.username;

    // GOOD
    username = sanitizeInput(username);

    client.search('o=example', { filter: `(|(name=${username})(username=${username}))` }, function (err, res) {
    });

});
