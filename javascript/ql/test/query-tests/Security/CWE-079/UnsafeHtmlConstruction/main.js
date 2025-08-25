module.exports.xssThroughHTMLConstruction = function (s) { // $ Source
    const html = "<span>" + s + "</span>";// $ Alert
    document.querySelector("#html").innerHTML = html;
}
 
module.exports.xssThroughXMLParsing = function (s) { // $ Source
    const doc = new DOMParser().parseFromString(s, "text/xml"); // $ Alert
    document.querySelector("#xml").appendChild(doc.documentElement);
}

module.exports.xssThroughMoreComplexXMLParsing = function (s) { // $ Source
    const doc = new DOMParser().parseFromString(s, "text/xml"); // $ Alert
    const xml = doc.documentElement;
    
    const tmp = document.createElement('span');
    tmp.appendChild(xml.cloneNode()); 
    document.querySelector("#xml").appendChild(tmp);
}

const markdown = require('markdown-it')({html: true});
module.exports.xssThroughMarkdown = function (s) { // $ Source
    const html = markdown.render(s); // $ Alert
    document.querySelector("#markdown").innerHTML = html;
}

const striptags = require('striptags');
module.exports.sanitizedHTML = function (s) {
    const html = striptags("<span>" + s + "</span>");
    document.querySelector("#sanitized").innerHTML = html;
}

module.exports.ts = require("./typed");

module.exports.jquery = require("./jquery-plugin");

module.exports.plainDOMXMLParsing = function (s) {
    const doc = new DOMParser().parseFromString(s, "text/xml"); // OK - is never added to the DOM.
}

class Foo {
    constructor(s) {
        this.step = s;
    }

    doXss() {
        // not called here, but still bad.
        document.querySelector("#class").innerHTML = "<span>" + this.step + "</span>"; // $ MISSING: Alert - needs localFieldStep
    }

}

module.exports.createsClass = function (s) {
    return new Foo(s);
}

$.fn.xssPlugin = function (options) { // $ Source
    const defaults = {
        name: "name"
    };
    const settings = $.extend(defaults, options);
    return this.each(function () {
        $("<b>" + settings.name + "</b>").appendTo(this); // $ Alert
    });
}

module.exports.guards = function (attrVal) { // $ Source
    document.querySelector("#id").innerHTML = "<img alt=\"" + attrVal + "\"/>"; // $ Alert
    document.querySelector("#id").innerHTML = "<img alt=\"" + attrVal.replace(/"|'/g, "") + "\"/>";
    if (attrVal.indexOf("\"") === -1 && attrVal.indexOf("'") === -1) {
        document.querySelector("#id").innerHTML = "<img alt=\"" + attrVal + "\"/>";
    }
}

module.exports.intentionalTemplate = function (obj) {
    const html = "<span>" + obj.spanTemplate + "</span>";
    document.querySelector("#template").innerHTML = html;
}

module.exports.types = function (val) { // $ Source
    if (typeof val === "string") {
        $("#foo").html("<span>" + val + "</span>"); // $ Alert
    } else if (typeof val === "number") {
        $("#foo").html("<span>" + val + "</span>");
    } else if (typeof val === "boolean") {
        $("#foo").html("<span>" + val + "</span>");
    }
}

function createHTML(x) {
    return "<span>" + x + "</span>"; // $ Alert
}

module.exports.usesCreateHTML = function (x) { // $ Source
    $("#foo").html(createHTML(x));
}

const myMermaid = require('mermaid');
module.exports.usesCreateHTML = function (x) { // $ Source
    myMermaid.render("id", x, function (svg) { // $ Alert
        $("#foo").html(svg);
    });
    
    $("#foo").html(myMermaid.render("id", x)); // $ Alert

    mermaid.render("id", x, function (svg) {// $ Alert
        $("#foo").html(svg); 
    });

    $("#foo").html(mermaid.render("id", x)); // $ Alert

    mermaid.mermaidAPI.render("id", x, function (svg) {// $ Alert
        $("#foo").html(svg);
    });
}

module.exports.xssThroughMarkdown = function (s) { // $ Source
    const html = markdown.render(s); // $ Alert
    document.querySelector("#markdown").innerHTML = html;
}
