win.postMessage(JSON.stringify({
 action: 'pause',
 auth: {
   key: window.state.authKey
 }
}), '*');
