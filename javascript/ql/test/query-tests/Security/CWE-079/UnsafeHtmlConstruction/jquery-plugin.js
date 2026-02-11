(function (factory) {
	if (typeof define === 'function' && define.amd) {
		define(['jquery', 'jquery-ui'], factory);
	} else {
		factory(jQuery);
	}
}(function ($) {
    $("<span>" + $.trim("foo") + "</span>");
}));

$.fn.myPlugin = function (stuff, options) { // $ Source
    $("#foo").html("<span>" + options.foo + "</span>"); // $ Alert

    $("#foo").html("<span>" + stuff + "</span>"); // $ Alert
}
