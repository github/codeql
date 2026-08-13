int read_status();

int check_status() {
  int status;
  if ((status = read_status() < 0)) // BAD: assigns the comparison result.
    return status;

  if ((status = read_status()) < 0) // GOOD: assigns first, then compares.
    return status;

  return 0;
}
