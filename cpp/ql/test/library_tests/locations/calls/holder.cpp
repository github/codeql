template <class T>
class Holder {
	T myT;
public:
	Holder() {}
	Holder(const Holder<T> &other) {
		myT = other.myT;
	}
};

template <class T>
Holder<T> operator+(Holder<T> h1, Holder<T> h2) {
	return Holder<T>();
}

void test() {
	Holder<int> h1;
	Holder<int> h2 = Holder<int>();
	h1 + h2;
}
