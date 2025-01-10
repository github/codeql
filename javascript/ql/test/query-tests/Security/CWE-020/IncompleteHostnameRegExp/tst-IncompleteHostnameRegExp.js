(function() {
	/^http:\/\/example.com/;
	/^http:\/\/test.example.com/; // $ Alert
	/^http:\/\/test\.example.com/; // OK - escaped dot
	/^http:\/\/test\\.example.com/; // OK - contains actual backslash, so not really a hostname
	/^http:\/\/test.example.net/; // $ Alert
	/^http:\/\/test.(example-a|example-b).com/; // $ Alert
	/^http:\/\/(.+).example.com\//; // $ Alert
	/^http:\/\/(\.+)\.example.com/;
	/^http:\/\/(?:.+)\.test\.example.com\//; // $ Alert
	/^http:\/\/test.example.com\/(?:.*)/; // $ Alert
	new RegExp("^http://test.example.com"); // $ Alert
	if (s.match("^http://test.example.com")) {} // $ Alert

	function id(e) { return e; }
	new RegExp(id(id(id("^http://test.example.com")))); // $ Alert

	new RegExp(`test.example.com$`); // $ MISSING: Alert

	let hostname = '^test.example.com'; // $ Alert
	new RegExp(`${hostname}$`);

	let domain = { hostname: 'test.example.com$' }; // $ Alert
	new RegExp(domain.hostname);

	function convert1(domain) {
		return new RegExp(domain.hostname);
	}
	convert1({ hostname: 'test.example.com$' }); // $ Alert

	let domains = [ { hostname: 'test.example.com$' } ];  // $ Alert
	function convert2(domain) {
		return new RegExp(domain.hostname);
	}
	domains.map(d => convert2(d));

	/^(.+\.(?:example-a|example-b)\.com)\//; // $ MISSING: Alert
	/^(https?:)?\/\/((service|www).)?example.com(?=$|\/)/; // $ Alert
	/^(http|https):\/\/www.example.com\/p\/f\//; // $ Alert
	/^(http:\/\/sub.example.com\/)/g; // $ Alert
	/^https?:\/\/api.example.com/; // $ Alert
	new RegExp('^http://localhost:8000|' + '^https?://.+\\.example\\.com/'); // $ Alert
	new RegExp('^http[s]?:\/\/?sub1\\.sub2\\.example\\.com\/f\/(.+)');
	/^https:\/\/[a-z]*.example.com$/; // $ Alert
	RegExp('^protos?://(localhost|.+.example.net|.+.example-a.com|.+.example-b.com|.+.example.internal)'); // $ Alert

	/^(example.dev|example.com)/; // OK

	new RegExp('^http://localhost:8000|' + '^https?://.+.example\\.com/'); // $ Alert

	var primary = 'example.com$';
	new RegExp('test.' + primary); // $ MISSING: Alert

	new RegExp('test.' + 'example.com$'); // $ Alert

	new RegExp('^http://test\.example.com'); // $ Alert

	/^http:\/\/(..|...)\.example\.com\/index\.html/; // OK, wildcards are intentional
	/^http:\/\/.\.example\.com\/index\.html/; // OK, the wildcard is intentional
	/^(foo.example\.com|whatever)$/; // $ Alert (but kinda OK - one disjunction doesn't even look like a hostname)

	if (s.matchAll("^http://test.example.com")) {} // $ Alert
});
