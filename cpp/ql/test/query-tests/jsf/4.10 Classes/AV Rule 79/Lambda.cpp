
class testLambda
{
public:
	testLambda()
	{
		r1 = new char[4096]; // GOOD
		deleter1 = [](char *r) {
			delete [] r;
		};

		r2 = new char[4096]; // GOOD
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

		r5 = new char[4096]; // GOOD
		deleter5 = &deleter_for_r5;

		r6 = new char[4096]; // GOOD
		deleter6 = &testLambda::deleter_for_r6;
	}

	static void deleter_for_r5(char *r)
	{
		delete [] r;
	}

	void deleter_for_r6()
	{
		delete [] r6;
	}

	~testLambda()
	{
		deleter1(r1);
		deleter5(r5);
		((*this).*deleter6)();
	}

private:
	char *r1, *r2, *r3, *r4, *r5, *r6;

	void (*deleter1)(char *r);
	void (*deleter5)(char *r);
	void (testLambda::*deleter6)();
};
