'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

var global;

rootRoute.post(function(req, res) {
    for (i = 0; i < req.body.personas.length; i++) {
        req.body.personas[i].parentesco.id;
    }
});
