
struct SSL {
	// ...
};

int SSL_get_peer_certificate(const SSL *ssl);
int SSL_get_verify_result(const SSL *ssl);

bool maybe();

bool test2_1(SSL *ssl)
{
	int cert = SSL_get_peer_certificate(ssl); // BAD (SSL_get_verify_result is never called)

	return true;
}

bool test2_2(SSL *ssl)
{
	int cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is always called)
	int result = SSL_get_verify_result(ssl);

	return (result == 0);
}

bool test2_3(SSL *ssl)
{
	int cert = SSL_get_peer_certificate(ssl); // BAD (SSL_get_verify_result may not be called)

	if (maybe())
	{
		int result = SSL_get_verify_result(ssl);

		return (result == 0);
	}

	return true;
}

bool test2_4(SSL *ssl)
{
	int cert, result;

	cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is called when there is a cert)
	if (cert != 0)
	{
		result = SSL_get_verify_result(ssl);
		if (result == 0)
		{
			return true;
		}
	}

	return false;
}

bool test2_5(SSL *ssl)
{
	int cert, result;

	cert = SSL_get_peer_certificate(ssl); // BAD (SSL_get_verify_result is not used reliably)
	if ((cert != 0) && (maybe()))
	{
		result = SSL_get_verify_result(ssl);
		if (result == 0)
		{
			return true;
		}
	}

	return false;
}

bool test2_6(SSL *ssl)
{
	int cert;

	cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is called when there is a cert)
	if (cert == 0) return false;
	if (SSL_get_verify_result(ssl) != 0) return false;

	return true;
}

bool test2_7(SSL *ssl)
{
	int cert;

	cert = SSL_get_peer_certificate(ssl); // BAD (SSL_get_verify_result is only called when there is not a cert)
	if (cert != 0) return false;
	if (SSL_get_verify_result(ssl) != 0) return false;

	return true;
}

bool test2_8(SSL *ssl)
{
	int cert;

	cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is called when there is a cert)
	if (!cert) return false;
	if (!SSL_get_verify_result(ssl)) return false;

	return true;
}

bool test2_9(SSL *ssl)
{
	int cert;

	cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is called when there is a cert)
	if ((!cert) || (SSL_get_verify_result(ssl) != 0)) {
		return false;
	}

	return true;
}

bool test2_10(SSL *ssl)
{
	int cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is called when there is a cert)

	if (cert)
	{
		int result = SSL_get_verify_result(ssl);

		if (result == 0)
		{
			return true;
		}
	}

	return true;
}

bool test2_11(SSL *ssl)
{
	int cert;

	cert = SSL_get_peer_certificate(ssl); // GOOD (SSL_get_verify_result is called when there is a cert)

	if ((cert) && (SSL_get_verify_result(ssl) == 0)) {
		return true;
	}

	return false;
}
