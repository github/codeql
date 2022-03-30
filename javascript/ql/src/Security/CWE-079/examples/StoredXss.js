var express = require('express'),
    fs = require('fs');

express().get('/list-directory', function(req, res) {
    fs.readdir('/public', function (error, fileNames) {
        var list = '<ul>';
        fileNames.forEach(fileName => {
            // BAD: `fileName` can contain HTML elements
            list += '<li>' + fileName + '</li>';
        });
        list += '</ul>'
        res.send(list);
    });
});
