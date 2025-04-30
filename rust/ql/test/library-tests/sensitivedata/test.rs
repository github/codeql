
fn get_string() -> String { "string".to_string() }

fn sink<T>(_: T) { }

// --- tests ---

struct MyStruct {
	harmless: String,
	password: String,
	password_file_path: String,
	password_enabled: String,
}

impl MyStruct {
	fn get_certificate(&self) -> String { return get_string() }
	fn get_certificate_url(&self) -> String { return get_string() }
	fn get_certificate_file(&self) -> String { return get_string() }
}

fn get_password() -> String { get_string() }

fn test_passwords(
	password: &str, pass_word: &str, passwd: &str, my_password: &str, password_str: &str,
	pass_phrase: &str, passphrase: &str, passPhrase: &str,
	auth_key: &str, authkey: &str, authKey: &str, authentication_key: &str, authenticationkey: &str, authenticationKey: &str,
	harmless: &str, encrypted_password: &str, password_hash: &str,
	ms: &MyStruct
) {
	// passwords
	sink(password); // $ sensitive=password
	sink(pass_word); // $ MISSING: sensitive=password
	sink(passwd); // $ sensitive=password
	sink(my_password); // $ sensitive=password
	sink(password_str); // $ sensitive=password
	sink(pass_phrase); // $ sensitive=password
	sink(passphrase); // $ sensitive=password
	sink(passPhrase); // $ sensitive=password

	sink(auth_key); // $ sensitive=password
	sink(authkey); // $ sensitive=password
	sink(authKey); // $ sensitive=password
	sink(authentication_key); // $ sensitive=password
	sink(authenticationkey); // $ sensitive=password
	sink(authenticationKey); // $ sensitive=password

	sink(ms); // $ MISSING: sensitive=password
	sink(ms.password.as_str()); // $ MISSING: sensitive=password

	sink(get_password()); // $ sensitive=password
	let password2 = get_string();
	sink(password2); // $ sensitive=password

	// not passwords
	sink(harmless);
	sink(encrypted_password);
	sink(password_hash);

	sink(ms.harmless.as_str());
	sink(ms.password_file_path.as_str());
	sink(ms.password_enabled.as_str());

	sink(get_string());
	let harmless2 = get_string();
	sink(harmless2);
}

fn generate_secret_key() -> String { get_string() }
fn get_secure_key() -> String { get_string() }
fn get_private_key() -> String { get_string() }
fn get_public_key() -> String { get_string() }
fn get_secret_token() -> String { get_string() }
fn get_next_token() -> String { get_string() }

fn test_credentials(
	account_key: &str, accnt_key: &str, license_key: &str, secret_key: &str, is_secret: bool, num_accounts: i64,
	username: String, user_name: String, userid: i64, user_id: i64, my_user_id_64: i64, unique_id: i64, uid: i64,
	sessionkey: &[u64; 4], session_key: &[u64; 4], hashkey: &[u64; 4], hash_key: &[u64; 4],
	ms: &MyStruct
) {
	// credentials
	sink(account_key); // $ sensitive=id
	sink(accnt_key); // $ sensitive=id
	sink(license_key); // $ MISSING: sensitive=secret
	sink(secret_key); // $ sensitive=secret

	sink(username); // $ sensitive=id
	sink(user_name); // $ sensitive=id
	sink(userid); // $ sensitive=id
	sink(user_id); // $ sensitive=id
	sink(my_user_id_64); // $ sensitive=id

	sink(sessionkey); // $ sensitive=id
	sink(session_key); // $ sensitive=id

	sink(ms.get_certificate()); // $ sensitive=certificate

	sink(generate_secret_key()); // $ sensitive=secret
	sink(get_secure_key()); // $ MISSING: sensitive=secret
	sink(get_private_key()); // $ MISSING: sensitive=secret
	sink(get_secret_token()); // $ sensitive=secret

	// not (necessarily) credentials
	sink(is_secret);
	sink(num_accounts); // $ SPURIOUS: sensitive=id
	sink(unique_id);
	sink(uid); // $ SPURIOUS: sensitive=id
	sink(hashkey);
	sink(hash_key);

	sink(ms.get_certificate_url()); // $ SPURIOUS: sensitive=certificate
	sink(ms.get_certificate_file()); // $ SPURIOUS: sensitive=certificate

	sink(get_public_key());
	sink(get_next_token());
}

struct Financials {
	harmless: String,
	my_bank_account_number: String,
	credit_card_no: String,
	credit_rating: i32,
	user_ccn: String
}

struct MyPrivateInfo {
	mobile_phone_num: String,
	contact_email: String,
	contact_e_mail_2: String,
	my_ssn: String,
	birthday: String,
	emergency_contact: String,
	name_of_employer: String,

	medical_notes: Vec<String>,
	latitude: f64,
	longitude: Option<f64>,

	financials: Financials
}

fn test_private_info(
	info: &MyPrivateInfo
) {
	// private info
	sink(info.mobile_phone_num.as_str()); // $ MISSING: sensitive=private
	sink(info.mobile_phone_num.to_string()); // $ MISSING: sensitive=private
	sink(info.contact_email.as_str()); // $ MISSING: sensitive=private
	sink(info.contact_e_mail_2.as_str()); // $ MISSING: sensitive=private
	sink(info.my_ssn.as_str()); // $ MISSING: sensitive=private
	sink(info.birthday.as_str()); // $ MISSING: sensitive=private
	sink(info.emergency_contact.as_str()); // $ MISSING: sensitive=private
	sink(info.name_of_employer.as_str()); // $ MISSING: sensitive=private

	sink(&info.medical_notes); // $ MISSING: sensitive=private
	sink(info.medical_notes[0].as_str()); // $ MISSING: sensitive=private
	for n in info.medical_notes.iter() {
		sink(n.as_str()); // $ MISSING: sensitive=private
	}

	sink(info.latitude); // $ MISSING: sensitive=private
	let x = info.longitude.unwrap();
	sink(x); // $ MISSING: sensitive=private

	sink(info.financials.my_bank_account_number.as_str()); // $ MISSING: sensitive=private
	sink(info.financials.credit_card_no.as_str()); // $ MISSING: sensitive=private
	sink(info.financials.credit_rating); // $ MISSING: sensitive=private
	sink(info.financials.user_ccn.as_str()); // $ MISSING: sensitive=private

	// not private info
	sink(info.financials.harmless.as_str());
}
