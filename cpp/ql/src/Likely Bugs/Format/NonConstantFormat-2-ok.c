void log_with_timestamp(const char* message) {
  struct tm now;
  time(&now);
  printf("[%s] %s", asctime(now), message);
}

int main(int argc, char** argv) {
  log_with_timestamp("Application is starting...\n");
  /* ... */
  log_with_timestamp("Application is closing...\n");
  return 0;
}