const {BrowserWindow} = require('electron')

function test() {
    var unsafe_1 = { // NOT OK, both enabled
           webPreferences: {
            nodeIntegration: true,
			nodeIntegrationInWorker: true,
            plugins: true,
            webSecurity: true,
            sandbox: true
        }
    };
    
    var options_1 = { // NOT OK, `nodeIntegrationInWorker` enabled
	    webPreferences: {
            plugins: true,
			nodeIntegrationInWorker: false,
            webSecurity: true,
            sandbox: true     
        }
    };
    
    var pref = { // NOT OK, implicitly enabled
            plugins: true,
            webSecurity: true,
            sandbox: true     
        };
	
    var options_2 = {  // NOT OK, implicitly enabled
            webPreferences: pref,
            show: true,
            frame: true,
            minWidth: 300,
            minHeight: 300
    };

    var safe_used = { // NOT OK, explicitly disabled
        webPreferences: {
            nodeIntegration: false,			
            plugins: true,
            webSecurity: true,
            sandbox: true  
        }
    };
    
    var w1 = new BrowserWindow(unsafe_1);
    var w2 = new BrowserWindow(options_1);
    var w3 = new BrowserWindow(safe_used);
    var w4 = new BrowserWindow({width: 800, height: 600, webPreferences: {nodeIntegration: true}});	 // NOT OK, `nodeIntegration` enabled
    var w5 = new BrowserWindow(options_2);
    var w6 = new BrowserWindow(safe_used);
}
