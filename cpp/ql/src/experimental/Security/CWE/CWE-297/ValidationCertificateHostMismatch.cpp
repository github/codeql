
...
  SSL_set_hostflags(ssl, X509_CHECK_FLAG_NO_PARTIAL_WILDCARDS);
  if (!SSL_set1_host(ssl, host)) return false;
  SSL_set_verify(ssl, SSL_VERIFY_PEER, NULL); // GOOD
...
  result = SSL_get_verify_result(ssl);
  if (result == X509_V_OK)
  {
    cert = SSL_get_peer_certificate(ssl);
    if(cert) return true; // BAD
  }
...
