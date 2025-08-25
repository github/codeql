const nugget = require('nugget');

function foo() {
    function downloadTools(installer) {
        nugget(installer.url, {}, () => { }) // NOT OK [INCONSISTENCY] - access path too deep
    }
    var constants = {
        buildTools: {
            installerUrl: 'http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe'
        }
    }
    function getBuildToolsInstallerPath() {
        const buildTools = constants.buildTools
        return {
            url: buildTools.installerUrl
        }
    }

    downloadTools(getBuildToolsInstallerPath())
}


const request = require('request');

function bar() {
    request('http://www.google.com', function () { });

    nugget("https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe")

    nugget("http://example.org/unsafe.APK") // $ Alert
}

var cp = require("child_process")

function baz() {
    var url = "http://example.org/unsafe.APK"; // $ Source
    cp.exec("curl " + url, function () {}); // $ Alert

    cp.execFile("curl", [url], function () {}); // $ Alert

    nugget("ftp://example.org/unsafe.APK") // $ Alert
}

const fs = require("fs");
var writeFileAtomic = require("write-file-atomic");

function test() {
    nugget("http://example.org/unsafe", {target: "foo.exe"}, () => { }) // $ Alert

    nugget("http://example.org/unsafe", {target: "foo.safe"}, () => { })

    $.get("http://example.org/unsafe.unknown", function( data ) { // $ Alert
        writeFileAtomic('unsafe.exe', data, {}, function (err) {});
    });

    $.get("http://example.org/unsafe.unknown", function( data ) {
        writeFileAtomic('foo.safe', data, {}, function (err) {});
    });
}
