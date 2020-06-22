function postMessageHandler(event) {
    let origin = event.origin.toLowerCase();

    console.log(origin)
    // BAD: the origin property is not checked
    eval(event.data);
}

window.addEventListener('message', postMessageHandler, false);
