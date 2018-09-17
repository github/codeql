//BAD: `nodeIntegration` enabled by default
var win_1 = new BrowserWindow();
win_1.loadURL(remote_site);

//BAD: `nodeIntegration` enabled
var win_2 = new BrowserWindow({webPreferences: {nodeIntegration: true}});
win_2.loadURL(remote_site);

//GOOD: `nodeIntegration` disabled
let win_3 = new BrowserWindow({webPreferences: {nodeIntegration: false}});
win_3.loadURL(remote_site);

//BAD: `nodeIntegration` enabled  in the view
var win_4 = new BrowserWindow({webPreferences: {nodeIntegration: false}})
var view_4 = new BrowserView({
  webPreferences: {
    nodeIntegration: true
  }
});
win_4.setBrowserView(view_4);
view_4.webContents.loadURL(remote_site);
