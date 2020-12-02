namespace A {

}

namespace B {

}

namespace C {

  namespace D {

     inline int f() { return 0; }

     class E {

    	 void g(int p) {
    		 int a;
    		 {
    			 int b;
    		 }
    	 }

     };

  }

}

namespace B {

  int x = C::D::f();

}

namespace std {

}

int globalInt;

void globalIntUser(void) {
    extern int globalInt;
}
