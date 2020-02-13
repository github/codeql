
enum Type { S, I };

struct Entry {

  char* name;
  Type t;
  char* s;
  int i;

};

union Value {
  char* s;
  int i;
};


struct EntryWithMethod: Entry {
  int getAsInt() {
	  return i;
  }
};

void myFunction()
{
  union MyLocalUnion {
    int i;
    float f;
  };
}

class MyClass
{
public:
  union MyNestedUnion {
    int i;
    float f;
  };
};

void test_anonymous_union() {
  union {
    int u1;
    char* u2;
  };

  union {
    int u3;
    char* u4;
  } local_union;
}