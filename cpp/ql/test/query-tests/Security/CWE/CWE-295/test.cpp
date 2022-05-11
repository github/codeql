
struct SSL {
	// ...
};

int SSL_get_verify_result(const SSL *ssl);
int get_verify_result_indirect(const SSL *ssl) { return SSL_get_verify_result(ssl); }

int something_else(const SSL *ssl);

bool is_ok(int result)
{
	return (result == 0); // GOOD
}

bool is_maybe_ok(int result)
{
	return (result == 0) || (result == 1); // BAD (conflates OK and a non-OK codes)
}

void test1_1(SSL *ssl)
{
	{
		int result = SSL_get_verify_result(ssl);

		if (result == 0) // GOOD
		{
		}

		if (result == 1) // GOOD
		{
		}
	}

	{
		int result = SSL_get_verify_result(ssl);

		if ((result == 0) || (result == 1)) // BAD (conflates OK and a non-OK codes)
		{
		}
	}

	{
		int result = SSL_get_verify_result(ssl);

		if ((result == 1) || (result == 2)) // GOOD (both results are non-OK)
		{
		}
	}

	{
		int result = SSL_get_verify_result(ssl);

		if ((result == 0) || (false) || (result == 2)) // BAD (conflates OK and a non-OK codes)
		{
		}
	}

	{
		int result = SSL_get_verify_result(ssl);

		if ((0 == result) || (1 == result)) // BAD (conflates OK and a non-OK codes)
		{
		}
	}

	{
		int result = SSL_get_verify_result(ssl);

		if ((result != 0) && (result != 1)) // BAD (conflates OK and a non-OK codes)
		{
		} else {
			// conflation occurs here
		}
	}

	{
		int result = SSL_get_verify_result(ssl);
		int result_cpy = result;
		int result2 = get_verify_result_indirect(ssl);
		int result3 = something_else(ssl);

		if ((result == 0) || (result_cpy == 1)) // BAD (conflates OK and a non-OK codes)
		{
		}
	
		if ((result2 == 0) || (result2 == 1)) // BAD (conflates OK and a non-OK codes)
		{
		}
	
		if ((result3 == 0) || (result3 == 1)) // GOOD (not an SSL result)
		{
		}
	}

	if (is_ok(SSL_get_verify_result(ssl)))
	{
	}

	if (is_maybe_ok(SSL_get_verify_result(ssl)))
	{
	}

	{
		int result = SSL_get_verify_result(ssl);

		bool ok = (result == 0) || (result == 1); // BAD (conflates OK and a non-OK codes)
	
		if (ok) {
		}
	}

	{
		int result = SSL_get_verify_result(ssl);

		if (result == 1) // BAD (conflates OK and a non-OK codes in `else`) [NOT DETECTED]
		{
		} else {
		}
	}
}

void do_good();

void test1_2(SSL *ssl)
{
	int result = SSL_get_verify_result(ssl);

	if (result == 0) { // GOOD
		do_good();
	} else if (result == 1) {
		throw 1;
	} else {
		throw 1;
	}
}

void test1_3(SSL *ssl)
{
	int result = SSL_get_verify_result(ssl);

	if (result == 0) { // BAD (error code 1 is treated as OK, not as non-OK) [NOT DETECTED]
		do_good();
	} else if (result == 1) {
		do_good();
	} else {
		throw 1;
	}
}
