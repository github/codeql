(function coreRegExp() {
	/^a|/;
	/^a|b/; // NOT OK
	/a|^b/;
	/^a|^b/;
	/^a|b|c/; // NOT OK
	/a|^b|c/;
	/a|b|^c/;
	/^a|^b|c/;

	/(^a)|b/;
	/^a|(b)/; // NOT OK
	/^a|(^b)/;
	/^(a)|(b)/; // NOT OK


	/a|b$/; // NOT OK
	/a$|b/;
	/a$|b$/;
	/a|b|c$/; // NOT OK
	/a|b$|c/;
	/a$|b|c/;
	/a|b$|c$/;

	/a|(b$)/;
	/(a)|b$/; // NOT OK
	/(a$)|b$/;
	/(a)|(b)$/; // NOT OK

	/^good.com|better.com/; // NOT OK
	/^good\.com|better\.com/; // NOT OK
	/^good\\.com|better\\.com/; // NOT OK
	/^good\\\.com|better\\\.com/; // NOT OK
	/^good\\\\.com|better\\\\.com/; // NOT OK

	/^foo|bar|baz$/; // NOT OK
	/^foo|%/; // OK
});

(function coreString() {
	new RegExp("^a|");
	new RegExp("^a|b"); // NOT OK
	new RegExp("a|^b");
	new RegExp("^a|^b");
	new RegExp("^a|b|c"); // NOT OK
	new RegExp("a|^b|c");
	new RegExp("a|b|^c");
	new RegExp("^a|^b|c");

	new RegExp("(^a)|b");
	new RegExp("^a|(b)"); // NOT OK
	new RegExp("^a|(^b)");
	new RegExp("^(a)|(b)"); // NOT OK


	new RegExp("a|b$"); // NOT OK
	new RegExp("a$|b");
	new RegExp("a$|b$");
	new RegExp("a|b|c$"); // NOT OK
	new RegExp("a|b$|c");
	new RegExp("a$|b|c");
	new RegExp("a|b$|c$");

	new RegExp("a|(b$)");
	new RegExp("(a)|b$"); // NOT OK
	new RegExp("(a$)|b$");
	new RegExp("(a)|(b)$"); // NOT OK

	new RegExp('^good.com|better.com'); // NOT OK
	new RegExp('^good\.com|better\.com'); // NOT OK
	new RegExp('^good\\.com|better\\.com'); // NOT OK
	new RegExp('^good\\\.com|better\\\.com'); // NOT OK
	new RegExp('^good\\\\.com|better\\\\.com'); // NOT OK
});

(function realWorld() {
	// real-world examples that have been anonymized a bit

	/*
	 * NOT OK: flagged
	 */
	/(\.xxx)|(\.yyy)|(\.zzz)$/;
	/(^left|right|center)\sbottom$/; // not flagged at the moment due to interior anchors
	/\.xxx|\.yyy|\.zzz$/ig;
	/\.xxx|\.yyy|zzz$/;
	/^([A-Z]|xxx[XY]$)/; // not flagged at the moment due to interior anchors
	/^(xxx yyy zzz)|(xxx yyy)/i;
	/^(xxx yyy zzz)|(xxx yyy)|(1st( xxx)? yyy)|xxx|1st/i;
	/^(xxx:)|(yyy:)|(zzz:)/;
	/^(xxx?:)|(yyy:zzz\/)/;
	/^@media|@page/;
	/^\s*(xxx?|yyy|zzz):|xxx:yyy\//;
	/^click|mouse|touch/;
	/^http:\/\/good\.com|http:\/\/better\.com/;
	/^https?:\/\/good\.com|https?:\/\/better\.com/;
	/^mouse|touch|click|contextmenu|drop|dragover|dragend/;
	/^xxx:|yyy:/i;
	/_xxx|_yyy|_zzz$/;
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
