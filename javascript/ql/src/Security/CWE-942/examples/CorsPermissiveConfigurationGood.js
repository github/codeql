import { ApolloServer } from 'apollo-server';
var https = require('https'),
    url = require('url');

var server = https.createServer(function () { });

server.on('request', function (req, res) {
    // GOOD: origin is restrictive
    const server_1 = new ApolloServer({
        cors: { origin: false }
    });

    let user_origin = url.parse(req.url, true).query.origin;
    // GOOD: user data is properly sanitized
    const server_2 = new ApolloServer({
        cors: { origin: (user_origin === "https://allowed1.com" || user_origin === "https://allowed2.com") ? user_origin : false }
    });
});