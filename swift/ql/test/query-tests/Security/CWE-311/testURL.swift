
// --- stubs ---

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

// --- tests ---

func test1(passwd : String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
	let a = URL(string: "http://example.com/login?p=" + passwd); // BAD
	let b = URL(string: "http://example.com/login?p=" + encrypted_passwd); // GOOD (not sensitive)
	let c = URL(string: "http://example.com/login?ac=" + account_no); // BAD [NOT DETECTED]
	let d = URL(string: "http://example.com/login?cc=" + credit_card_no); // BAD

	let base = URL(string: "http://example.com/"); // GOOD (not sensitive)
	let e = URL(string: "abc", relativeTo: base); // GOOD (not sensitive)
	let f = URL(string: passwd, relativeTo: base); // BAD
	let g = URL(string: "abc", relativeTo: f); // BAD (reported on line above)
}
