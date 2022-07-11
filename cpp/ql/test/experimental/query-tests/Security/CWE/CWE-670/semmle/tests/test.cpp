// it's not exact, but it's enough for an example
typedef int SSL;


int SSL_shutdown(SSL *ssl);
int SSL_get_error(const SSL *ssl, int ret);
void ERR_clear_error(void);
void print_error(char *buff,int code);

int gootTest1(SSL *ssl)
{
  int ret;
    switch ((ret = SSL_shutdown(ssl))) {
    case 1:
      break;
    case 0:
      ERR_clear_error();
      if ((ret = SSL_shutdown(ssl)) == 1) break; // GOOD
    default:
      print_error("error shutdown",
        SSL_get_error(ssl, ret));
      return -1;
    }
 return 0;
}
int gootTest2(SSL *ssl)
{
  int ret;
    switch ((ret = SSL_shutdown(ssl))) {
    case 1:
      break;
    case 0:
      ERR_clear_error();
      if (-1 != (ret = SSL_shutdown(ssl))) break; // GOOD
    default:
      print_error("error shutdown",
        SSL_get_error(ssl, ret));
      return -1;
    }
 return 0;
}
int badTest1(SSL *ssl)
{
  int ret;
    switch ((ret = SSL_shutdown(ssl))) {
    case 1:
      break;
    case 0:
      SSL_shutdown(ssl); // BAD
      break;
    default:      
      print_error("error shutdown",
        SSL_get_error(ssl, ret));
      return -1;
    }
 return 0;
}
int badTest2(SSL *ssl)
{
  int ret;
    ret = SSL_shutdown(ssl);
    switch (ret) {
    case 1:
      break;
    case 0:
      SSL_shutdown(ssl); // BAD
      break;
    default:
      print_error("error shutdown",
        SSL_get_error(ssl, ret));
      return -1;
    }
 return 0;
}

