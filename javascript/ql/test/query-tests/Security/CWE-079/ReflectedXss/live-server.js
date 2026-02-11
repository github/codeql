var liveServer = require("live-server");
 
const middleware = [function(req, res, next) {
    const tainted = req.url;     // $ Source

    res.end(`<html><body>${tainted}</body></html>`); // $ Alert
}];

middleware.push(function(req, res, next) {
    const tainted = req.url; // $ Source

    res.end(`<html><body>${tainted}</body></html>`); // $ Alert
});

var params = {
    middleware
};
liveServer.start(params);