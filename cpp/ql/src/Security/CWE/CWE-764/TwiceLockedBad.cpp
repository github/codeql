class C {
  std::mutex mutex;
public:
  // BAD: recursion causes deadlock.
  int f(int n) {
    mutex.lock();
    int result = (n == 0) ? 1 : n*f(n-1);
    mutex.unlock();
    return result;
  }
};
