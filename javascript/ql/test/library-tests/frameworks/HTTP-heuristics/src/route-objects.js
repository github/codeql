var express = require('express');
var app = express();

var route1 = {
    method: 'post',
    url: '/foo',
    middleWares: [function(req, res){}],
    handler(req, res) {

    }
};

app[route1.method](route1.url, route1.middleWares, route1.handler);


var routes = [
    {
        method: 'post',
        url: '/foo',
        handler(req, res) {

        }
    },
    {
        method: 'post',
        url: '/foo',
        handler(req, res) {

        }
    }
];
routes.forEach((route) => {
    app[route.method](route.url, route.handler);
});


var route2 = {
    method: 'POST',
    url: '/foo',
    handler(req, res) {

    }
};

app[route2.method.toLowerCase()](route2.url, route2.handler);

var route3 = {
    method: 'post',
    url: '/foo',
    handler(req, res) {

    }
};

function wrap(f){
    return function(req, res){
        f(req);
    }
}
app[route3.method](route3.url, wrap(route3.handler));
confuse(wrap); // confuse the type inference
