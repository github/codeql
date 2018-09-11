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
