window.addEventListener("message", (ev) => {
    let message = JSON.parse(ev.data);
    window[message.name](message.payload);
});
