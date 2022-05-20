const http = require('http');
let req = http.get(url, cb);
req.on('connect', (
    req, /* use=moduleImport("http").getMember("exports").getMember("get").getReturn().getMember("on").getParameter(1).getParameter(0) */
    clientSocket, head) => { /* ...  */ });
req.on('information', (
    info /* use=moduleImport("http").getMember("exports").getMember("get").getReturn().getMember("on").getParameter(1).getParameter(0) */
    ) => { /* ... */ });

req.on('connect', () => { }) /* def=moduleImport("http").getMember("exports").getMember("get").getReturn().getMember("on").getParameter(0) */
   .on('information', () => { }) /* def=moduleImport("http").getMember("exports").getMember("get").getReturn().getMember("on").getReturn().getMember("on").getParameter(0) */;