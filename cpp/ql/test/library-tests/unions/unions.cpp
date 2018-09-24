
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
