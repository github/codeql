jQuery.fn.copyText = function(options) {
	// GOOD may not evaluate `options.sourceSelector` as HTML
	var source = jQuery.find(options.sourceSelector),
	    text = source.text();
	jQuery(this).text(text);
}
