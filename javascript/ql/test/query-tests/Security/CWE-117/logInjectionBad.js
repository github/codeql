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