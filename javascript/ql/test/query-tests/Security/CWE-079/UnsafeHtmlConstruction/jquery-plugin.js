(function (factory) {
	if (typeof define === 'function' && define.amd) {
		define(['jquery', 'jquery-ui'], factory);
	} else {
		factory(jQuery);
	}
}(function ($) {
    $("<span>" + $.trim("foo") + "</span>"); // OK
}));
