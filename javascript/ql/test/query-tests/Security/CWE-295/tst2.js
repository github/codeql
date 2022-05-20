const request = require('request');

let requestOptions = {
    headers: {
        "content-type": "application/json",
        "accept": "application/json"
    },
    rejectUnauthorized: false,
    requestCert: true,
    agent: false
}

module.exports.post = (url, requestBody, apiContext) => {
    Object.assign(requestOptions, {
        body: JSON.stringify(requestBody),
        headers : Object.assign(requestOptions.headers, apiContext)
    })

    return request.post(url, requestOptions).then((res) => {
        return Promise.resolve(res.body);
    }).catch((err) => {
        return Promise.resolve(err);
    })
}