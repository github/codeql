var express = require('express'),
    fs = require('fs'),
    escape = require('escape-html');

express().get('/list-directory', function(req, res) {
    fs.readdir('/public', function (error, fileNames) {
        var list = '<ul>';
        fileNames.forEach(fileName => {
            list += '<li>' + escape(fileName) '</li>'; // GOOD: escaped `fileName` can not contain HTML elements
        });
        list += '</ul>'
        res.send(list);
    });
});
