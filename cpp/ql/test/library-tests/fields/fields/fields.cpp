enum Type { S, I };

struct Entry {
  char* name;
  Type t;
  char* s;
  int i;
private:
  int internal;
};

class Name {
  const char* s;
};

class Table {
  Name* p;
  int sz;
public:
  Table(int s=15) { p = new Name[sz=s]; } // constructor
  ~Table() { delete[] p; }
  Name* lookup (const char*);
  bool insert(Name*);
};

class Date {
  static Table memtbl;
  mutable bool cache_valid;
public:
  mutable char* cache;
  void compute_cache_value() const;
};

