var escaped = raw.replace(/"/g, '\"');
(function() {
	var indirect = /"/g;
	raw.replace(indirect, '\"');
});
