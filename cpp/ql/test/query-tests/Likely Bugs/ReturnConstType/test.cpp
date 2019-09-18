
// --- examples from the qhelp ---

// The leftmost const has no effect here.
const int square(const int x) { // BAD
  return x * x;
}

// The const has no effect here, and can easily be mistaken for const char*.
char* const id(char* s) { // BAD
  return s;
}

// --- more examples ---

const char *getAConstantString();
const char **getAConstantStringPointer();
const char getAConstChar(); // BAD
const signed char getASignedConstChar(); // BAD
unsigned const char getAnUnsignedConstChar(); // BAD
char getAChar();

typedef const char mychar;

mychar getAMyChar();

template<typename T> T id (T arg) {
		return arg;
}

void templateFunctionTest () {
	id <const char> ('a');
}

template<typename T> class myWrapper {
	public:
		T t;
		T getT() {
			return t;
		};
};

myWrapper<const char> testTemplateClass{t: 'a'};

#define MYCHAR const char
MYCHAR getAMYCHAR(); // FALSE POSITIVE

#define ID(T) T id_ (T x) {return x;}
ID(const char); // FALSE POSITIVE

const float pi = 3.14159626f;
const float &getPiRef() { return pi; } // GOOD
