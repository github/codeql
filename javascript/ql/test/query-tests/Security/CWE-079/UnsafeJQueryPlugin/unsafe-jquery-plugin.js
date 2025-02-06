(function(){
	$.fn.my_plugin = function my_plugin(options) {
		$(options); // $ Alert - or is it?

		$(options.target); // $ Alert

		if (isElement(options.target)) {
			$(options.target);
		}

		var target = options.target;

		if (isElement(target)) {
			$(target);
		}

		if (typeof target != "string") {
			$(target);
		}

		if (target.jquery === undefined) {
			$(target); // $ Alert
		} else {
			$(target);
		}

		if (target.jquery !== undefined) {
			$(target);
		} else {
			$(target); // $ Alert
		}

		if (typeof target.jquery !== "undefined") {
			$(target);
		} else {
			$(target); // $ Alert
		}

		if (typeof target.jquery === "undefined") {
			$(target); // $ Alert
		} else {
			$(target);
		}

		if (target.jquery) {
			$(target);
		} else {
			$(target); // $ Alert
		}

		if (!target.jquery) {
			$(target);  // $ Alert
		} else {
			$(target);
		}

		if (!!target.jquery) {
			$(target);
		} else {
			$(target); // $ Alert
		}

	};

	$.fn.my_plugin = function my_plugin(element, options) {
		this.$element      = $(element);
		this.options       = $.extend({}, options);
		if (this.options.parent) this.$parent = $(this.options.parent) // $ Alert
	};

	$.fn.my_plugin = function my_plugin(options) {
		$(options.foo.bar.baz); // $ Alert
		$(options.html);
	};

	$.fn.my_plugin = function my_plugin(options) {
		$(x).appendTo(options.foo.bar.baz); // $ Alert
	};

	$.fn.my_plugin = function my_plugin(options) {
		$("#" + options.target);
	};

	$.fn.my_plugin = function my_plugin(options) {
		function f(o) {
			this.o = $.extend({}, o);
			var t = this.o.target;

			console.log(t);
			$(t); // $ Alert
		}
		f(options);
	};

	$.fn.my_plugin = function my_plugin(options) {
		var target = options.target;
		if (safe.has(target))
			$(target);
	};

	$.fn.my_plugin = function my_plugin(options) {
		options = $.extend({
			menu: '<div></div>',
			target: '.my_plugin'
		}, options);
		$(options.menu);
		$(options.target); // $ Alert
	};

	$.fn.my_plugin.defaults = {
		menu: '<div></div>',
		target: '.my_plugin'
	};
	$.fn.my_plugin = function my_plugin(options) {
		options = $.extend({}, $.fn.my_plugin.defaults, options);
		$(options.menu);
		$(options.target); // $ Alert
	};

	var pluginName = "my_plugin";
	$.fn[pluginName] = function my_plugin(options) {
		$(options.target); // $ Alert
	};

	$.extend($.fn, {
		my_plugin: function my_plugin(options) {
			$(options.target); // $ Alert
		}
	});

	$.fn.affix = function my_plugin(options) {
		$(options.target); // $ Alert
	};

	$.fn.tooltip = function my_plugin(options) {
		$(options.viewport.selector); // $ Alert
	};

	$.fn.my_plugin = function my_plugin(options) {
		let intentional1 = options.target || `<div>hello</div>`;
		$(intentional1);

		let intentional2 = `<div>${options.target}</div>`;
		$(intentional2);

		let intentional3 = `<div>` + options.target `</div>`;
		$(intentional3);

		let unintentional = `<div class="${options.target}"></div>`;
		$(unintentional); // OK - but should be flagged by another query
	}

	$.fn.my_plugin = function my_plugin(options) {
		let target = options.target;
		target === DEFAULTS.target? $(target): $(document).find(target);
		options.target === DEFAULTS.target? $(options.target): $(document).find(options.target);
		options.targets.a === DEFAULTS.target? $(options.target.a): $(document).find(options.target.a); // $ SPURIOUS: Alert - should be sanitized by `MembershipTestSanitizer` - but still flagged because `AccessPath` can't handle these deeply nested properties
	}

	$.fn.my_plugin = function my_plugin(options) {
		$(anyPrefix + options.target); // OK - unlikely to be a html/css prefix confusion

		$(something.replace("%PLACEHOLDER%", options.target)); // OK - (unlikely to be a html/css prefix confusion);

		let target = options.target;
		if (target.foo) {
			$(target); // OK - unlikely to be a string
		}
		if (target.length) {
			$(target); // $ Alert - can still be a string
		}

	}

	function setupPlugin(o) {
		$.fn.my_plugin = o.f
	}
	setupPlugin({f: function(options) {
		$(options.target); // $ Alert
	}});
	setupPlugin({f:function(options) {
		$(document).find(options.target);
	}});

	$.fn.position = function( options ) {
		if ( !options || !options.of ) {
			return doSomethingElse( this, arguments );
		}
		// extending options
		options = $.extend( {}, options );

		var target = $( options.of ); // $ Alert
		console.log(target);
	};

	$.fn.blockReceiver = function( options ) {
		$.extend({
				foo() {
					$(this);
				}
			},
			options,
		);
	};
});
