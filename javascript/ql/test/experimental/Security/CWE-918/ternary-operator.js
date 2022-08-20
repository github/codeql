const express = require('express');
const app = express();

app.use(express.json());

app.get('/direct-ternary-operator', function (req, res) {
    let taintedURL = req.params.url
    
    let v = req.params.url ? req.params.url == "someURL" : false
    if (v) {
        req_frontend_restclient.get(req.params.url) // OK
    }

    let v1 = taintedURL ? taintedURL == "someURL" : false
    if (v1) {
        req_frontend_restclient.get(taintedURL) // OK
    }

    let v2 = taintedURL ? valid(taintedURL) : false
    if (v2) {
        req_frontend_restclient.get(taintedURL) // OK
    }

    let v3 = req.params.url ? valid(req.params.url) : false
    if (v3) {
        req_frontend_restclient.get(req.params.url) // OK
    }

    let v4 = req.params.url == undefined ? false : valid(req.params.url)
    if (v4) {
        req_frontend_restclient.get(req.params.url) // OK
    }

    let v5 = req.params.url == undefined ? true : valid(req.params.url)
    if (v5) {
        req_frontend_restclient.get(req.params.url) // SSRF
    }

    let v6 = req.params.url ? valid(req.params.url) : true
    if (v6) {
        req_frontend_restclient.get(req.params.url) // SSRF
    }

    let f = false
    let v7 = req.params.url ? valid(req.params.url) : true
    if (v7) {
        req_frontend_restclient.get(req.params.url) // SSRF
    }

    let v8 = req.params.url == undefined ? false : valid(req.params.url)
    if (!v8) {
        return
    }
    req_frontend_restclient.get(req.params.url) // OK
})

app.get('/functions', function (req, res) {
    let taintedURL = req.params.url

    if (valid2(taintedURL)) {
        req_frontend_restclient.get(taintedURL) // OK
    }

    if (!invalid(taintedURL)) {
        req_frontend_restclient.get(taintedURL) // False positive
    }

    if (valid2(req.params.url)){
        req_frontend_restclient.get(req.params.url) // OK
    }

    if (!assertAlphanumeric(req.params.url)) {
        return
    }
    req_frontend_restclient.get(req.params.url); // OK
})

app.get('/normal-use-of-ternary-operator', function (req, res) {
    let taintedURL = req.params.url
    
    let url =  valid(req.params.url) ? req.params.url : undefined
    req_frontend_restclient.get(url) // OK

    let url =  valid(taintedURL) ? taintedURL : undefined
    req_frontend_restclient.get(url) // OK

    let url4 = req.params.url.match(/^[\w.-]+$/) ? req.params.url : undefined
    req_frontend_restclient.get(url4) // OK
})

app.get('/throw-errors', function (req, res) {
    req_frontend_restclient.get(valid3(req.params.url)) // False positive

    req_frontend_restclient.get(assertOther(req.params.url)); // False positive

    req_frontend_restclient.get(assertOther2(req.params.url)); // False positive
});

app.get('/bad-endpoint', function (req, res) {
    req_frontend_restclient.get(req.params.url); // SSRF

    const valid = req.params.url ? req.params.url == "someURL" : false
    if (!valid) {
        throw new Error(`Invalid parameter: "${req.params.url}", must be alphanumeric`);
    }
    req_frontend_restclient.get(req.params.url); // OK
})


app.get('/bad-endpoint-variable', function (req, res) {
    let taintedURL = req.params.url
    req_frontend_restclient.get(taintedURL); // SSRF

    const valid = taintedURL ? taintedURL == "someURL" : false
    if (!valid) {
        return
    }
    req_frontend_restclient.get(taintedURL); // False positive
})

app.get('/not-invalid', function (req, res) {
    const invalidParam = req.params.url ? !Number.isInteger(req.params.url) : false
    if (invalidParam) {
        return
    }
    req_frontend_restclient.get(req.params.url); // False positive
})


app.get('/bad-endpoint-2', function (req, res) {
    other(req.params.url)
})

function other(taintedURL) {
    req_frontend_restclient.get(taintedURL); // SSRF

    const valid = taintedURL ? taintedURL == "someURL" : false
    if (!valid) {
        return
    }
    req_frontend_restclient.get(taintedURL); // False positive
}

function assertAlphanumeric(value) {
    return value ? value.match(/^[\w.-]+$/) : false;
}

function assertOther(value) {
    const valid = value ? !!value.match(/^[\w.-]+$/) : false;
    if (!valid) {
      throw new Error(`Invalid parameter: "${value}", must be alphanumeric`);
    }
    return value;
}

function assertOther2(value) {
    const valid = value ? value.match(/^[\w.-]+$/) : false;
    if (!valid) {
      throw new Error(`Invalid parameter: "${value}", must be alphanumeric`);
    }
    return value;
}

function invalid(value) {
    return value ? !Number.isInteger(value) : true 
}

function valid(value) {
    return value.match(/^[\w.-]+$/)
}

function valid2(value) {
    return value ? value == "someURL" : false
}

function valid3(value) {
    const valid = value ? value == "someURL" : false
    if (!valid) {
        throw new Error(`Invalid parameter: "${value}", must be alphanumeric`);
    }
    return value;
}