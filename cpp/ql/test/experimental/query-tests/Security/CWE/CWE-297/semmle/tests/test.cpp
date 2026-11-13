#define X509_V_OK 0
#define NULL  0
#define X509_CHECK_FLAG_NO_PARTIAL_WILDCARDS 1
#define SSL_VERIFY_PEER 1
#define STACK_OF(type) struct type

typedef unsigned long size_t;

struct SSL {};
struct X509_STORE_CTX {};
struct X509_VERIFY_PARAM {};
struct X509 {};
struct X509_NAME {};
struct X509_NAME_ENTRY {};

struct ASN1_STRING {};

struct GENERAL_NAME 
{
ASN1_STRING *d_dNSName;
};

int cmpNames(char* name1,char* name2);
char* calloc( size_t num, size_t size );
size_t strlen( char * buf);

X509 *SSL_get_peer_certificate(const SSL *ssl);
int SSL_get_verify_result(const SSL *ssl);

int verify_callback(int a, X509_STORE_CTX *b);
X509_VERIFY_PARAM *SSL_get0_param(SSL *ssl);
void X509_VERIFY_PARAM_set_hostflags(X509_VERIFY_PARAM *param,unsigned int flags);
int X509_VERIFY_PARAM_set1_host(X509_VERIFY_PARAM *param,char *name, size_t namelen);
void SSL_set_verify(SSL *s, int mode,int (*verify_callback)(int, X509_STORE_CTX *));

void SSL_set_hostflags(SSL *s, unsigned int flags);
int SSL_set1_host(SSL *s, const char *hostname);

GENERAL_NAME * X509_get_ext_d2i(const X509 *x, int nid, int *crit, int *idx);
int X509_NAME_get_text_by_NID(X509_NAME *name, int nid, char *buf,int len);
X509_NAME *X509_get_subject_name(const X509 *x);
int X509_NAME_get_index_by_NID(X509_NAME *name,int nid,int lastpos);
X509_NAME_ENTRY *X509_NAME_get_entry(X509_NAME *name, int loc);
ASN1_STRING *X509_NAME_ENTRY_get_data(const X509_NAME_ENTRY *ne);
char * ASN1_STRING_data(ASN1_STRING *x);

int SKM_sk_num(struct GENERAL_NAME * a);
#define 	sk_GENERAL_NAME_num(st)   SKM_sk_num((st))
GENERAL_NAME* SKM_sk_value(struct GENERAL_NAME * a,int b);
#define sk_GENERAL_NAME_value(st, i)   SKM_sk_value((st), (i))
bool goodTest1(SSL *ssl,char * host,int nid) // GOOD
{
  X509 *cert;
  int result,count,i;
  char *data;
  STACK_OF(GENERAL_NAME) *names = NULL;
  GENERAL_NAME *altname;

  result = SSL_get_verify_result(ssl);
  if (result == X509_V_OK)
  {
    cert = SSL_get_peer_certificate(ssl);
    names = X509_get_ext_d2i (cert, nid, NULL, NULL);
    if(names==NULL) return false;
    count = sk_GENERAL_NAME_num(names);
    for(i=0;i<count;i++)
    {
      altname = sk_GENERAL_NAME_value (names, i);
      data = ASN1_STRING_data (altname->d_dNSName);
      if(cmpNames(host,data)==0) return true;
    }
    return false;
  }
  return false;
}
bool goodTest2(SSL *ssl,char * host,int nid) // GOOD
{
  X509 *cert;
  int result,len,i;
  char *data;
  STACK_OF(GENERAL_NAME) *names = NULL;
  GENERAL_NAME *altname;
  X509_NAME *name;

  result = SSL_get_verify_result(ssl);
  if (result == X509_V_OK)
  {
    cert = SSL_get_peer_certificate(ssl);
    name = X509_get_subject_name (cert);
    if (name == NULL) return false;
    len = X509_NAME_get_text_by_NID (name, nid, NULL, 0);
    if (len < 0) return false;
    data = calloc (len + 1, 1);
    if (data == NULL) return false;
    X509_NAME_get_text_by_NID (name, nid, data, len + 1);
    if(cmpNames(host,data)==0) return true;
  }
  return false;
}

bool goodTest3(SSL *ssl,char * host,int nid) // GOOD
{
  X509 *cert;
  int result,len,i;
  char *data;
  STACK_OF(GENERAL_NAME) *names = NULL;
  GENERAL_NAME *altname;
  X509_NAME_ENTRY * centry;
  result = SSL_get_verify_result(ssl);
  if (result == X509_V_OK)
  {
    cert = SSL_get_peer_certificate(ssl);
    len = X509_NAME_get_text_by_NID (X509_get_subject_name (cert), nid, NULL, 0);
    if (len < 0) return false;
    centry = X509_NAME_get_entry(X509_get_subject_name(cert), len);
    if(centry == NULL) return false;
    data = (char *) ASN1_STRING_data(X509_NAME_ENTRY_get_data(centry));
    if(cmpNames(host,data)==0) return true;
  }
  return false;
}

bool goodTest4(SSL *ssl,char * host) // GOOD
{
  SSL_set_hostflags(ssl, X509_CHECK_FLAG_NO_PARTIAL_WILDCARDS);
  if (!SSL_set1_host(ssl, host)) return false;
  SSL_set_verify(ssl, SSL_VERIFY_PEER, NULL);
  return true;
}
bool goodTest5(SSL *ssl,char * host) // GOOD
{
  X509_VERIFY_PARAM *param = SSL_get0_param(ssl);
  X509_VERIFY_PARAM_set_hostflags(param,X509_CHECK_FLAG_NO_PARTIAL_WILDCARDS);
  if (!X509_VERIFY_PARAM_set1_host(param, host,strlen(host))) return false;
  SSL_set_verify(ssl, SSL_VERIFY_PEER, NULL);
  return true;
}
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
