let https = require("https"),
  tls = require("tls");

new https.Agent(); // OK

new https.Agent({
  rejectUnauthorized: true // OK
});

unknownCall({
  rejectUnauthorized: false // OK (but probably unsafe after all)
});

new https.Agent({
  rejectUnauthorized: false // NOT OK
});

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"; // NOT OK

https.get({
  rejectUnauthorized: false // NOT OK
});

new tls.TLSSocket(socket, {
  rejectUnauthorized: false // NOT OK
});

tls.connect({
  rejectUnauthorized: false // NOT OK
});

let socket = new tls.TLSSocket();
socket.renegotiate({
  rejectUnauthorized: false // NOT OK
});

let indirect = false;
new https.Agent({
	rejectUnauthorized: indirect // NOT OK
});
new https.Agent({
	rejectUnauthorized: !false // OK
});
new https.Agent({
	rejectUnauthorized: !!false // NOT OK
});
new https.Agent({
	rejectUnauthorized: !true // NOT OK
});
new https.Agent({
	rejectUnauthorized: !!true // OK
});
new https.Agent({
	rejectUnauthorized: unknown() // OK
});
new https.Agent({
	rejectUnauthorized: !getOptions().selfSignedSSL // OK
});
new https.Agent({
	rejectUnauthorized: getOptions().rejectUnauthorized // OK
});
new https.Agent({
	rejectUnauthorized: !!getOptions().rejectUnauthorized // OK
});
new https.Agent({
	rejectUnauthorized: getOptions() == null ? true : getOptions().verifySsl // OK
});
new https.Agent({
	rejectUnauthorized: typeof getOptions().rejectUnauthorized === 'boolean' ? getOptions().rejectUnauthorized : undefined // OK
});

function getSomeunsafeOptions() {
    return {
        rejectUnauthorized: false // NOT OK
    }
}
new https.Agent(getSomeunsafeOptions());

https.createServer({
    rejectUnauthorized: false // NOT OK
});