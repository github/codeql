const micro = require('micro')
const bluebird = require('bluebird');
const compress = require('micro-compress');
 
micro(async (req, res) => {
    req.headers['content-type'];
    micro.json(req);
    micro.sendError(req, res, "data");
    return "Hello";
})

function* wrappedHandler(req, res) {
    req.headers['content-type'];
    yield "Response";
}

let handler = bluebird.coroutine(wrappedHandler);

micro(compress(handler));
