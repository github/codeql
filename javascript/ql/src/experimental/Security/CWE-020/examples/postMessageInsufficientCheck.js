function postMessageHandler(event) {
    let origin = event.origin.toLowerCase();

    let host = window.location.host;

    // BAD
    if (origin.indexOf(host) === -1)
        return;


    eval(event.data);
}

window.addEventListener('message', postMessageHandler, false);