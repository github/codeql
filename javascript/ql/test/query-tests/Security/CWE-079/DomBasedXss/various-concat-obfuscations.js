function test() {
	let tainted = document.location.search; // $ Source

	$("<div>" + tainted + "</div>"); // $ Alert
	$(`<div>${tainted}</div>`); // $ Alert
	$("<div>".concat(tainted).concat("</div>")); // $ Alert
	$(["<div>", tainted, "</div>"].join()); // $ Alert

	$("<div id=\"" + tainted + "\"/>"); // $ Alert
	$(`<div id="${tainted}"/>`); // $ Alert
	$("<div id=\"".concat(tainted).concat("/>")); // $ Alert
	$(["<div id=\"", tainted, "\"/>"].join()); // $ Alert

	function indirection1(attrs) {
		return '<div align="' + (attrs.defaultattr || 'left') + '">' + content + '</div>';
	}
	function indirection2(attrs) {
		return '<div align="'.concat(attrs.defaultattr || 'left').concat('">'.concat(content)).concat('</div>');
	}
	$(indirection1(document.location.search.attrs)); // $ Alert
	$(indirection2(document.location.search.attrs)); // $ Alert
};
