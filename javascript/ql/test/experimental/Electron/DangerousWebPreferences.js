const {BrowserWindow} = require('electron')

function test() {
    var unsafe_used = {
        webPreferences: {
            sandbox: false,
            contextIsolation: false
        }
    };

    var unsafe_unused = {
        webPreferences: {
            sandbox: false,
            contextIsolation: false
        }
    };

    var safe_used = {
        webPreferences: {
            sandbox: true,
            contextIsolation: true
        }
    };

    new BrowserWindow(unsafe_used);
    new BrowserWindow(safe_used);
}