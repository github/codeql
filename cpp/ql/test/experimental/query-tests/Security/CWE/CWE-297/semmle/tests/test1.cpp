#define X509_V_OK 0
#define NULL  0

struct SSL {};
struct X509 {};

X509 *SSL_get_peer_certificate(const SSL *ssl);
int SSL_get_verify_result(const SSL *ssl);


bool badTest1(SSL *ssl) // BAD :no hostname verification in certificate
{
  X509 *cert;
  int result;

  result = SSL_get_verify_result(ssl);
  if (result == X509_V_OK)
  {
    cert = SSL_get_peer_certificate(ssl);
    if(cert) return true;
  }
  return false;
}
