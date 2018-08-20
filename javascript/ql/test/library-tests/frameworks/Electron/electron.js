const {BrowserView, BrowserWindow, ClientRequest, net} = require('electron')

new BrowserWindow({webPreferences: {}})
new BrowserView({webPreferences: {}})

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
