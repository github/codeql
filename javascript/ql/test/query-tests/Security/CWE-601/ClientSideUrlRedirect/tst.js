// NOT OK
window.location = /.*redirect=([^&]*).*/.exec(document.location.href)[1];

(function(){
	var indirect = /.*redirect=([^&]*).*/;
	window.location = indirect.exec(document.location.href)[1];
});
