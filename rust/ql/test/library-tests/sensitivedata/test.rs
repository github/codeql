
fn get_string() -> String { "string".to_string() }

fn sink<T>(_: T) { }

// --- tests ---

struct MyStruct {
	harmless: String,
	password: String,
	password_file_path: String,
	password_enabled: String,
	mfa: String,
	numfailed: String,
}

impl MyStruct {
	fn get_certificate(&self) -> String { return get_string() }
	fn get_certificate_url(&self) -> String { return get_string() }
	fn get_certificate_file(&self) -> String { return get_string() }
}

fn get_password() -> String { get_string() }

fn test_passwords(
	password: &str, pass_word: &str, passwd: &str, my_password: &str, password_str: &str,
	pass_phrase: &str, passphrase: &str, passPhrase: &str, backup_code: &str,
	auth_key: &str, authkey: &str, authKey: &str, authentication_key: &str, authenticationkey: &str, authenticationKey: &str, oauth: &str,
	one_time_code: &str,
	harmless: &str, encrypted_password: &str, password_hash: &str, passwordFile: &str,
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
	sink(backup_code); // $ MISSING: sensitive=password

	sink(auth_key); // $ sensitive=password
	sink(authkey); // $ sensitive=password
	sink(authKey); // $ sensitive=password
	sink(authentication_key); // $ sensitive=password
	sink(authenticationkey); // $ sensitive=password
	sink(authenticationKey); // $ sensitive=password
	sink(oauth); // $ MISSING: sensitive=password
	sink(one_time_code); // $ MISSING: sensitive=password

	sink(ms); // $ MISSING: sensitive=password
	sink(ms.password.as_str()); // $ sensitive=password
	sink(ms.mfa.as_str()); // $ MISSING: sensitive=password

	sink(get_password()); // $ sensitive=password
	let password2 = get_string();
	sink(password2); // $ sensitive=password

	let qry = "password=abc";
	sink(qry); // $ MISSING: sensitive=password

	// not passwords

	sink(harmless);
	sink(encrypted_password);
	sink(password_hash);
	sink(passwordFile); // $ SPURIOUS: sensitive=password

	sink(ms.harmless.as_str());
	sink(ms.password_file_path.as_str()); // $ SPURIOUS: sensitive=password
	sink(ms.password_enabled.as_str()); // $ SPURIOUS: sensitive=password
	sink(ms.numfailed.as_str());

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
	sessionkey: &[u64; 4], session_key: &[u64; 4], hashkey: &[u64; 4], hash_key: &[u64; 4], sessionkeypath: &[u64; 4], account_key_path: &[u64; 4],
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
	sink(sessionkeypath); // $ SPURIOUS: sensitive=id
	sink(account_key_path); // $ SPURIOUS: sensitive=id

	sink(ms.get_certificate_url()); // $ SPURIOUS: sensitive=certificate
	sink(ms.get_certificate_file()); // $ SPURIOUS: sensitive=certificate

	sink(get_public_key());
	sink(get_next_token());
}

struct MacAddr {
	values: [u8;12],
}

struct DeviceInfo {
	api_key: String,
	deviceApiToken: String,
	finger_print: String,
	ip_address: String,
	macaddr12: [u8;12],
	mac_addr: MacAddr,
	networkMacAddress: String,

	// not private device info
	macro_value: bool,
	mac_command: u32,
	skip_address: String,
}

impl DeviceInfo {
	fn test_device_info(&self, other: &DeviceInfo) {
		// private device info

		sink(&self.api_key); // $ MISSING: sensitive=id
		sink(&other.api_key); // $ MISSING: sensitive=id
		sink(&self.deviceApiToken); // $ MISSING: sensitive=id
		sink(&self.finger_print); // $ MISSING: sensitive=id
		sink(&self.ip_address); // $ MISSING: sensitive=id
		sink(self.macaddr12); // $ MISSING: sensitive=id
		sink(&self.mac_addr); // $ MISSING: sensitive=id
		sink(self.mac_addr.values); // $ MISSING: sensitive=id
		sink(self.mac_addr.values[0]); // $ MISSING: sensitive=id
		sink(&self.networkMacAddress); // $ MISSING: sensitive=id

		// not private device info

		sink(self.macro_value);
		sink(self.mac_command);
		sink(&self.skip_address);
	}
}

struct Financials {
	harmless: String,
	my_bank_account_number: String,
	credit_card_no: String,
	credit_rating: i32,
	user_ccn: String,
	cvv: String,
	beneficiary: String,
	routing_number: u64,
	routingNumberText: String,
	iban: String,
	iBAN: String,

	num_accounts: i32,
	total_accounts: i32,
	accounting: i32,
	unaccounted: bool,
	multiband: bool,
}

