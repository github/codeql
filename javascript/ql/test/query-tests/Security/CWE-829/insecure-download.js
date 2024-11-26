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
    request('http://www.google.com', function () { }); // OK

    nugget("https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe") // OK

    nugget("http://example.org/unsafe.APK") // NOT OK
}

var cp = require("child_process")

function baz() {
    var url = "http://example.org/unsafe.APK";
    cp.exec("curl " + url, function () {}); // NOT OK

    cp.execFile("curl", [url], function () {}); // NOT OK

    nugget("ftp://example.org/unsafe.APK") // NOT OK
}

const fs = require("fs");
var writeFileAtomic = require("write-file-atomic");

function test() {
    nugget("http://example.org/unsafe", {target: "foo.exe"}, () => { }) // NOT OK

    nugget("http://example.org/unsafe", {target: "foo.safe"}, () => { }) // OK

    $.get("http://example.org/unsafe.unknown", function( data ) {
        writeFileAtomic('unsafe.exe', data, {}, function (err) {}); // NOT OK
    });

    $.get("http://example.org/unsafe.unknown", function( data ) {
        writeFileAtomic('foo.safe', data, {}, function (err) {}); // OK
    });
}
