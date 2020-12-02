class A {

};


class B {

};

class C: A, B {

};

class D: C {

	class E;

};

class D::E {

	class F;

	class G {
  public:
      /* Non-trivial constructor and destructor */
       G() { 0; }
      ~G() { 0; }
	};

};

class D::E::F: D::E::G {
  /* Should have generated constructor and destructor, because of D::E::G */
  
  static int m() {
    D::E::F def; /* Should trigger creation of D::E::F's generated constructor and destructor. */
  }
};

// semmle-extractor-options: --microsoft
