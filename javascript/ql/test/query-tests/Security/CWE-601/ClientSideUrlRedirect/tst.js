window.location = /.*redirect=([^&]*).*/.exec(document.location.href)[1]; // $ Alert

(function(){
	var indirect = /.*redirect=([^&]*).*/;
	window.location = indirect.exec(document.location.href)[1]; // $ TODO-SPURIOUS: Alert
});

window.location = new RegExp('.*redirect=([^&]*).*').exec(document.location.href)[1]; // $ Alert

(function(){
	var indirect = new RegExp('.*redirect=([^&]*).*')
	window.location = indirect.exec(document.location.href)[1]; // $ TODO-SPURIOUS: Alert
});

window.location = new RegExp(/.*redirect=([^&]*).*/).exec(document.location.href)[1]; // $ Alert

(function(){
	var indirect = new RegExp(/.*redirect=([^&]*).*/)
	window.location = indirect.exec(document.location.href)[1]; // $ TODO-SPURIOUS: Alert
});

function foo(win) {
	win.location.assign(new RegExp(/.*redirect=([^&]*).*/).exec(win.location.href)[1]); // $ Alert
}

foo(window);
