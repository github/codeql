let https = require("https"),
  tls = require("tls");

new https.Agent();

new https.Agent({
  rejectUnauthorized: true
});

unknownCall({
  rejectUnauthorized: false // OK - but probably unsafe after all
});

new https.Agent({
  rejectUnauthorized: false // $ Alert
});

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"; // $ Alert

https.get({
  rejectUnauthorized: false // $ Alert
});

new tls.TLSSocket(socket, {
  rejectUnauthorized: false // $ Alert
});

tls.connect({
  rejectUnauthorized: false // $ Alert
});

let socket = new tls.TLSSocket();
socket.renegotiate({
  rejectUnauthorized: false // $ Alert
});

let indirect = false;
new https.Agent({
	rejectUnauthorized: indirect // $ Alert
});
new https.Agent({
	rejectUnauthorized: !false
});
new https.Agent({
	rejectUnauthorized: !!false // $ Alert
});
new https.Agent({
	rejectUnauthorized: !true // $ Alert
});
new https.Agent({
	rejectUnauthorized: !!true
});
new https.Agent({
	rejectUnauthorized: unknown()
});
new https.Agent({
	rejectUnauthorized: !getOptions().selfSignedSSL
});
new https.Agent({
	rejectUnauthorized: getOptions().rejectUnauthorized
});
new https.Agent({
	rejectUnauthorized: !!getOptions().rejectUnauthorized
});
new https.Agent({
	rejectUnauthorized: getOptions() == null ? true : getOptions().verifySsl
});
new https.Agent({
	rejectUnauthorized: typeof getOptions().rejectUnauthorized === 'boolean' ? getOptions().rejectUnauthorized : undefined
});

function getSomeunsafeOptions() {
    return {
        rejectUnauthorized: false // $ Alert
    }
}
new https.Agent(getSomeunsafeOptions());

https.createServer({
    rejectUnauthorized: false // $ Alert
});