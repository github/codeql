
typedef unsigned long size_t;

size_t strlen(const char *s);

void send(int a, const void *buf, size_t bufLen, int d);
void recv(int a, void *buf, size_t bufLen, int d);

void LogonUserA(int a, int b, const char *password, int d, int e, int f);

int val();

void test_send(const char *password1, const char *password2, const char *password_hash, const char *message)
{
	{
		LogonUserA(val(), val(), password1, val(), val(), val()); // proof `password` is plaintext

		send(val(), password1, strlen(password1), val()); // BAD: `password` is sent plaintext (certainly) [NOT DETECTED]
	}

	{
		send(val(), password2, strlen(password2), val()); // BAD: `password` is sent plaintext (probably) [NOT DETECTED]
	}

	{
		send(val(), password_hash, strlen(password_hash), val()); // GOOD: `password` is sent encrypted
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
