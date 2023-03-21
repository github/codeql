struct X509_NAME {};
struct SSL {};
struct X509 {};

char * X509_NAME_oneline(X509_NAME *a,char *buf,int size);
X509 *SSL_get_peer_certificate(const SSL *ssl);
X509_NAME *X509_get_subject_name(const X509 *x);
char *strcasestr(char *a, char *b);

bool goodTest1(SSL *ssl,char *text)
{
  X509 *peer;
  char buf[256];
  if( peer = SSL_get_peer_certificate(ssl))
  {
    X509_NAME_oneline(X509_get_subject_name(peer),buf,sizeof(buf)); // GOOD
    if((char*)strcasestr(buf,text)) return true;
  }
  return false;
}
bool badTest1(SSL *ssl,char *text)
{
  X509 *peer;
  char buf[256];
  if( peer = SSL_get_peer_certificate(ssl))
  {
    X509_NAME_oneline(X509_get_subject_name(peer),buf,1024); // BAD
    if((char*)strcasestr(buf,text)) return true;
  }
  return false;
}
