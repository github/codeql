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

    $.getJSON(url, {data: data});
    $.getJSON({url: url, tdata: data});

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
