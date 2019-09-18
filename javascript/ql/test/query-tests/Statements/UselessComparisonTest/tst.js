(function(p = 1) {
	if (p > 0) {
	} else {
	}
});

(function(){
	(function (i) { if (i == 100000) return; })(1);
	(function f(i) { if (i == 100000) return; f(i+1); })(1);
});
