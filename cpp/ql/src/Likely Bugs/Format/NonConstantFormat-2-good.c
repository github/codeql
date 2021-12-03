void log_with_timestamp(const char* message, ...) {
  va_list args;
  va_start(args, message);
  struct tm now;
  time(&now);
  printf("[%s] ", asctime(now));
  vprintf(message, args);
  va_end(args);
}

int main(int argc, char** argv) {
  log_with_timestamp("%s is starting...\n", argv[0]);
  /* ... */
  log_with_timestamp("%s is closing...\n", argv[0]);
  return 0;
}