const {ipcMain, ipcRenderer, BrowserView, BrowserWindow} = require('electron')

new BrowserWindow({webPreferences: {}})
renderer = new BrowserView({webPreferences: {}})

ipcMain.on('async', (event, arg) => {
  event.sender.send('reply', 'pong');
  arg
})

ipcMain.on('sync', (event, arg) => {
  event.returnValue = 'pong';
  arg;
})

ipcRenderer.on('reply', (event, arg) => {
  arg
})

ipcRenderer.send('async', 'ping')

ipcRenderer.sendSync('sync', 'ping')