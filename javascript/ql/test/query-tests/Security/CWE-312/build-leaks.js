const webpack = require("webpack");


var plugin = new webpack.DefinePlugin({ // NOT OK
    "process.env": JSON.stringify(process.env)
});

// OK
new webpack.DefinePlugin({ 'process.env': JSON.stringify({ DEBUG: process.env.DEBUG }) })


function getEnv(env) {
    const raw = Object.keys(process.env)
        .reduce((env, key) => {
            env[key] = process.env[key]
            return env
        }, {
            NODE_ENV: process.env.NODE_ENV || env || 'development'
        })

    const stringifed = {
        'process.env': Object.keys(raw).reduce((env, key) => {
            env[key] = JSON.stringify(raw[key])
            return env
        }, {})
    }

    return {
        raw: raw,
        stringified: stringifed
    }
}

new webpack.DefinePlugin(getEnv('production').stringified); // NOT OK

var https = require('https');
var url = require('url');

var server = https.createServer(function (req, res) {
    let pw = url.parse(req.url, true).query.current_password;
    var plugin = new webpack.DefinePlugin({ "process.env.secret": JSON.stringify(pw) }); // NOT OK
});
