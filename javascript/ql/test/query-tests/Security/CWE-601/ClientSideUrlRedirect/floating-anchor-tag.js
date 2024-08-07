import 'dummy';

function normalize(url) {
    let a = document.createElement('a');
    a.href = url; // OK
    return a.href;
}

function test() {
    let url = window.location.href;

    window.location.href = url; // OK
    window.location.href = normalize(url); // OK

    let taint = url.substring(url.indexOf('#') + 1);
    window.location.href = taint; // NOT OK
    window.location.href = normalize(taint); // NOT OK
}
