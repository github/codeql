extern "C" {
  char *strdup(const char *s);
  void free (void* ptr);
}

namespace std {
  // We are not allowed to include <string> in the test file,
  // so this is an approximation of the std::string class.
  class string {
    char* str_;

  public:
    string(const char* str) : str_(strdup(str)) {}
    ~string() { free(str_); }

    const char* c_str() const noexcept { return str_; }
  };
}

const char* bad000() {
  std::string localStr("Test string");
  return localStr.c_str();
}

const char* good001(const std::string& p) {
  return p.c_str();
}

const char* bad001() {
  return std::string("Test string").c_str();
}



class jstring { char* str_; };
class _JNIEnv {
public:
  jstring NewStringUTF(const char*);
};

jstring get_hello(_JNIEnv *env) {
  std::string hello = "Hello world";
  return env->NewStringUTF(hello.c_str());
}

void good002_helper(std::string*);

const char* good002() {
  static std::string path("");
  good002_helper(&path);
  return path.c_str();
}
