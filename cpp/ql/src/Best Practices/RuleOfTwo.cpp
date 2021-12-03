class C {
private:
	Other* other = NULL;
public:
	C(const C& copyFrom) {
		Other* newOther = new Other();
		*newOther = copyFrom.other;
		this->other = newOther;
	}

	//No operator=, by default will just copy the pointer other, will not create a new object
};

class D {
	Other* other = NULL;
public:
	D& operator=(D& rhs) {
		Other* newOther = new Other();
		*newOther = rhs.other;
		this->other = newOther;
		return *this;
	}

	//No copy constructor, will just copy the pointer other and not create a new object
};

