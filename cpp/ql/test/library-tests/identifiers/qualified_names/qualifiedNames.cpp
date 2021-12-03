

void overloadedFunction(int);
void overloadedFunction(void *);

enum Enum { enumConstant };
enum class EnumClass { classEnumConstant };

class C {
  void privateFunction();
public:
  void publicFunction();

  enum Enum { enumConstant };
  enum class EnumClass { classEnumConstant };

  class Nested {
    friend class FriendOfNested;
    Nested();

    enum Enum { enumConstant };
  };
};

int main() {
  class LocalClass {
    int localClassField;
  };
  return 0;
}

namespace ns {
  int f();
  class C;
}

typedef struct {
  int structField;
} typedefStructName, *ptypedefStructName;

typedef C typedefC;

namespace templates {
  template<typename T>
  struct TemplateClass {
    T x;

    template<typename Ignored>
    const T &getMember(Ignored ignored) const { return x; }
  };

  template<typename T, typename Ignored>
  const T &getMember(TemplateClass<T> &tc, Ignored ignored) {
    return tc.getMember(ignored);
  }

  long use() {
    TemplateClass<unsigned long> tc = { 22 };
    return getMember(tc, typedefC());
  }
}

namespace std {
  inline namespace cpp17 {
    void functionInTwoNamespaces();
    class classInTwoNameSpaces {
    };
    inline namespace implementation {
      namespace ns {
        void functionInFourNamespaces();
      }
    }
  }
}

// This code demonstrates that `functionInFourNamespaces` is indeed visible in
// four name spaces.
using void_fptr = void(*)();
void_fptr ptrs[] = {
  std::ns::functionInFourNamespaces,
  std::cpp17::ns::functionInFourNamespaces,
  std::implementation::ns::functionInFourNamespaces,
  std::cpp17::implementation::ns::functionInFourNamespaces,
};
