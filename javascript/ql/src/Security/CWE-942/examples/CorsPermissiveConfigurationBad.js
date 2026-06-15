import { ApolloServer } from 'apollo-server';
var https = require('https'),
    url = require('url');

var server = https.createServer(function () { });

server.on('request', function (req, res) {
    // BAD: origin is too permissive
    const server_1 = new ApolloServer({
        cors: { origin: true }
    });

    let user_origin = url.parse(req.url, true).query.origin;
    // BAD: CORS is controlled by user
    const server_2 = new ApolloServer({
        cors: { origin: user_origin }
    });
});