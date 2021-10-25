const http = require('http');
let req = http.get(url, cb);
req.on('connect', (
    req, /* use (parameter 0 (parameter 1 (member on (return (member get (member exports (module http))))))) */
    clientSocket, head) => { /* ...  */ });
req.on('information', (
    info /* use (parameter 0 (parameter 1 (member on (return (member get (member exports (module http))))))) */
    ) => { /* ... */ });

req.on('connect', () => { }) /* def (parameter 0 (member on (return (member get (member exports (module http)))))) */
   .on('information', () => { }) /* def (parameter 0 (member on (return (member on (return (member get (member exports (module http)))))))) */;