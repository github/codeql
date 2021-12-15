'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

var _ = require("lodash");

rootRoute.post(function(req, res) {
    nullPointer(req.body);
});

function nullPointer(val) {
    var ret = [];

    // Has obvious null-pointer. And guards the next loop.
    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i].foo);
    }

    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i]);
    }
}
