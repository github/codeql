void bad()
{
  char ip[100];

  sprintf(ip, "%s", getenv("HTTP_X_FORWARDED_FOR"));
  if (ip == "192.0.2.1") {
    // Attempts to ban address, but easily bypassed by spoofing.
    exit(1);
  }
}

void good()
{
  char ips[1000];
  char *token, *ip;

  sprintf(ips, "%s", getenv("HTTP_X_FORWARDED_FOR"));
  while (token = strsep(&ips, ",")) ip = token;
  if (ip == "192.0.2.1") {
    // Bans address using final header value,
    // reliably provided by locally controlled reverse proxy.
    exit(1);
  }
}
