(function(){
	let defaultPattern = /<(([\w:]+)[^>]*)\/>/gi;
	let expanded = "<$1></$2>";

	// lib1
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi,
		expanded
	); // $ Alert[js/unsafe-html-expansion]
	html.replace(/<(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi, expanded); // $ Alert[js/unsafe-html-expansion]

	// lib2
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
		expanded
	); // $ Alert[js/unsafe-html-expansion]
	html.replace(/<(([\w:]+)[^>]*)\/>/gi, expanded); // $ Alert[js/unsafe-html-expansion]

	// lib3
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:-]+)[^>]*)\/>/gi,
		expanded
	); // $ Alert[js/unsafe-html-expansion]
	html.replace(/<(([\w:-]+)[^>]*)\/>/gi, expanded); // $ Alert[js/unsafe-html-expansion]

	html.replace(defaultPattern, expanded); // $ Alert[js/unsafe-html-expansion]
	function getPattern() {
		return defaultPattern;
	}
	html.replace(getPattern(), expanded); // $ Alert[js/unsafe-html-expansion]

	function getExpanded() {
		return expanded;
	}
	html.replace(defaultPattern, getExpanded()); // $ MISSING: Alert - not tracking the expansion string
	html.replace(defaultPattern, something); // OK - possibly
	defaultPattern.match(something); // OK - possibly
	getPattern().match(something); // OK - possibly
});
