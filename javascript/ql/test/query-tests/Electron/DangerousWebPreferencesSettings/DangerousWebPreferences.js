const {BrowserWindow} = require('electron')

function test() {
    var unsafe_used = {
        webPreferences: {
            webSecurity: false,
            allowRunningInsecureContent: true,
            experimentalFeatures: true,
            enableBlinkFeatures: ['ExecCommandInJavaScript'],
            blinkFeatures: 'CSSVariables'
        }
    };
    
    var unsafe_unused = {
        webPreferences: {
            webSecurity: false,
            allowRunningInsecureContent: true,
            experimentalFeatures: true,
            enableBlinkFeatures: ['ExecCommandInJavaScript'],
            blinkFeatures: 'CSSVariables'
        }
    };
    
    var safe_used = {
        webPreferences: {
            webSecurity: true,
            allowRunningInsecureContent: false,
            experimentalFeatures: false,
            enableBlinkFeatures: [],
            blinkFeatures: ''
        }
    };
    
    new BrowserWindow(unsafe_used);
    new BrowserWindow(safe_used);
}