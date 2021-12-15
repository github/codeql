var liveServer = require("live-server");
 
const middleware = [function(req, res, next) {
    const tainted = req.url;    

    res.end(`<html><body>${tainted}</body></html>`); // NOT OK
}];

middleware.push(function(req, res, next) {
    const tainted = req.url;

    res.end(`<html><body>${tainted}</body></html>`); // NOT OK
});

var params = {
    middleware
};
liveServer.start(params);