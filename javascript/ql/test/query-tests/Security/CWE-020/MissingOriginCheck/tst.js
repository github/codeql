window.onmessage = event => { // OK - good origin check
    let origin = event.origin.toLowerCase();

    if (origin !== window.location.origin) {
        return;
    }
  
    eval(event.data);
}

window.onmessage = event => { // $ Alert - no origin check
    let origin = event.origin.toLowerCase();

    console.log(origin);
    eval(event.data);
}

window.onmessage = event => { // OK - there is an origin check
    if (event.origin === "https://www.example.com") {
      // do something
    }
}

self.onmessage = function(e) { // $ Alert
    Commands[e.data.cmd].apply(null, e.data.args);
};

window.onmessage = event => { // OK - there is an origin check
    if (mySet.includes(event.origin)) {
        // do something
    }
}

window.onmessage = event => { // OK - there is an origin check
    if (mySet.includes(event.source)) {
        // do something
    }
}

self.onmessage = function(e) { // $ Alert
    Commands[e.data.cmd].apply(null, e.data.args);
};

window.addEventListener('message', function(e) { // OK - has a good origin check
    if (is_sysend_post_message(e) && is_valid_origin(e.origin)) {
        var payload = JSON.parse(e.data);
        if (payload && payload.name === uniq_prefix) {
            var data = unserialize(payload.data);
            sysend.broadcast(payload.key, data);
        }
    }
});

function is_valid_origin(origin) {
    if (!domains) {
        warn("no domains configured");
        return true;
    }
    var valid = domains.includes(origin);
    if (!valid) {
        warn("invalid origin: " + origin);
    }
    return valid;
}

window.onmessage = event => { // OK - the check is OK
    if ("https://www.example.com".startsWith(event.origin)) {
      // do something
    }
}
