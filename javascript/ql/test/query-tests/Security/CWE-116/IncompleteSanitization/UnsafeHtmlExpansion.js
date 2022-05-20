(function(){
	let defaultPattern = /<(([\w:]+)[^>]*)\/>/gi;
	let expanded = "<$1></$2>";

	// lib1
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi,
		expanded
	); // NOT OK
	html.replace(/<(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi, expanded); // NOT OK

	// lib2
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
		expanded
	); // NOT OK
	html.replace(/<(([\w:]+)[^>]*)\/>/gi, expanded); // NOT OK

	// lib3
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:-]+)[^>]*)\/>/gi,
		expanded
	); // NOT OK
	html.replace(/<(([\w:-]+)[^>]*)\/>/gi, expanded); // NOT OK

	html.replace(defaultPattern, expanded); // NOT OK
	function getPattern() {
		return defaultPattern;
	}
	html.replace(getPattern(), expanded); // NOT OK

	function getExpanded() {
		return expanded;
	}
	html.replace(defaultPattern, getExpanded()); // NOT OK (but not tracking the expansion string)
	html.replace(defaultPattern, something); // OK (possibly)
	defaultPattern.match(something); // OK (possibly)
	getPattern().match(something); // OK (possibly)
});
