function test() {
	let tainted = document.location.search;

	$("<div>" + tainted + "</div>"); // NOT OK
	$(`<div>${tainted}</div>`); // NOT OK
	$("<div>".concat(tainted).concat("</div>")); // NOT OK
	$(["<div>", tainted, "</div>"].join()); // NOT OK

	$("<div id=\"" + tainted + "\"/>"); // NOT OK
	$(`<div id="${tainted}"/>`); // NOT OK
	$("<div id=\"".concat(tainted).concat("/>")); // NOT OK
	$(["<div id=\"", tainted, "\"/>"].join()); // NOT OK

	function indirection1(attrs) {
		return '<div align="' + (attrs.defaultattr || 'left') + '">' + content + '</div>';
	}
	function indirection2(attrs) {
		return '<div align="'.concat(attrs.defaultattr || 'left').concat('">'.concat(content)).concat('</div>');
	}
	$(indirection1(document.location.search.attrs)); // NOT OK
	$(indirection2(document.location.search.attrs)); // NOT OK
};
