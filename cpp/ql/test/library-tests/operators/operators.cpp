class Name {
  const char* s;
};

class Table {
  Name* p;
  int sz;
public:
  // See JIRA 521. Including a non-default copy constructor for now. 
  Table(const Table& other) { } 
   Table(int s=15) { p = new Name[sz=s]; } // constructor
  ~Table() { delete[] p; }
  Name* lookup (const char*);
  bool insert(Name*);
};

void foo() {
  Table t1;  // call to user-defined constructor
  Table t2(t1); // call to default copy constructor
  t2.insert(0);
}

// This used to have TRAP import errors
struct A { A() {} A(A&) {} } a;
A operator+(int, A) { return a; }
int f_A() { 0 + a; }

