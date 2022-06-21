(function (factory) {
	if (typeof define === 'function' && define.amd) {
		define(['jquery', 'jquery-ui'], factory);
	} else {
		factory(jQuery);
	}
}(function ($) {
    $("<span>" + $.trim("foo") + "</span>"); // OK
}));

$.fn.myPlugin = function (stuff, options) {
    $("#foo").html("<span>" + options.foo + "</span>"); // NOT OK

    $("#foo").html("<span>" + stuff + "</span>"); // NOT OK
}
