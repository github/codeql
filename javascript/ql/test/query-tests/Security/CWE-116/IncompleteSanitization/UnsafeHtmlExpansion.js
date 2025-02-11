(function(){
	let defaultPattern = /<(([\w:]+)[^>]*)\/>/gi;
	let expanded = "<$1></$2>";

	// lib1
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi,
		expanded
	); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]
	html.replace(/<(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi, expanded); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]

	// lib2
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
		expanded
	); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]
	html.replace(/<(([\w:]+)[^>]*)\/>/gi, expanded); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]

	// lib3
	html.replace(
		/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:-]+)[^>]*)\/>/gi,
		expanded
	); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]
	html.replace(/<(([\w:-]+)[^>]*)\/>/gi, expanded); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]

	html.replace(defaultPattern, expanded); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]
	function getPattern() {
		return defaultPattern;
	}
	html.replace(getPattern(), expanded); // $ Alert TODO-MISSING: Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]

	function getExpanded() {
		return expanded;
	}
	html.replace(defaultPattern, getExpanded()); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization] - but not tracking the expansion string
	html.replace(defaultPattern, something); // OK - possibly
	defaultPattern.match(something); // OK - possibly
	getPattern().match(something); // OK - possibly
});
