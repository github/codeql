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

(function () {
    const REACT_APP = /^REACT_APP_/i;

    function getOnlyReactVariables() {
        const raw = Object.keys(process.env)
            .filter(key => REACT_APP.test(key)) // This filters makes it safe.
            .reduce(
                (env, key) => {
                    env[key] = process.env[key];
                    return env;
                },
                {}
            );
        return raw;
    }

    new webpack.DefinePlugin(getOnlyReactVariables()); // OK

    function getOnlyReactVariables2() {
        const raw = Object.keys(process.env)
            .reduce(
                (env, key) => {
                    if (REACT_APP.test(key)) {
                        env[key] = process.env[key];
                    }
                    return env;
                },
                {}
            );
        return raw;
    }

    new webpack.DefinePlugin(getOnlyReactVariables2()); // OK

    function getOnlyReactVariables3() {
        const raw = Object.keys(process.env)
            .reduce(
                (env, key) => {
                    if (key == ["1", "2", "3"]) {
                        env[key] = process.env[key];
                    }
                    return env;
                },
                {}
            );
        return raw;
    }

    new webpack.DefinePlugin(getOnlyReactVariables3()); // OK
})();