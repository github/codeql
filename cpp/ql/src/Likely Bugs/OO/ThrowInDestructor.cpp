class C {
public:
	//...
	~C(){
		if (error) {
			throw "Exception in destructor"; //wrong: exception thrown in destructor
		}
	}
};

void f() {
	C* c = new C();
	try {
		doOperation(c);
		delete c;
	} catch ( char * do_operation_exception) {
		delete c; //would immediately terminate program if C::~C throws an exception
	}
}
