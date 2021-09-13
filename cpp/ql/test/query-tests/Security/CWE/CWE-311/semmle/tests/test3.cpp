
typedef unsigned long size_t;
#define STDIN_FILENO (0)

size_t strlen(const char *s);

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

		my_recv(password, 256); // BAD: `password` is received plaintext [detected on line 108]
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
