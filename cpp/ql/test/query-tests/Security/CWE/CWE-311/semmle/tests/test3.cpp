
typedef unsigned long size_t;
#define STDIN_FILENO (0)
#define STDOUT_FILENO (1)
int stdout_fileno = STDOUT_FILENO;

size_t strlen(const char *s);
int snprintf(char *s, size_t n, const char *format, ...);
void send(int fd, const void *buf, size_t bufLen, int d);
void recv(int fd, void *buf, size_t bufLen, int d);
void read(int fd, void *buf, size_t bufLen);

void LogonUserA(int a, int b, const char *password, int d, int e, int f);

int val();

void test_send(const char *password1, const char *password2, const char *password_hash, const char *message)
{
	{
		LogonUserA(val(), val(), password1, val(), val(), val()); // proof `password1` is plaintext

		send(val(), password1, strlen(password1), val()); // BAD: `password1` is sent plaintext (certainly)
	}

	{
		send(val(), password2, strlen(password2), val()); // BAD: `password2` is sent plaintext (probably)
	}

	{
		send(val(), password_hash, strlen(password_hash), val()); // GOOD: `password_hash` is sent encrypted
	}

	{
		send(val(), message, strlen(message), val()); // GOOD: `message` is not a password
	}

	{
		send(stdout_fileno, password2, strlen(password2), val()); // GOOD: `password2` is sent to stdout, not a network socket (this may be an issue but is not within the scope of the `cpp/cleartext-transmission` query)
	}
}

void test_receive()
{
	{
		char password[256];

		recv(val(), password, 256, val()); // BAD: `password` is received plaintext (certainly)

		LogonUserA(val(), val(), password, val(), val(), val()); // (proof `password` is plaintext)
	}

	{
		char password[256];

		recv(val(), password, 256, val()); // BAD: `password` is received plaintext (probably)
	}

	{
		char password_hash[256];

		recv(val(), password_hash, 256, val()); // GOOD: `password` is received encrypted
	}

	{
		char message[256];

		recv(val(), message, 256, val()); // GOOD: `message` is not a password
	}
}

void test_dataflow(const char *password1)
{
	{
		const char *ptr = password1;

		send(val(), ptr, strlen(ptr), val()); // BAD: `password` is sent plaintext
	}

	{
		char password[256];
		char *ptr = password;

		recv(val(), ptr, 256, val()); // BAD: `password` is received plaintext
	}

	{
		char buffer[256];

		recv(val(), buffer, 256, val()); // BAD: `password` is received plaintext [NOT DETECTED]

		char *password = buffer;
	}
}

void test_read()
{
	{
		char password[256];
		int fd = val();

		read(fd, password, 256); // BAD: `password` is received plaintext
	}

	{
		char password[256];
		int fd = STDIN_FILENO;

		read(fd, password, 256); // GOOD: `password` is received from stdin, not a network socket
	}
}

void my_recv(char *buffer, size_t bufferSize)
{
	recv(val(), buffer, bufferSize, val());
}

const char *id(const char *buffer)
{
	return buffer;
}

char *global_password;

char *get_global_str()
{
	return global_password;
}

void test_interprocedural(const char *password1)
{
	{
		char password[256];

		my_recv(password, 256); // BAD: `password` is received plaintext [detected in `my_recv`]
	}

	{
		const char *ptr = id(password1);

		send(val(), ptr, strlen(ptr), val()); // BAD: `password1` is sent plaintext
	}

	{
		char *data = get_global_str();

		send(val(), data, strlen(data), val()); // BAD: `global_password` is sent plaintext
	}
}

char *strncpy(char *s1, const char *s2, size_t n);

void test_taint(const char *password)
{
	{
		char buffer[16];

		strncpy(buffer, password, 16);
		buffer[15] = 0;
		send(val(), buffer, 16, val()); // BAD: `password` is (partially) sent plaintext
	}
}

void encrypt_inplace(char *buffer);
void decrypt_inplace(char *buffer);
char *rtn_encrypt(const char *buffer);
char *rtn_decrypt(const char *buffer);

