(function(){
	$.fn.my_plugin = function my_plugin(options) {
		$(options); // NOT OK (or is it?)

		$(options.target); // NOT OK

		if (isElement(options.target)) {
			$(options.target); // OK
		}

		var target = options.target;

		if (isElement(target)) {
			$(target); // OK
		}

		if (typeof target != "string") {
			$(target); // OK
		}

		if (target.jquery === undefined) {
			$(target); // NOT OK
		} else {
			$(target); // OK
		}

		if (target.jquery !== undefined) {
			$(target); // OK
		} else {
			$(target); // NOT OK
		}

		if (typeof target.jquery !== "undefined") {
			$(target); // OK
		} else {
			$(target); // NOT OK
		}

		if (typeof target.jquery === "undefined") {
			$(target); // NOT OK
		} else {
			$(target); // OK
		}

		if (target.jquery) {
			$(target);  // OK
		} else {
			$(target); // NOT OK
		}

		if (!target.jquery) {
			$(target);  // NOT OK
		} else {
			$(target); // OK
		}

		if (!!target.jquery) {
			$(target);  // OK
		} else {
			$(target); // NOT OK
		}

	};

	$.fn.my_plugin = function my_plugin(element, options) {
		this.$element      = $(element);
		this.options       = $.extend({}, options);
		if (this.options.parent) this.$parent = $(this.options.parent) // NOT OK
	};

	$.fn.my_plugin = function my_plugin(options) {
		$(options.foo.bar.baz); // NOT OK
		$(options.html); // OK
	};

	$.fn.my_plugin = function my_plugin(options) {
		$(x).appendTo(options.foo.bar.baz); // NOT OK
	};

	$.fn.my_plugin = function my_plugin(options) {
		$("#" + options.target); // OK
	};

	$.fn.my_plugin = function my_plugin(options) {
		function f(o) {
			this.o = $.extend({}, o);
			var t = this.o.target;

			console.log(t);
			$(t); // NOT OK
		}
		f(options);
	};

	$.fn.my_plugin = function my_plugin(options) {
		var target = options.target;
		if (safe.has(target))
			$(target); // OK
	};

	$.fn.my_plugin = function my_plugin(options) {
		options = $.extend({
			menu: '<div></div>',
			target: '.my_plugin'
		}, options);
		$(options.menu); // OK
		$(options.target); // NOT OK
	};

	$.fn.my_plugin.defaults = {
		menu: '<div></div>',
		target: '.my_plugin'
	};
	$.fn.my_plugin = function my_plugin(options) {
		options = $.extend({}, $.fn.my_plugin.defaults, options);
		$(options.menu); // OK
		$(options.target); // NOT OK
	};

	var pluginName = "my_plugin";
	$.fn[pluginName] = function my_plugin(options) {
		$(options.target); // NOT OK
	};

	$.extend($.fn, {
		my_plugin: function my_plugin(options) {
			$(options.target); // NOT OK
		}
	});

	$.fn.affix = function my_plugin(options) {
		$(options.target); // NOT OK
	};

	$.fn.tooltip = function my_plugin(options) {
		$(options.viewport.selector); // NOT OK
	};

	$.fn.my_plugin = function my_plugin(options) {
		let intentional1 = options.target || `<div>hello</div>`;
		$(intentional1); // OK

		let intentional2 = `<div>${options.target}</div>`;
		$(intentional2); // OK

		let intentional3 = `<div>` + options.target `</div>`;
		$(intentional3); // OK

		let unintentional = `<div class="${options.target}"></div>`;
		$(unintentional); // OK - but should be flagged by another query
	}

	$.fn.my_plugin = function my_plugin(options) {
		let target = options.target;
		target === DEFAULTS.target? $(target): $(document).find(target); // OK
		options.target === DEFAULTS.target? $(options.target): $(document).find(options.target); // OK
		options.targets.a === DEFAULTS.target? $(options.target.a): $(document).find(options.target.a); // OK - should be sanitized by `MembershipTestSanitizer` - but still flagged because `AccessPath` can't handle these deeply nested properties [INCONSISTENCY]
	}

	$.fn.my_plugin = function my_plugin(options) {
		$(anyPrefix + options.target); // OK (unlikely to be a html/css prefix confusion)

		$(something.replace("%PLACEHOLDER%", options.target)); // OK (unlikely to be a html/css prefix confusion);

		let target = options.target;
		if (target.foo) {
			$(target); // OK (unlikely to be a string)
		}
		if (target.length) {
			$(target); // NOT OK (can still be a string)
		}

	}

	function setupPlugin(o) {
		$.fn.my_plugin = o.f
	}
	setupPlugin({f: function(options) {
		$(options.target); // NOT OK
	}});
	setupPlugin({f:function(options) {
		$(document).find(options.target); // OK
	}});

	$.fn.position = function( options ) {
		if ( !options || !options.of ) {
			return doSomethingElse( this, arguments );
		}
		// extending options
		options = $.extend( {}, options );
	
		var target = $( options.of ); // NOT OK
		console.log(target);
	};
});
