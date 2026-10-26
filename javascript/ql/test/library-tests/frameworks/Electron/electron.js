const { ipcMain, ipcRenderer, BrowserView, BrowserWindow, ClientRequest, net } = require('electron')

var bw = new BrowserWindow({webPreferences: {}})
var bv = new BrowserView({webPreferences: {}})

function makeClientRequests() {
    net.request('https://example.com').end();
    var post = new ClientRequest({url: 'https://example.com', method: 'POST'});
    
    post.on('response', (response) => {
      response.on('data', (chunk) => {
        chunk[0];
      });
    });
    
    post.on('redirect', (redirect) => {
      redirect.statusCode;
      post.followRedirect();
    });
    
    post.on('login', (authInfo, callback) => {
      authInfo.host;
      callback('username', 'password');
    });
    
    post.on('error', (error) => {
      error.something;
    });
    
    post.setHeader('referer', 'https://example.com');
    post.write('stuff');
    post.end('more stuff');
}

function foo(x) {
    return x;
}

foo(bw).webContents;
foo(bv).webContents;

ipcMain.on('async', (event, arg) => {
  event.sender.send('reply', 'pong');
  arg
});

ipcMain.on('sync', (event, arg) => {
  event.returnValue = 'pong';
  arg
});

ipcRenderer.on('reply', (event, arg) => {
  arg
});

ipcRenderer.send('async', 'ping');

ipcRenderer.sendSync('sync', 'ping');


(function () {
  let win = new BrowserWindow({ width: 800, height: 1500 })
  win.loadURL('http://github.com');

  let contents = win.webContents;

  contents.on("foo", (foo) => {}).on("bar", (bar) => {});
  contents.emit("foo", "foo");
  contents.emit("bar", "bar");
})();
