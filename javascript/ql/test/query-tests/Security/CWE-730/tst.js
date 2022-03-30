window.addEventListener("message", function (e) {
    let data = e.data;
    new RegExp("^"+ data.name + "$", "i"); // NOT OK
});

const SOMEONE_I_TRUST = "myself";
window.addEventListener("message", function (e) {
    if (e.origin === SOMEONE_I_TRUST) {
        let data = e.data;
        new RegExp("^"+ data.name + "$", "i"); // OK
    }
});
