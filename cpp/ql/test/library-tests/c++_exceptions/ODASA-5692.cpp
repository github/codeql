class Error {
public:
  Error () {}
  virtual ~Error() {}
};

template <typename T>
int fun2() {
  try {
  }
  catch (Error&) {
    throw;
  }
  catch (...) {
    return 1;
  }
  return 0;
}

void run_fun2(void) {
    fun2<int>();
}

