#define NULL  0
struct gnutls_session_t{};
struct gnutls_x509_crt_t{};

int gnutls_x509_crt_init(gnutls_x509_crt_t * cert);
int gnutls_x509_crt_check_hostname(gnutls_x509_crt_t cert, const char *hostname);
int gnutls_x509_crt_check_hostname2(gnutls_x509_crt_t cert,const char *hostname, int flags);

int gnutls_certificate_verify_peers(gnutls_session_t session);
int gnutls_certificate_verify_peers2(gnutls_session_t session, int * status);
int gnutls_certificate_verify_peers3(gnutls_session_t session, const char * hostname, int * status);
int goodTest1(gnutls_session_t session, gnutls_x509_crt_t cert){ // GOOD
  if(gnutls_certificate_verify_peers(session)<0)
    return 1;
  if (gnutls_x509_crt_init (&cert) < 0)
    return 1;
  if (!gnutls_x509_crt_check_hostname (cert, "hostname"))
    return 1;
  return 0;
}
int goodTest2(gnutls_session_t session, gnutls_x509_crt_t cert){ // GOOD
  int status;
  if(gnutls_certificate_verify_peers2(session,&status)<0)
    return 1;
  if (gnutls_x509_crt_init (&cert) < 0)
    return 1;
  if (!gnutls_x509_crt_check_hostname2 (cert, "hostname", status))
    return 1;
  return 0;
}
int goodTest3(gnutls_session_t session, gnutls_x509_crt_t cert){ // GOOD
  int status;
  if(gnutls_certificate_verify_peers3(session,NULL,&status)<0)
    return 1;
  if (gnutls_x509_crt_init (&cert) < 0)
    return 1;
  if (!gnutls_x509_crt_check_hostname2 (cert, "hostname", status))
    return 1;
  return 0;
}
int goodTest4(gnutls_session_t session){ // GOOD
  int status;
  if(gnutls_certificate_verify_peers3(session,"host.name",&status)<0)
    return 1;
  return 0;
}
int badTest1(gnutls_session_t session){ // BAD
  int status;
  if(gnutls_certificate_verify_peers3(session,NULL,&status)<0)
    return 1;
  return 0;
}
int badTest2(gnutls_session_t session){ // BAD
  int status;
  if(gnutls_certificate_verify_peers2(session,&status)<0)
    return 1;
  return 0;
}
int badTest3(gnutls_session_t session){ // BAD
  if(gnutls_certificate_verify_peers(session)<0)
    return 1;
  return 0;
}
