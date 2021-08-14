import request from 'request';
import requestPromise from 'request-promise';
import superagent from 'superagent';
import http from 'http';
import express from 'express';
import axios from 'axios';
import got from 'got';
import nodeFetch from 'node-fetch';
import {ClientRequest, net} from 'electron';
(function() {
    request(url);

    request.get(url);

    request.delete(url);

    request({ url: url });

    requestPromise(url);

    superagent.get(url);

    http.get(url);

    axios(url);

    axios.get(url);

    axios({ url: url });

    got(url);

    got.stream(url);

    window.fetch(url);

    nodeFetch(url);

    net.request(url);

    net.request({ url: url });

    new ClientRequest(url);

    new ClientRequest({ url: url });

    unknown(url);

    unknown({ url:url });
});

(function() {
    axios({data: data});

    axios.get(x, {data: not_data});

    axios.post(x, data1, {data: data2});

    axios({headers: headerData, params: paramsData});

    window.fetch(url, {headers: headerData, body: bodyData});

    got(url, {headers: headerData, body: bodyData, quer: queryData});

    superagent.get(url).query(data);
    superagent.get(url).set('x', headerData)
    superagent.post(url).send(bodyData);
    superagent.get(url).set('x', headerData).query(queryData);
    superagent.get(url).unknown(nonData).query(queryData);

});

(function() {
    $.ajax(url, {data: data});
    $.ajax({url: url, tdata: data});

    $.getJSON(url, {data: data}); // the entire "{data: data}" object is the data. 
    $.getJSON({url: url, tdata: data}); // not how to use getJSON.

    var xhr = new XMLHttpRequest();
    xhr.open(_, url);
    xhr.send(data);
});

(function() {

    http.get(relativeUrl, {host: host});

    axios({host: host});

    got(relativeUrl, {host: host});

    net.request({ hostname: host });

});

(function() {
    var xhr = new XMLHttpRequest();
    xhr.responseType = "json";
    xhr.open(_, url);
    xhr.send(data);
    xhr.onreadystatechange = function() {
        this.response;
    };

    var xhr2 = new XMLHttpRequest();
    xhr2.open(_, url);
    xhr2.send(data);
    xhr2.addEventListener("readystatechange", function() {
        this.responseText;
        this.responseXML;
        this.statusText;
    });
})

(function() {
    request(url, function (error, response, body) {
        error;
        response.body;
        body;
    });

    request(url, {json: true}, function (error, response, body) {
        error;
        response.body;
        body;
    });

    requestPromise(url, {json: true});
});

(function() {
    axios.get(url).then(response => response.data);
    axios({ url: url, responseType: 'json'}).then(response => response.data);
    axios(unknown).then(response => response.data);
    axios({ responseType: unknown }).then(response => response.data);
})


(function() {
    fetch(url).then(r => r.json()).then(json => json);
})

(function() {
    got(url).then(response => response.body);
    got(url, { json: true }).then(response => response.body);
    got.stream(url).pipe(process.stdout);
})

(function() {
    superagent.get(url).end((err, res) => {
        err;
        res;
    });
});

(function() {
    let XhrIo = goog.require('goog.net.XhrIo');
    let xhr = new XhrIo();
    xhr.send(url);
    xhr.addEventListener('readystatechange', function() {
        xhr.getResponseJson();
        xhr.getResponseHeaders();
    });
})

(function() {
	let base = request;
	let variant1 = base.defaults({});
	let variant2 = variant1.defaults({});
	base(url);
	variant1(url);
	variant2(url);
});

(function() {
    $.get( "ajax/test.html", function( data ) {});
    
	$.getJSON( "ajax/test.json", "MyData", function( data ) {});
	
	$.getScript( "ajax/test.js", function( data, textStatus, jqxhr ) {});
	
	$.post( "ajax/test.html", "PostData", function( data ) { });
	
	$( "#result" ).load( "ajax/test.html", function(result) {});

	$.ajax({
		type: "POST",
		url: "http://example.org",
  		data: "AjaxData",
  		success: (ajaxData) => {},
  		dataType: "json"
	});
	
	$.get( "ajax/test.json", function( data ) {}, "json");
	
	$.ajax({url: "ajax/blob", dataType: "blob"})
      .done(function( data ) {});

	$.get("example.php").done(function(response) {})
	
    $.ajax({
    url: "example.php",
    type: 'POST',
    dataType: "json",
    error: function (err) {
        console.log(err.responseText)
    }});

	$.get("example.php").fail(function(xhr) {console.log(xhr.responseText)});
});

const net = require("net");
(function () {
    var data = {
        socket: new net.Socket()
    }

    data.socket.connect({host: "myHost"});

    data.socket.on("data", (data) => {});

    data.socket.write("foobar");
})();

const needle = require("needle");
(function () {
    const options = { headers: { 'X-Custom-Header': 'Bumbaway atuna' } };
    needle("POST", "http://example.org/foo/bar", "MyData", options).then(function(resp) { console.log(resp.body) });

    needle.get("http://example.org", (err, resp, body) => {

    });

    needle.post("http://example.org/post", "data", options, (err, resp, body) => {

    });
})();

var FormData = require('form-data');
var request = require('request');

var form = new FormData();

form.append('my_field', 'my value');
form.append('my_buffer', Buffer.from("foo"));
form.append('my_logo', request('http://example.org/images/logo.png'));

form.submit('http://example.org/', (err, res) => {
    res.resume();
});


var form = new FormData();
form.append('new_form', 'new_value');

form.submit({
    method: 'post',
    host: 'example.org',
    path: '/upload',
    headers: form.getHeaders()
});

var httpProxy = require('http-proxy');
var http = require("http");

httpProxy.createProxyServer({target:'http://localhost:9000'}).listen(8000); 

var proxy = httpProxy.createProxyServer(options);
http.createServer(function(req, res) {
  proxy.web(req, res, { target: 'http://mytarget.com:8080' });
});

httpProxy.createProxyServer({
    target: {
        protocol: 'https:',
        host: 'my-domain-name',
        port: 443,
        pfx: fs.readFileSync('path/to/certificate.p12'),
        passphrase: 'password',
    },
    changeOrigin: true
}).listen(8000);

function webSocket() {
    const socket = new WebSocket('ws://localhost:8080');
    socket.addEventListener('open', function (event) {
        socket.send('Hello Server!');
    });
    socket.addEventListener('message', function (event) {
        console.log("Data from server: " + event.data);
    });
}

function moreAxios() {
    axios({
        method: 'GET',
        url: "http://example.org/more-axios",
    }).then(
        x => res.send(x.data),
        (err) => {
            const status = err.response.status;
            const data = err.response.data;
            const agent = err.response.headers.useragent;
        }
    );
}

import { fetch as fetchPolyfill } from 'whatwg-fetch'

function usePolyfill() {
    return fetchPolyfill('/foo/bar')
        .then(function (response) {
            return response.text()
        })
}
