
namespace std {
  template<class charT> struct char_traits;

  template <class T> class allocator {
  public:
    allocator() throw();
  };

  template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
  class basic_string {
  public:
    explicit basic_string(const Allocator& a = Allocator());
    basic_string(const charT* s, const Allocator& a = Allocator());

    const charT* c_str() const;
  };

  typedef basic_string<char> string;
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
