
// --- stubs ---

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

// --- tests ---

var myString = ""
func setMyString(str: String) { myString = str }
func getMyString() -> String { return myString }

func test1(passwd : String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
	let a = URL(string: "http://example.com/login?p=" + passwd); // BAD
	let b = URL(string: "http://example.com/login?p=" + encrypted_passwd); // GOOD (not sensitive)
	let c = URL(string: "http://example.com/login?ac=" + account_no); // BAD
	let d = URL(string: "http://example.com/login?cc=" + credit_card_no); // BAD

	let base = URL(string: "http://example.com/"); // GOOD (not sensitive)
	let e = URL(string: "abc", relativeTo: base); // GOOD (not sensitive)
	let f = URL(string: passwd, relativeTo: base); // BAD
	let g = URL(string: "abc", relativeTo: f); // BAD (reported on line above)

	let e_mail = myString
	let h = URL(string: "http://example.com/login?em=" + e_mail); // BAD
	var a_homeaddr_z = getMyString()
	let i = URL(string: "http://example.com/login?home=" + a_homeaddr_z); // BAD
	var resident_ID = getMyString()
	let j = URL(string: "http://example.com/login?id=" + resident_ID); // BAD
}
