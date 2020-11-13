import request from 'request';
import requestPromise from 'request-promise';
import superagent from 'superagent';
import http from 'http';
import express from 'express';
import axios from 'axios';
import got from 'got';
import nodeFetch from 'node-fetch';
import url from 'url';
let XhrIo = goog.require('goog.net.XhrIo');
let Uri = goog.require('goog.Uri');

var server = http.createServer(function(req, res) {
    var tainted = url.parse(req.url, true).query.url;

    request("example.com"); // OK

    request(tainted); // NOT OK

    request.get(tainted); // NOT OK

    var options = {};
    options.url = tainted; // NOT OK
    request(options);

    request("http://" + tainted); // NOT OK

    request("http://example.com" + tainted); // NOT OK

    request("http://example.com/" + tainted); // NOT OK

    request("http://example.com/?" + tainted); // OK

    http.get(relativeUrl, {host: tainted}); // NOT OK

    XhrIo.send(new Uri(tainted)); // NOT OK
    new XhrIo().send(new Uri(tainted)); // NOT OK

    let base = require('./config').base;

    request(`http://example.com/${base}/${tainted}`); // NOT OK

    request(`http://example.com/${base}/v1/${tainted}`); // NOT OK

    request('http://example.com/' + base + '/' + tainted); // NOT OK

    request('http://example.com/' + base + ('/' + tainted)); // NOT OK - but not flagged [INCONSISTENCY]

    request(`http://example.com/?${base}/${tainted}`); // OK

    request(`http://example.com/${base}${tainted}`); // OK - assumed safe

    request(`${base}${tainted}`); // OK - assumed safe
})

var CDP = require("chrome-remote-interface");
var server = http.createServer(async function(req, res) {
    var tainted = url.parse(req.url, true).query.url;

    var client = await CDP(options);
	client.Page.navigate({url: tainted}); // NOT OK.
	
	CDP(options).catch((ignored) => {}).then((client) => {
		client.Page.navigate({url: tainted}); // NOT OK.	
	})
	
	CDP(options, (client) => {
		client.Page.navigate({url: tainted}); // NOT OK.	
	});
})

import {JSDOM} from "jsdom";
var server = http.createServer(async function(req, res) {
    var tainted = url.parse(req.url, true).query.url;

    JSDOM.fromURL(tainted); // NOT OK
});