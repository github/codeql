...
SSL_shutdown(ssl); 
SSL_shutdown(ssl); // BAD
...
    switch ((ret = SSL_shutdown(ssl))) {
    case 1:
      break;
    case 0:
      ERR_clear_error();
      if (-1 != (ret = SSL_shutdown(ssl))) break; // GOOD
...
