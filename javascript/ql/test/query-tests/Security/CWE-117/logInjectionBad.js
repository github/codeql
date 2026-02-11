const http = require('http');
const hostname = '127.0.0.1';
const port = 3000;
const url = require('url');


const check_username = (username) => {
    if (username != 'name') throw `${username} is not valid`;
    // do something
}

const my_logger = {
    log: console.log
}

const another_logger = console.log

const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true); // $ Source
    let username = q.query.username;

    console.info(`[INFO] User: ${username}`); // $ Alert
    console.info(`[INFO] User: %s`, username); // $ Alert
    my_logger.log('[INFO] User:', username); // $ Alert
    another_logger('[INFO] User:', username); // $ Alert

    try {
        check_username(username)
    } catch (error) {
        console.error(`[ERROR] Error: "${error}"`); // $ Alert
    }
});

const ansiColors = require('ansi-colors');
const colors = require('colors');
import wrapAnsi from 'wrap-ansi';
import { blue, bold, underline } from "colorette"
const highlight = require('cli-highlight').highlight;
var clc = require("cli-color");
import sliceAnsi from 'slice-ansi';
import kleur from 'kleur';
const chalk = require('chalk');
import stripAnsi from 'strip-ansi';

const server2 = http.createServer((req, res) => {
    let q = url.parse(req.url, true); // $ Source
    let username = q.query.username;

    console.info(ansiColors.yellow.underline(username)); // $ Alert
    console.info(colors.red.underline(username)); // $ Alert
    console.info(wrapAnsi(colors.red.underline(username), 20)); // $ Alert
    console.log(underline(bold(blue(username)))); // $ Alert
    console.log(highlight(username, {language: 'sql', ignoreIllegals: true})); // $ Alert
    console.log(clc.red.bgWhite.underline(username)); // $ Alert
    console.log(sliceAnsi(colors.red.underline(username), 20, 30)); // $ Alert
    console.log(kleur.blue().bold().underline(username)); // $ Alert
    console.log(chalk.underline.bgBlue(username)); // $ Alert
    console.log(stripAnsi(chalk.underline.bgBlue(username))); // $ Alert
});

var prettyjson = require('prettyjson');
const server3 = http.createServer((req, res) => {
    let q = url.parse(req.url, true); // $ Source
    let username = q.query.username;

    console.log(prettyjson.render(username)); // $ Alert

});

const pino = require('pino')()
const server4 = http.createServer((req, res) => {
    let q = url.parse(req.url, true); // $ Source
    let username = q.query.username;

    pino.info(username); // $ Alert

    function fastify() {
        const fastify = require('fastify')({
            logger: true
        });
        fastify.get('/', async (request, reply) => {
            request.log.info(username); // $ Alert
            return { hello: 'world' }
        });
    }

    function express() {
        const express = require('express');
        const app = express();
        app.get('/', (req, res) => {
            req.log.info(username); // $ Alert
            res.send({ hello: 'world' });
        });
    }

    function http() {
        const http = require('http');
        const server = http.createServer((req, res) => {
            req.log.info(username); // $ Alert
            res.end('Hello World\n');
        });
        server.listen(3000);
    }

    function hapi() {
        const Hapi = require('hapi');
        const server = new Hapi.Server();
        server.connection({ port: 3000 });
        server.route({
            method: 'GET',
            path: '/',
            handler: (request, reply) => {
                request.logger.info(username); // $ Alert
                reply({ hello: 'world' });
            }
        });
        server.start();
    }
});

const serverMatchAll = http.createServer((req, res) => {
    let username = url.parse(req.url, true).query.username; // $ Source
    let otherStr = username.matchAll(/.*/g)[0];
    console.log(otherStr); // $ Alert
});

const serverMatchAl2l = http.createServer((req, res) => {
    const result = url.parse(req.url, true).query.username.matchAll(/(\d+)/g); // $ Source
    console.log("First captured group:", RegExp.$1); // $ Alert
});
