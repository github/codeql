class B {
	B& operator=(const B& other) {
		... //incorrect, does not return a reference to this
	}
};

class C {
	C& operator=(const C& other) {
		...
		return *this; //correct, returns reference to this
	}
};