void test_decrypt()
{
	{
		char password[256];

		recv(val(), password, 256, val()); // GOOD: password is encrypted

		decrypt_inplace(password); // proof that `password` was in fact encrypted
	}

	{
		char password[256];

		recv(val(), password, 256, val()); // GOOD: password is encrypted
		password[255] = 0;

		decrypt_inplace(password); // proof that `password` was in fact encrypted
	}

	{
		char password[256];
		char *password_ptr;

		recv(val(), password, 256, val()); // GOOD: password is encrypted

		password_ptr = rtn_decrypt(password); // proof that `password` was in fact encrypted
	}

	{
		char password[256];

		encrypt_inplace(password); // proof that `password` is in fact encrypted

		send(val(), password, strlen(password), val()); // GOOD: password is encrypted
	}

	{
		char password[256];

		encrypt_inplace(password); // proof that `password` is in fact encrypted
		password[255] = 0;

		send(val(), password, strlen(password), val()); // GOOD: password is encrypted
	}

	{
		char password[256];
		char *password_ptr;

		password_ptr = rtn_encrypt(password); // proof that `password` is in fact encrypted

		send(val(), password_ptr, strlen(password_ptr), val()); // GOOD: password is encrypted
	}
}

int get_socket(int from);

void test_more_stdio(const char *password)
{
	send(get_socket(1), password, 128, val()); // GOOD: `getsocket(1)` is probably standard output
	send(get_socket(val()), password, 128, val()); // BAD
}

typedef struct {} FILE;
char *fgets(char *s, int n, FILE *stream);

FILE *get_stdstream(int index);
#define STDIN_STREAM (get_stdstream(0))

void test_fgets(FILE *stream)
{
	char password[128];

	fgets(password, 128, stream); // BAD
	fgets(password, 128, STDIN_STREAM); // GOOD: `STDIN_STREAM` is probably standard input
}

void encrypt_to_buffer(const char *input, char* output);
void decrypt_to_buffer(const char *input, char* output);
char *strcpy(char *s1, const char *s2);

void test_crypt_more()
{
	{
		char password1[256], password2[256];

		recv(val(), password1, 256, val()); // GOOD: password is encrypted

		decrypt_to_buffer(password1, password2); // proof that `password1` was in fact encrypted
	}

	{
		char password1[256], password2[256];

		encrypt_to_buffer(password1, password2); // proof that `password2` is in fact encrypted

		send(val(), password2, strlen(password2), val()); // GOOD: password is encrypted
	}

	{
		char data[256], password[256];

		strcpy(data, password); // not proof of anything

		send(val(), data, strlen(data), val()); // BAD: password is sent plaintext
	}
}

bool cond();

void target1(char *data)
{
	send(val(), data, strlen(data), val()); // GOOD: encrypted
}

void target2(char *data)
{
	send(val(), data, strlen(data), val()); // BAD: from one source this is a plaintext password [NOT DETECTED]
}

void target3(char *data)
{
	send(val(), data, strlen(data), val()); // BAD: data is a plaintext password
}

void target4(char *data)
{
	send(val(), data, strlen(data), val()); // BAD: data is a plaintext password
}

void target5(char *data)
{
	send(val(), data, strlen(data), val()); // BAD: from one source this is a plaintext password
}

void target6(char *data)
{
	send(val(), data, strlen(data), val()); // GOOD: not a password
}

void test_multiple_sources_source(char *password1, char *password2)
{
	if (cond())
	{
		encrypt_inplace(password1);
		target1(password1);
		target2(password1);
	} else {
		target2(password1);
		target3(password1);
	}

	if (cond())
	{
		char *data = password2;

		target4(data);
		target5(data);
	} else {
		char *data = "harmless";

		target5(data);
		target6(data);
	}
}

void test_loops()
{
	{
		while (cond())
		{
			char password[256];

			recv(val(), password, 256, val()); // BAD: not encrypted
			
			// ...
		}
	}

	{
		while (cond())
		{
			char password[256];

			recv(val(), password, 256, val()); // GOOD: password is encrypted
			decrypt_inplace(password); // proof that `password` was in fact encrypted
			
			// ...
		}
	}
}

void DoDisguisedOperation(char *buffer, size_t size);
void SecureZeroBuffer(char *buffer, size_t size);

void test_securezero()
{
	{
		char password[256];

		recv(val(), password, 256, val()); // GOOD: password is (probably) encrypted

		DoDisguisedOperation(password, 256); // decryption (disguised)

		// ...

		SecureZeroBuffer(password, 256); // evidence we may have been doing decryption
	}
}

struct encrypted_data
{
	char data[256];
};

void test_more_clues()
{
	{
		char password[256];

		recv(val(), password, 256, val()); // BAD: not encrypted
	}

	{
		char encrypted_password[256];

		recv(val(), encrypted_password, 256, val()); // GOOD: password is (probably) encrypted
	}

	{
		encrypted_data password;

		recv(val(), &password, sizeof(password), val()); // GOOD: password is (probably) encrypted
	}
}

struct packet
{
	char password[256];
};

void test_member_password()
{
	{
		packet p;

		recv(val(), p.password, 256, val()); // BAD: not encrypted
	}

	{
		packet p;

		recv(val(), p.password, 256, val()); // GOOD: password is encrypted [FALSE POSITIVE]
		decrypt_inplace(p.password); // proof that `password` was in fact encrypted
	}
}

