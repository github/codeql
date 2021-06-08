// NOT OK
window.location = /.*redirect=([^&]*).*/.exec(document.location.href)[1];

(function(){
	var indirect = /.*redirect=([^&]*).*/;
	window.location = indirect.exec(document.location.href)[1];
});

// NOT OK
window.location = new RegExp('.*redirect=([^&]*).*').exec(document.location.href)[1];

(function(){
	var indirect = new RegExp('.*redirect=([^&]*).*')
	window.location = indirect.exec(document.location.href)[1];
});

// NOT OK
window.location = new RegExp(/.*redirect=([^&]*).*/).exec(document.location.href)[1];

(function(){
	var indirect = new RegExp(/.*redirect=([^&]*).*/)
	window.location = indirect.exec(document.location.href)[1];
});

function foo(win) {
	win.location.assign(new RegExp(/.*redirect=([^&]*).*/).exec(win.location.href)[1]); // NOT OK
}

foo(window);