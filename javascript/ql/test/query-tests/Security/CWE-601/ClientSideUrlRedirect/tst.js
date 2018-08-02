// NOT OK
window.location = /.*redirect=([^&]*).*/.exec(document.location.href)[1];
