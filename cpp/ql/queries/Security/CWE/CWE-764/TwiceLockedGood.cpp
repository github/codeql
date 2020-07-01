class C {
  std::mutex mutex;
  int f_impl(int n) {
    return (n == 0) ? 1 : n*f_impl(n-1);
  }
public:
  // GOOD: recursion is delegated to f_impl.
  int f(int n) {
    mutex.lock();
    int result = f_impl(n);
    mutex.unlock();
    return result;
  }
};
