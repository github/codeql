class myClass {
	int getAnInt() {
		return 0;
	}
	const int getAConstInt() { // $ Alert
		return 0;
	}
	int getAnIntConst() const {
		return 0;
	}
	const int getAConstIntConst() const { // $ Alert
		return 0;
	}

	static int getAStaticInt() {
		return 0;
	}

	static const int getAStaticConstInt() { // $ Alert
		return 0;
	}
};
