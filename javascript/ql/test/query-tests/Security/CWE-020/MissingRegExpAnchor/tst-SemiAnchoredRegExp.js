(function coreRegExp() {
	/^a|/;
	/^a|b/; // $ Alert
	/a|^b/;
	/^a|^b/;
	/^a|b|c/; // $ Alert
	/a|^b|c/;
	/a|b|^c/;
	/^a|^b|c/;

	/(^a)|b/;
	/^a|(b)/; // $ Alert
	/^a|(^b)/;
	/^(a)|(b)/; // $ Alert


	/a|b$/; // $ Alert
	/a$|b/;
	/a$|b$/;
	/a|b|c$/; // $ Alert
	/a|b$|c/;
	/a$|b|c/;
	/a|b$|c$/;

	/a|(b$)/;
	/(a)|b$/; // $ Alert
	/(a$)|b$/;
	/(a)|(b)$/; // $ Alert

	/^good.com|better.com/; // $ Alert
	/^good\.com|better\.com/; // $ Alert
	/^good\\.com|better\\.com/; // $ Alert
	/^good\\\.com|better\\\.com/; // $ Alert
	/^good\\\\.com|better\\\\.com/; // $ Alert

	/^foo|bar|baz$/; // $ Alert
	/^foo|%/;
});

(function coreString() {
	new RegExp("^a|");
	new RegExp("^a|b"); // $ Alert
	new RegExp("a|^b");
	new RegExp("^a|^b");
	new RegExp("^a|b|c"); // $ Alert
	new RegExp("a|^b|c");
	new RegExp("a|b|^c");
	new RegExp("^a|^b|c");

	new RegExp("(^a)|b");
	new RegExp("^a|(b)"); // $ Alert
	new RegExp("^a|(^b)");
	new RegExp("^(a)|(b)"); // $ Alert


	new RegExp("a|b$"); // $ Alert
	new RegExp("a$|b");
	new RegExp("a$|b$");
	new RegExp("a|b|c$"); // $ Alert
	new RegExp("a|b$|c");
	new RegExp("a$|b|c");
	new RegExp("a|b$|c$");

	new RegExp("a|(b$)");
	new RegExp("(a)|b$"); // $ Alert
	new RegExp("(a$)|b$");
	new RegExp("(a)|(b)$"); // $ Alert

	new RegExp('^good.com|better.com'); // $ Alert
	new RegExp('^good\.com|better\.com'); // $ Alert
	new RegExp('^good\\.com|better\\.com'); // $ Alert
	new RegExp('^good\\\.com|better\\\.com'); // $ Alert
	new RegExp('^good\\\\.com|better\\\\.com'); // $ Alert
});

(function realWorld() {
	// real-world examples that have been anonymized a bit

	/*
	 * NOT OK: flagged
	 */
	/(\.xxx)|(\.yyy)|(\.zzz)$/; // $ Alert
	/(^left|right|center)\sbottom$/; // not flagged at the moment due to interior anchors
	/\.xxx|\.yyy|\.zzz$/ig; // $ Alert
	/\.xxx|\.yyy|zzz$/; // $ Alert
	/^([A-Z]|xxx[XY]$)/; // not flagged at the moment due to interior anchors
	/^(xxx yyy zzz)|(xxx yyy)/i; // $ Alert
	/^(xxx yyy zzz)|(xxx yyy)|(1st( xxx)? yyy)|xxx|1st/i; // $ Alert
	/^(xxx:)|(yyy:)|(zzz:)/; // $ Alert
	/^(xxx?:)|(yyy:zzz\/)/; // $ Alert
	/^@media|@page/; // $ Alert
	/^\s*(xxx?|yyy|zzz):|xxx:yyy\//; // $ Alert
	/^click|mouse|touch/; // $ Alert
	/^http:\/\/good\.com|http:\/\/better\.com/; // $ Alert
	/^https?:\/\/good\.com|https?:\/\/better\.com/; // $ Alert
	/^mouse|touch|click|contextmenu|drop|dragover|dragend/; // $ Alert
	/^xxx:|yyy:/i; // $ Alert
	/_xxx|_yyy|_zzz$/; // $ Alert
	/em|%$/; // not flagged at the moment due to the anchor not being for letters

	/*
	 * MAYBE OK due to apparent complexity: not flagged
	 */
	/(?:^[#?]?|&)([^=&]+)(?:=([^&]*))?/g;
	/(^\s*|;\s*)\*.*;/m;
	/(^\s*|\[)(?:xxx|yyy_(?:xxx|yyy)|xxx|yyy(?:xxx|yyy)?|xxx|yyy)\b/m;
	/\s\S| \t|\t |\s$/;
	/\{[^}{]*\{|\}[^}{]*\}|\{[^}]*$/g;
	/^((\+|\-)\s*\d\d\d\d)|((\+|\-)\d\d\:?\d\d)/;
	/^(\/\/)|([a-z]+:(\/\/)?)/;
	/^[=?!#%@$]|!(?=[:}])/;
	/^[\[\]!:]|[<>]/;
	/^for\b|\b(?:xxx|yyy)\b/i;
	/^if\b|\b(?:xxx|yyy|zzz)\b/i;

	/*
	 * OK: not flagged
	 */
	/$^|only-match/g;
	/(#.+)|#$/;
	/(NaN| {2}|^$)/;
	/[^\n]*(?:\n|[^\n]$)/g;
	/^$|\/(?:xxx|yyy)zzz/i;
	/^(\/|(xxx|yyy|zzz)$)/;
	/^9$|27/;
	/^\+|\s*/g;
	/xxx_yyy=\w+|^$/;
	/^(?:mouse|contextmenu)|click/;
});

function replaceTest(x) {
	return x.replace(/^a|b/, ''); // OK - possibly replacing too much, but not obviously a problem
}
