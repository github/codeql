struct X {
    //This struct will have a compiler-generated copy constructor
    X(const X&, int);
    ...
};

//However, if this is declared later, it will override the compiler-generated
//constructor
X::X(const X& x, int i =0) {
    this-> i = i; //uses the i parameter, instead of x.i
}

C c(1);
C cCopy = c; //would take i to be 0, instead of just copying c(1)
