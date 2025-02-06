const http = require('http');
const url = require('url');

const check_username = (username) => {
    if (username != 'name') throw `${username} is not valid`;
}

const logger = {
    log: console.log
}

const another_logger = console.log

const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true);

    // OK - remove `\n` line from user controlled input before logging
    let username = q.query.username.replace(/\n|\r/g, "");

    console.info(`[INFO] User: ${username}`);
    console.info(`[INFO] User: %s`, username);
    logger.log('[INFO] User:', username);
    another_logger('[INFO] User:', username);
    try {
        check_username(username)
    } catch (error) {
        console.error(`[ERROR] Error: "${error}"`);
    }
});
