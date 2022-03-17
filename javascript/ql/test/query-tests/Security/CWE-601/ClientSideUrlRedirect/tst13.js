function foo() {
    var payload = document.location.search.substr(1);
    var el = document.createElement("a");
    el.href = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("button");
    el.formaction = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("embed");
    el.src = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("form");
    el.action = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("frame");
    el.src = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("iframe");
    el.src = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("input");
    el.formaction = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("isindex");
    el.action = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("isindex");
    el.formaction = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("object");
    el.data = payload;
    document.body.appendChild(el); // NOT OK

    var el = document.createElement("script");
    el.src = payload;
    document.body.appendChild(el); // NOT OK
}

(function () {
    self.onmessage = function (e) {
        importScripts(e); // NOT OK
    }
    window.onmessage = function (e) {
        self.importScripts(e); // NOT OK
    }
})();

function bar() {
    const history = require('history').createBrowserHistory();
    var payload = document.location.search.substr(1);

    history.push(payload); // NOT OK
}
function baz() {
    const history = require('history').createBrowserHistory();
    var payload = history.location.hash.substr(1);

    history.replace(payload); // NOT OK
}

function quz() {
    const history = HistoryLibrary.createBrowserHistory();
    var payload = history.location.hash.substr(1);

    history.replace(payload); // NOT OK
}

function bar() {
    var url = document.location.search.substr(1);

    $("<a>", {href: url}).appendTo("body"); // NOT OK
    $("#foo").attr("href", url); // NOT OK
    $("#foo").attr({href: url}); // NOT OK
    $("<img>", {src: url}).appendTo("body"); // NOT OK
}
