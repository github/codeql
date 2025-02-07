var escaped = raw.replace(/"/g, '\"'); // $ TODO-SPURIOUS: Alert
(function() {
	var indirect = /"/g;
	raw.replace(indirect, '\"'); // $ TODO-SPURIOUS: Alert
});
