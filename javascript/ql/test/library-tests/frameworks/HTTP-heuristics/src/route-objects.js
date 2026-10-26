var express = require('express');
var app = express();

var route1 = {
    method: 'post',
    url: '/foo',
    middleWares: [function(req, res){}], // $ Alert[js/unpromoted-route-handler-candidate]
    handler(req, res) {

    } // $ Alert[js/unpromoted-route-handler-candidate]
};

app[route1.method](route1.url, route1.middleWares, route1.handler);


var routes = [
    {
        method: 'post',
        url: '/foo',
        handler(req, res) {

        } // $ Alert[js/unpromoted-route-handler-candidate]
    },
    {
        method: 'post',
        url: '/foo',
        handler(req, res) {

        } // $ Alert[js/unpromoted-route-handler-candidate]
    }
];
routes.forEach((route) => {
    app[route.method](route.url, route.handler);
});


var route2 = {
    method: 'POST',
    url: '/foo',
    handler(req, res) {

    } // $ Alert[js/unpromoted-route-handler-candidate]
};

app[route2.method.toLowerCase()](route2.url, route2.handler);

var route3 = {
    method: 'post',
    url: '/foo',
    handler(req, res) {

    } // $ Alert[js/unpromoted-route-handler-candidate]
};

function wrap(f){
    return function(req, res){
        f(req);
    } // $ Alert[js/unpromoted-route-handler-candidate]
}
app[route3.method](route3.url, wrap(route3.handler));
confuse(wrap); // confuse the type inference
