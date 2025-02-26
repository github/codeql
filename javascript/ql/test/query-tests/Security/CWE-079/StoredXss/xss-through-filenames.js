var http = require('http');
var fs = require('fs');

var express = require('express');

express().get('/', function(req, res) {
    fs.readdir("/myDir", function (error, files1) { // $ Source
        res.send(files1); // $ Alert
    });
});

/**
 * The essence of a real world vulnerability.
 */
http.createServer(function (req, res) {

    function format(files2) {
        var files3 = [];
        files2.sort(sort).forEach(function (file) {
            files3.push('<li>' + file + '</li>');
        });
        return files3.join('');
    }

    fs.readdir("/myDir", function (error, files1) { // $ Source
        res.write(files1); // $ Alert

        var dirs = [];
        var files2 = [];
        files1.forEach(function (file) {
            files2.push(file);
        });
        res.write(files2); // $ Alert

        var files3 = format(files2);

        res.write(files3);  // $ Alert

    });
});
