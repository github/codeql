void log_connection_attempt(const char *user_name, char char *ip_address) {
  // This does not print `ip_address`.
  fprintf(stderr, "Connection attempted by '%s'\n", user_name, ip_address);
}
