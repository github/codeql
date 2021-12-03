class C;

typedef C Ctop;
typedef Ctop&& Ctop_rref1;
typedef Ctop_rref1 Ctop_rref;

// These templates provide the syntax needed to denote references to
// references. There are no actual references to references in C++, but C++11
// will perform "reference collapsing", where attempts to declare rvalue refs to
// rvalue refs collapse to rvalue refs while all other combinations collapse to
// lvalue refs.
template<class T> using lref = T&;
template<class T> using rref = T&&;

struct C {
  typedef C Cinside1;
  typedef Cinside1 Cinside;
  typedef Cinside& Cinside_lref1;
  typedef Cinside_lref1 Cinside_lref;

  // Constructors
  C();
  // C(C c); // doesn't compile
  C(C* c);
  C(const C* c);
  C(C c, int i); // My compiler requires the int parameter
  C(const C& c1, const C& c2); // has extra parameter
  C(int i, const C& c); // has leading parameter
  template<class T> C(const C& c_templated);
  template<class T> C(C&& c_templated, double *p = nullptr);

  // Copy constructors
  C(C& c, ...); // This is apparently a copy constructor
  C(const Ctop& c, int i = 0, int j = 2);
  C(volatile C& c);
  C(const volatile Cinside_lref c, double x = 0.0);
  C(const rref<lref<C>> c, int* p = nullptr);
  C(const lref<rref<C>> c, int** p = nullptr);

  // Move constructors
  C(C&& c, int i = 0);
  C(Ctop_rref c);
  C(const volatile C&& c);
  C(volatile Cinside&& c);
  C(const rref<rref<rref<C>>> c, int* p = nullptr);

  // Copy assignment
  C& operator=(Cinside_lref c);
  C& operator=(Cinside nonref);
  C& operator=(const volatile C& c);
  C& operator=(rref<lref<rref<const C>>> c_copy);

  // Move assignment
  C& operator=(Ctop_rref c);
  C& operator=(const volatile C&& c);
  C& operator=(rref<rref<rref<const C>>> c_move);

  // Non-assignment member functions
  C& operator=(int i);
  template<class T> C& operator=(volatile C& c_templated);
  template<class T> C& operator=(volatile C&& c_templated);
  bool operator==(const C& c);
};
