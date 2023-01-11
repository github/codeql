int overflowdesination_main(int argc, char **argv);
int test_buffer_overrun_main(int argc, char **argv);
int tests_restrict_main(int argc, char **argv);
int tests_main(int argc, char **argv);

int main(int argc, char **argv) {
  overflowdesination_main(argc, argv);
  test_buffer_overrun_main(argc, argv);
  tests_restrict_main(argc, argv);
  tests_main(argc, argv);
  return 0;
}
