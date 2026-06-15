var escaped = raw.replace(/"/g, '\"'); // $ Alert
(function() {
	var indirect = /"/g;
	raw.replace(indirect, '\"'); // $ Alert
});
