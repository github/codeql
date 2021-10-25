
class Mutex
{
public:
	Mutex();
	~Mutex();

	void lock();
	void unlock();

private:
	// ...
};

template<class T>
class Lock
{
public:
	Lock() : m(0)
	{
	}

	Lock(T &_m) : m(&_m)
	{
		m->lock();
	}

	~Lock()
	{
		if (m)
		{
			m->unlock();
		}
	}

private:
	T *m;
};

Mutex myMutex;

void test1()
{
	Lock<Mutex> myLock(myMutex); // GOOD (creates `myLock` on `myMutex`)

	// ...
}

void test2()
{
	Lock<Mutex> myLock(); // BAD (interpreted as a function declaration, this does nothing)

	// ...
}

void test3()
{
	Lock<Mutex> myLock; // GOOD (creates an uninitialized variable called `myLock`, probably intended)

	// ...
}

void test4()
{
	Lock<Mutex>(myMutex); // BAD (creates an uninitialized variable called `myMutex`, probably not intended)

	// ...
}

void test5()
{
	Lock<Mutex> myLock(Mutex); // BAD (interpreted as a function declaration, this does nothing)

	// ...
}

class MyTestClass
{
public:
	void test6()
	{
		Lock<Mutex> myLock(memberMutex); // GOOD (creates `myLock` on `memberMutex`)

		// ...
	}

	void test7()
	{
		Lock<Mutex>(memberMutex); // BAD (creates an uninitialized variable called `memberMutex`, probably not intended) [NOT DETECTED]

		// ...
	}

private:
	Mutex memberMutex;
};
