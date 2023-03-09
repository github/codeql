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

var route = require('koa-route');
var Koa = require('koa');
var app = new Koa();

app.use(route.get('/pets', (context, param1, param2, param3) => { 
    JSDOM.fromURL(param1); // NOT OK
}));

const router = require('koa-router')();
const app = new Koa();
router.get('/', async (ctx, next) => {
    JSDOM.fromURL(ctx.params.foo); // NOT OK
}).post('/', async (ctx, next) => {
    JSDOM.fromURL(ctx.params.foo); // NOT OK
});
app.use(router.routes());

import {JSDOM} from "jsdom";
var server = http.createServer(async function(req, res) {
    var tainted = url.parse(req.url, true).query.url;

    new WebSocket(tainted); // NOT OK
});


import * as ws from 'ws';

new ws.Server({ port: 8080 }).on('connection', function(socket, request) {
  socket.on('message', function(message) {
    const url = request.url;
    const socket = new ws(url);
  });
});

new ws.Server({ port: 8080 }).on('connection', function (socket, request) {
  socket.on('message', function (message) {
    const url = new URL(request.url, base);
    const target = new URL(url.pathname, base);
    const socket = new ws(url);
  });
});


var server2 = http.createServer(function(req, res) {
    var tainted = url.parse(req.url, true).query.url;

    axios({
        method: 'get',
        url: tainted // NOT OK
    })

    var myUrl = `${something}/bla/${tainted}`; 
    axios.get(myUrl); // NOT OK

    var myEncodedUrl = `${something}/bla/${encodeURIComponent(tainted)}`; 
    axios.get(myEncodedUrl); // OK
})