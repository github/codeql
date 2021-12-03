function postMessageHandler(event) {
    console.log(event.origin)
    // GOOD: the origin property is checked
    if (event.origin === 'www.example.com') {
        // do something
    }
}

window.addEventListener('message', postMessageHandler, false);