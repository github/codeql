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
    var tainted = url.parse(req.url, true).query.url; // $ Source[js/request-forgery]

    request("example.com");

    request(tainted); // $ Alert[js/request-forgery]

    request.get(tainted); // $ Alert[js/request-forgery]

    var options = {};
    options.url = tainted; // $ Sink[js/request-forgery]
    request(options); // $ Alert[js/request-forgery]

    request("http://" + tainted); // $ Alert[js/request-forgery]

    request("http://example.com" + tainted); // $ Alert[js/request-forgery]

    request("http://example.com/" + tainted); // $ Alert[js/request-forgery]

    request("http://example.com/?" + tainted);

    http.get(relativeUrl, {host: tainted}); // $ Alert[js/request-forgery]

    XhrIo.send(new Uri(tainted)); // $ Alert[js/request-forgery]
    new XhrIo().send(new Uri(tainted)); // $ Alert[js/request-forgery]

    let base = require('./config').base;

    request(`http://example.com/${base}/${tainted}`); // $ Alert[js/request-forgery]

    request(`http://example.com/${base}/v1/${tainted}`); // $ Alert[js/request-forgery]

    request('http://example.com/' + base + '/' + tainted); // $ Alert[js/request-forgery]

    request('http://example.com/' + base + ('/' + tainted)); // $ MISSING: Alert

    request(`http://example.com/?${base}/${tainted}`);

    request(`http://example.com/${base}${tainted}`); // OK - assumed safe

    request(`${base}${tainted}`); // OK - assumed safe
})

var CDP = require("chrome-remote-interface");
var server = http.createServer(async function(req, res) {
    var tainted = url.parse(req.url, true).query.url; // $ Source[js/request-forgery]

    var client = await CDP(options);
	client.Page.navigate({url: tainted}); // $ Alert[js/request-forgery]
	
	CDP(options).catch((ignored) => {}).then((client) => {
		client.Page.navigate({url: tainted}); // $ Alert[js/request-forgery]
	})
	
	CDP(options, (client) => {
		client.Page.navigate({url: tainted}); // $ Alert[js/request-forgery]
	});
})

import {JSDOM} from "jsdom";
var server = http.createServer(async function(req, res) {
    var tainted = url.parse(req.url, true).query.url; // $ Source[js/request-forgery]

    JSDOM.fromURL(tainted); // $ Alert[js/request-forgery]
});

var route = require('koa-route');
var Koa = require('koa');
var app = new Koa();

app.use(route.get('/pets', (context, param1, param2, param3) => {  // $ Source[js/request-forgery]
    JSDOM.fromURL(param1); // $ Alert[js/request-forgery]
}));

const router = require('koa-router')();
const app = new Koa();
router.get('/', async (ctx, next) => {
    JSDOM.fromURL(ctx.params.foo); // $ Alert[js/request-forgery]
}).post('/', async (ctx, next) => {
    JSDOM.fromURL(ctx.params.foo); // $ Alert[js/request-forgery]
});
app.use(router.routes());

import {JSDOM} from "jsdom";
var server = http.createServer(async function(req, res) {
    var tainted = url.parse(req.url, true).query.url; // $ Source[js/request-forgery]

    new WebSocket(tainted); // $ Alert[js/request-forgery]
});


import * as ws from 'ws';

new ws.Server({ port: 8080 }).on('connection', function(socket, request) {
  socket.on('message', function(message) {
    const url = request.url; // $ Source[js/request-forgery]
    const socket = new ws(url); // $ Alert[js/request-forgery]
  });
});

new ws.Server({ port: 8080 }).on('connection', function (socket, request) {
  socket.on('message', function (message) {
    const url = new URL(request.url, base); // $ Source[js/request-forgery]
    const target = new URL(url.pathname, base);
    const socket = new ws(url); // $ Alert[js/request-forgery]
  });
});


var server2 = http.createServer(function(req, res) {
    var tainted = url.parse(req.url, true).query.url; // $ Source[js/request-forgery]

    axios({
        method: 'get',
        url: tainted // $ Sink[js/request-forgery]
    }) // $ Alert[js/request-forgery]

    var myUrl = `${something}/bla/${tainted}`; 
    axios.get(myUrl); // $ Alert[js/request-forgery]

    var myEncodedUrl = `${something}/bla/${encodeURIComponent(tainted)}`; 
    axios.get(myEncodedUrl);
})

var server2 = http.createServer(function(req, res) {
  const { URL } = require('url'); 
  const input = req.query.url; // $MISSING:Source[js/request-forgery]
  const target = new URL(input);
  axios.get(target.toString()); // $MISSING:Alert[js/request-forgery]
  axios.get(target); // $MISSING:Alert[js/request-forgery]
  axios.get(target.href); // $MISSING:Alert[js/request-forgery]
});
