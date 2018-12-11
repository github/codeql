
class testLambda
{
public:
	testLambda()
	{
		r1 = new char[4096]; // GOOD [FALSE POSITIVE]
		deleter1 = [](char *r) {
			delete [] r;
		};

		r2 = new char[4096]; // GOOD [FALSE POSITIVE]
		auto deleter2 = [this]() {
			delete [] r2;
		};
		deleter2();

		r3 = new char[4096]; // GOOD
		auto deleter3 = [&r = r3]() {
			delete [] r;
		};
		deleter3(); 

		r4 = new char[4096]; // BAD
	}

	~testLambda()
	{
		deleter1(r1);
	}

private:
	char *r1, *r2, *r3, *r4;

	void (*deleter1)(char *r); 
};
