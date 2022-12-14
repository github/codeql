window.addEventListener("message", function (event) {
    let data = event.data; // <-- add 'event.data' as a taint source
});

window.addEventListener("onclick", function (event) {
    let data = event.data; // <-- 'event.data' should not be a taint source
});
