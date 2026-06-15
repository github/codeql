function foo() {
    var payload = document.location.search.substr(1); // $ Source
    var el = document.createElement("a");
    el.href = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("button");
    el.formaction = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("embed");
    el.src = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("form");
    el.action = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("frame");
    el.src = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("iframe");
    el.src = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("input");
    el.formaction = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("isindex");
    el.action = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("isindex");
    el.formaction = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("object");
    el.data = payload; // $ Alert
    document.body.appendChild(el);

    var el = document.createElement("script");
    el.src = payload; // $ Alert
    document.body.appendChild(el);
}

(function () {
    self.onmessage = function (e) { // $ Source
        importScripts(e); // $ Alert
    }
    window.onmessage = function (e) { // $ Source
        self.importScripts(e); // $ Alert
    }
})();

function bar() {
    const history = require('history').createBrowserHistory();
    var payload = document.location.search.substr(1); // $ Source

    history.push(payload); // $ Alert
}
function baz() {
    const history = require('history').createBrowserHistory();
    var payload = history.location.hash.substr(1); // $ Source

    history.replace(payload); // $ Alert
}

function quz() {
    const history = HistoryLibrary.createBrowserHistory();
    var payload = history.location.hash.substr(1); // $ Source

    history.replace(payload); // $ Alert
}

function bar() {
    var url = document.location.search.substr(1); // $ Source

    $("<a>", {href: url}).appendTo("body"); // $ Alert
    $("#foo").attr("href", url); // $ Alert
    $("#foo").attr({href: url}); // $ Alert
    $("<img>", {src: url}).appendTo("body"); // $ Alert
}
