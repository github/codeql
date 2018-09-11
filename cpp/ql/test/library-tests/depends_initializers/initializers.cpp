//references(UserType)
class A {
public:
	A() {}
};

int f() {
	void *a_ptr = new A(); //match (1 call)
	A a = A(); // match (1 call)
	return 1;
}

//calls(Function)
int g() {return 0;}
extern int h();

int x = g(); //match
int y = x + g(); //match (1 call, 1 access)
int z = x + g() + h(); //match(2 calls, 1 access)

//accesses(Variable)
int i = 1;
int j = i; //match (1 access)

A a; //match(1 call)
A ax = A(); //match (1 call)
A aax = ax; //match (1 access)

//array initialization
int myIntArray[5] = {i, 0, 0, 0, 0}; //match(1 access)
A myObjectArray[3]; //match(1 call)