enum Gender {
	Male,
	Female,
}

struct SSN {
	data: u128,
}

impl SSN {
	fn get_data(&self) -> u128 {
		return self.data;
	}
}

struct MyPrivateInfo {
	mobile_phone_num: String,
	contact_email: String,
	contact_e_mail_2: String,
	emergency_contact: String,
	my_ssn: String,
	ssn: SSN,
	birthday: String,
	name_of_employer: String,

	gender: Gender,
	genderString: String,

	patient_id: u64,
	linkedPatientId: u64,
	patient_record: String,
	medical_notes: Vec<String>,
	confidentialMessage: String,

	latitude: f64,
	longitude: Option<f64>,

	financials: Financials
}

enum ContactDetails {
	HomePhoneNumber(String),
	MobileNumber(String),
	Email(String),
	FavouriteColor(String),
}

fn test_private_info(
	info: &MyPrivateInfo, details: &ContactDetails,
) {
	// private info

	sink(info.mobile_phone_num.as_str()); // $ sensitive=private
	sink(info.mobile_phone_num.to_string()); // $ sensitive=private
	sink(info.contact_email.as_str()); // $ MISSING: sensitive=private
	sink(info.contact_e_mail_2.as_str()); // $ MISSING: sensitive=private
	sink(info.my_ssn.as_str()); // $ sensitive=private
	sink(&info.ssn); // $ sensitive=private
	sink(info.ssn.data); // $ sensitive=private
	sink(info.ssn.get_data()); // $ sensitive=private
	sink(info.birthday.as_str()); // $ sensitive=private
	sink(info.emergency_contact.as_str()); // $ sensitive=private
	sink(info.name_of_employer.as_str()); // $ sensitive=private

	sink(&info.gender); // $ MISSING: sensitive=private
	sink(info.genderString.as_str()); // $ MISSING: sensitive=private
	let sex = "Male";
	let gender = Gender::Female;
	let a = Gender::Female;
	sink(sex); // $ MISSING: sensitive=private
	sink(gender); // $ MISSING: sensitive=private
	sink(a); // $ MISSING: sensitive=private

	sink(info.patient_id); // $ MISSING: sensitive=private
	sink(info.linkedPatientId); // $ MISSING: sensitive=private
	sink(info.patient_record.as_str()); // $ MISSING: sensitive=private
	sink(info.patient_record.trim()); // $ MISSING: sensitive=private
	sink(&info.medical_notes); // $ sensitive=private
	sink(info.medical_notes[0].as_str()); // $ sensitive=private
	for n in info.medical_notes.iter() {
		sink(n.as_str()); // $ sensitive=private
	}
	sink(info.confidentialMessage.as_str()); // $ MISSING: sensitive=private
	sink(info.confidentialMessage.to_lowercase()); // $ MISSING: sensitive=private

	sink(info.latitude); // $ sensitive=private
	let x = info.longitude.unwrap();
	sink(x); // $ sensitive=private

	sink(info.financials.my_bank_account_number.as_str()); // $ sensitive=private SPURIOUS: sensitive=id
	sink(info.financials.credit_card_no.as_str()); // $ sensitive=private
	sink(info.financials.credit_rating); // $ sensitive=private
	sink(info.financials.user_ccn.as_str()); // $ sensitive=private
	sink(info.financials.cvv.as_str()); // $ MISSING: sensitive=private
	sink(info.financials.beneficiary.as_str()); // $ MISSING: sensitive=private
	sink(info.financials.routing_number); // $ MISSING: sensitive=private
	sink(info.financials.routingNumberText.as_str()); // $ MISSING: sensitive=private
	sink(info.financials.iban.as_str()); // $ MISSING: sensitive=private
	sink(info.financials.iBAN.as_str()); // $ MISSING: sensitive=private

	sink(ContactDetails::HomePhoneNumber("123".to_string())); // $ sensitive=private
	sink(ContactDetails::MobileNumber("123".to_string())); // $ sensitive=private
	sink(ContactDetails::Email("a@b".to_string())); // $ MISSING: sensitive=private
	if let ContactDetails::MobileNumber(num) = details {
		sink(num.as_str()); // $ MISSING: sensitive=private
	}

	// not private info

	let modulesEx = 1;
	sink(modulesEx);

	sink(info.financials.harmless.as_str());
	sink(info.financials.num_accounts); // $ SPURIOUS: sensitive=id
	sink(info.financials.total_accounts); // $ SPURIOUS: sensitive=id
	sink(info.financials.accounting); // $ SPURIOUS: sensitive=id
	sink(info.financials.unaccounted); // $ SPURIOUS: sensitive=id
	sink(info.financials.multiband);

	sink(ContactDetails::FavouriteColor("blue".to_string()));
}
