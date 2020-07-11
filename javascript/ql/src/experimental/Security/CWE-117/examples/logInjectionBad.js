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

// http://127.0.0.1:3000/data?username=Guest%0a[INFO]+User:+Admin%0a



const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true);

    let username = q.query.username;

    // BAD: User input logged as-is
    console.info(`[INFO] User: ${username}`);
    // [INFO] User: Guest
    // [INFO] User: Admin
    //

    // BAD: User input logged as-is
    console.info(`[INFO] User: %s`, username);
    // [INFO] User: Guest
    // [INFO] User: Admin
    //


    // BAD: User input logged as-is
    my_logger.log('[INFO] User:', username);
    // [INFO] User: Guest
    // [INFO] User: Admin
    //

    // BAD: User input logged as-is
    another_logger('[INFO] User:', username);
    // [INFO] User: Guest
    // [INFO] User: Admin
    //

    try {
        check_username(username)

    } catch (error) {
        // BAD: Error with user input logged as-is
        console.error(`[ERROR] Error: "${error}"`);
        // [ERROR] Error: "Guest
        // [INFO] User: Admin
        //  is not valid"

    }

})

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});
