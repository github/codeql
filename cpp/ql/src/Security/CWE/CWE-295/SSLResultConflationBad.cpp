// ...

if (cert = SSL_get_peer_certificate(ssl))
{
	result = SSL_get_verify_result(ssl);

	if ((result == X509_V_OK) || (result == X509_V_ERR_CERT_HAS_EXPIRED)) // BAD (conflates OK and a non-OK codes)
	{
		do_ok();
	} else {
		do_error();
	}
}
