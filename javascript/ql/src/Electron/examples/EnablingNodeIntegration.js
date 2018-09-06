//BAD
win_1 = new BrowserWindow({width: 800, height: 600, webPreferences: {nodeIntegration: true}});
win_1.loadURL("https://untrusted-site.com");

//GOOD
win_2 = new BrowserWindow({width: 800, height: 600, webPreferences: {nodeIntegration: false}});
win_2.loadURL("https://untrusted-site.com");

//BAD
win_3 = new BrowserWindow({
    webPreferences: {
      nodeIntegrationInWorker: true
    }
});

//BAD BrowserView
win_4 = new BrowserWindow({width: 800, height: 600, webPreferences: {nodeIntegration: false}})
view = new BrowserView({
  webPreferences: {
    nodeIntegration: true
  }
});
win.setBrowserView(view);
view.setBounds({ x: 0, y: 0, width: 300, height: 300 });
view.webContents.loadURL('https://untrusted-site.com');

