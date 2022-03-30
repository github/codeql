
template<class T>
void Increment(T &t) {
	t++; // GOOD (sometimes has an effect)
}

class Nothing {
public:
	Nothing operator++(int) {
		return *this; // do nothing
	}
};

void myTemplateTest() {
	int i = 0;
	Nothing n;

	i++; // GOOD (always has an effect)
	n++; // BAD (never has an effect)
	Increment(i);
	Increment(n);
}
