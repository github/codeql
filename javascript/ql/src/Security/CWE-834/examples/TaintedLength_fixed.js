'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    var obj = req.body;

    calcStuff(obj);
});

function calcStuff(obj) {
    if (!(obj instanceof Array)) { // prevents DOS
        return [];
    }

    var ret = [];
    for (var i = 0; i < obj.length; i++) {
        ret.push(obj[i]);
    }

    return ret;
}