extern FILE *stdin;

void test_stdin_param(FILE *stream)
{
	char password[128];

	fgets(password, 128, stream); // GOOD: from standard input (see call below) [FALSE POSITIVE]
}

void test_stdin()
{
	char password[128];
	FILE *f = stdin;

	fgets(password, 128, stdin); // GOOD: from standard input
	fgets(password, 128, f); // GOOD: from standard input
	test_stdin_param(stdin);
}

int open(const char *filename, int b);

void test_tty()
{
	{
		char password[256];
		int f;

		f = open("/dev/tty", val());
		recv(f, password, 256, val()); // GOOD: from terminal
	}

	{
		char password[256];
		int f;

		f = STDIN_FILENO;
		recv(f, password, 256, val()); // GOOD: from stdin
	}

	{
		char password[256];
		int f;

		f = open("/dev/tty", val());
		if (f == -1)
		{
			f = STDIN_FILENO;
		}

		recv(f, password, 256, val()); // GOOD: from terminal or stdin
	}
}

// ---

struct person_info
{
	// sensitive
	char *social_security_number;
	char *socialSecurityNo;
	char *homePostCode;
	char *my_zip_code;
	char *telephone;
	char *mobile_phone_number;
	char *email;
	char *my_credit_card_number;
	char *my_bank_account_no;
	char *employerName;
	char medical_info[8 * 1024];
	char *license_key;
	double my_latitude;
	double home_longitude;
	int newSalary;
	char *salaryString;
	// not sensitive
	char *license_key_hash;
	char *my_zip_file;
};

void tests2(person_info *pi)
{
	// direct cases
	send(val(), pi->social_security_number, strlen(pi->social_security_number), val()); // BAD
	send(val(), pi->socialSecurityNo, strlen(pi->socialSecurityNo), val()); // BAD
	send(val(), pi->homePostCode, strlen(pi->homePostCode), val()); // BAD
	send(val(), pi->my_zip_code, strlen(pi->my_zip_code), val()); // BAD
	send(val(), pi->telephone, strlen(pi->telephone), val()); // BAD
	send(val(), pi->mobile_phone_number, strlen(pi->mobile_phone_number), val()); // BAD
	send(val(), pi->email, strlen(pi->email), val()); // BAD
	send(val(), pi->my_credit_card_number, strlen(pi->my_credit_card_number), val()); // BAD
	send(val(), pi->my_bank_account_no, strlen(pi->my_bank_account_no), val()); // BAD
	send(val(), pi->employerName, strlen(pi->employerName), val()); // BAD
	send(val(), pi->medical_info, strlen(pi->medical_info), val()); // BAD
	send(val(), pi->license_key, strlen(pi->license_key), val()); // BAD
	send(val(), pi->license_key_hash, strlen(pi->license_key_hash), val()); // GOOD
	send(val(), pi->my_zip_file, strlen(pi->my_zip_file), val()); // GOOD

	// indirect cases
	{
		char buffer[1024];

		snprintf(buffer, 1024, "lat = %f\n", pi->my_latitude);
		send(val(), buffer, strlen(buffer), val()); // BAD
	}
	{
		char buffer[1024];

		snprintf(buffer, 1024, "long = %f\n", pi->home_longitude);
		send(val(), buffer, strlen(buffer), val()); // BAD
	}
	{
		char buffer[1024];

		snprintf(buffer, 1024, "salary = %i\n", pi->newSalary);
		send(val(), buffer, strlen(buffer), val()); // BAD [NOT DETECTED]
	}
	{
		char buffer[1024];
		int sal = pi->newSalary;

		snprintf(buffer, 1024, "salary = %i\n", sal);
		send(val(), buffer, strlen(buffer), val()); // BAD [NOT DETECTED]
	}
	{
		char buffer[1024];

		snprintf(buffer, 1024, "salary = %s\n", pi->salaryString);
		send(val(), buffer, strlen(buffer), val()); // BAD
	}
	{
		char buffer[1024];
		char *sal = pi->salaryString;

		snprintf(buffer, 1024, "salary = %s\n", sal);
		send(val(), buffer, strlen(buffer), val()); // BAD
	}
}

const char *get_home_phone();
const char *get_home();
const char *get_home_address();

void tests3()
{
	const char *str;

	str = get_home_phone();
	send(val(), str, strlen(str), val()); // BAD

	str = get_home();
	send(val(), str, strlen(str), val()); // GOOD (probably not personal info)

	str = get_home_address();
	send(val(), str, strlen(str), val()); // BAD
}
