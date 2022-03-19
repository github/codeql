// ...

if (cert = SSL_get_peer_certificate(ssl))
{
	result = SSL_get_verify_result(ssl);

	if (result == X509_V_OK) // GOOD
	{
		do_ok();
	} else {
		do_error();
	}
}
