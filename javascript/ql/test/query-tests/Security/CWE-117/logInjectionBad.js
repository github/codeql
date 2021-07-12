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
    let q = url.parse(req.url, true);
    let username = q.query.username;

    console.info(`[INFO] User: ${username}`); // NOT OK
    console.info(`[INFO] User: %s`, username); // NOT OK
    my_logger.log('[INFO] User:', username); // NOT OK
    another_logger('[INFO] User:', username); // NOT OK

    try {
        check_username(username)
    } catch (error) {
        console.error(`[ERROR] Error: "${error}"`); // NOT OK
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
    let q = url.parse(req.url, true);
    let username = q.query.username;

    console.info(ansiColors.yellow.underline(username)); // NOT OK
    console.info(colors.red.underline(username)); // NOT OK
    console.info(wrapAnsi(colors.red.underline(username), 20)); // NOT OK
    console.log(underline(bold(blue(username)))); // NOT OK
    console.log(highlight(username, {language: 'sql', ignoreIllegals: true})); // NOT OK
    console.log(clc.red.bgWhite.underline(username)); // NOT OK
    console.log(sliceAnsi(colors.red.underline(username), 20, 30)); // NOT OK
    console.log(kleur.blue().bold().underline(username)); // NOT OK
    console.log(chalk.underline.bgBlue(username)); // NOT OK
    console.log(stripAnsi(chalk.underline.bgBlue(username))); // NOT OK
});

const pino = require('pino')()

const server3 = http.createServer((req, res) => {
    let q = url.parse(req.url, true);
    let username = q.query.username;

    pino.info(username); // NOT OK
});