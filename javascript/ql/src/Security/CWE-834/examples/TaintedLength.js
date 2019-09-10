'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    var obj = req.body;

    calcStuff(obj);
});

function calcStuff(obj) {
    var ret = [];

    // potential DOS if obj.length is large.
    for (var i = 0; i < obj.length; i++) {
        ret.push(obj[i]);
    }

    return ret;
}