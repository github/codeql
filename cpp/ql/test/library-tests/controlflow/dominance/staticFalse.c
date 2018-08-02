extern int puts(const char *message);
extern int runTimeDecision();

void staticFalse() {
    puts("Hello");
    if (0) {
      puts("Unreachable code");
    } else {
      puts("Reachable code");
    }
    if (runTimeDecision()) {
      puts("Branch A");
    } else {
      puts("Branch B");
    }
    puts("All done");
}
