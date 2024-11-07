
// --- stubs ---

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

class Data {
}

extension String {
	struct Encoding {
		static let utf8 = Encoding()
	}

	init?(data: Data, encoding: Encoding) { self.init() }
}

class SecKey {
}

class CFData {
}

class CFError {
}

func SecKeyCopyExternalRepresentation(_ key: SecKey, _ error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> CFData? { return nil }

// --- tests ---

var myString = ""
func setMyString(str: String) { myString = str }
func getMyString() -> String { return myString }

func test1(passwd : String, encrypted_passwd : String, account_no : String, credit_card_no : String) {
	_ = URL(string: "http://example.com/login?p=" + passwd); // BAD
	_ = URL(string: "http://example.com/login?p=" + encrypted_passwd); // GOOD (not sensitive)
	_ = URL(string: "http://example.com/login?ac=" + account_no); // BAD
	_ = URL(string: "http://example.com/login?cc=" + credit_card_no); // BAD

	let base = URL(string: "http://example.com/"); // GOOD (not sensitive)
	_ = URL(string: "abc", relativeTo: base); // GOOD (not sensitive)
	let f = URL(string: passwd, relativeTo: base); // BAD
	_ = URL(string: "abc", relativeTo: f); // BAD (reported on line above)

	let e_mail = myString
	_ = URL(string: "http://example.com/login?em=" + e_mail); // BAD
	let a_homeaddr_z = getMyString()
	_ = URL(string: "http://example.com/login?home=" + a_homeaddr_z); // BAD
	let resident_ID = getMyString()
	_ = URL(string: "http://example.com/login?id=" + resident_ID); // BAD
}

func get_private_key() -> String { return "" }
func get_aes_key() -> String { return "" }
func get_aws_key() -> String { return "" }
func get_access_key() -> String { return "" }
func get_secret_key() -> String { return "" }
func get_key_press() -> String { return "" }
func get_cert_string() -> String { return "" }
func get_certain() -> String { return "" }

func test2() {
	// more variants...

	_ = URL(string: "http://example.com/login?key=" + get_private_key()); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?key=" + get_aes_key()); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?key=" + get_aws_key()); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?key=" + get_access_key()); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?key=" + get_secret_key()); // BAD
	_ = URL(string: "http://example.com/login?key=" + get_key_press()); // GOOD (not sensitive)
	_ = URL(string: "http://example.com/login?cert=" + get_cert_string()); // BAD
	_ = URL(string: "http://example.com/login?certain=" + get_certain()); // GOOD (not sensitive)
}

func get_string() -> String { return "" }

func test3() {
	// more variants...

	let priv_key = get_string()
	let private_key = get_string()
	let pub_key = get_string()
	let certificate = get_string()
	let secure_token = get_string()
	let access_token = get_string()
	let auth_token = get_string()
	let next_token = get_string()

	_ = URL(string: "http://example.com/login?key=\(priv_key)"); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?key=\(private_key)"); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?key=\(pub_key)"); // GOOD (not sensitive)
	_ = URL(string: "http://example.com/login?cert=\(certificate)"); // BAD
	_ = URL(string: "http://example.com/login?tok=\(secure_token)"); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?tok=\(access_token)"); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?tok=\(auth_token)"); // BAD [NOT DETECTED]
	_ = URL(string: "http://example.com/login?tok=\(next_token)"); // GOOD (not sensitive)
}

func test4(key: SecKey) {
	if let data = SecKeyCopyExternalRepresentation(key, nil) as? Data {
		if let string = String(data: data, encoding: .utf8) {
			_ = URL(string: "http://example.com/login?tok=\(string)"); // BAD
		}
	}
}

func test5() {
	// variant URL types...
	let email = get_string()
	let secret_key = get_string()

	_ = URL(string: "http://example.com/login?email=\(email)"); // BAD
	_ = URL(string: "mailto:\(email)"); // GOOD (revealing your e-amil address in an e-mail is expected)
	_ = URL(string: "mailto:info@example.com?subject=\(secret_key)"); // BAD [NOT DETECTED]
	_ = URL(string: "mailto:info@example.com?subject=foo&cc=\(email)"); // GOOD

	let phone_number = get_string()

	_ = URL(string: "http://example.com/profile?tel=\(phone_number)"); // BAD
	_ = URL(string: "tel:\(phone_number)") // GOOD
	_ = URL(string: "telprompt:\(phone_number)") // GOOD
	_ = URL(string: "callto:\(phone_number)") // GOOD
	_ = URL(string: "sms:\(phone_number)") // GOOD

	let account_no = get_string()

	_ = URL(string: "file:///foo/bar/\(account_no).csv") // GOOD (local, so not transmitted)
	_ = URL(string: "ftp://example.com/\(account_no).csv") // BAD
}
