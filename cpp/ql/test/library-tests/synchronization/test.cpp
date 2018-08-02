
class Mutex1
{
public:
	void lock();
	void unlock();
};

void test1()
{
	Mutex1 mt1;
	Mutex1 *mt1_p = &mt1;

	mt1.lock();
	mt1.unlock();

	mt1_p->lock();
	mt1_p->unlock();
}

class Mutex2
{
public:
	void lock(); // (this is not recognized as a MutexType.getLockFunction() because it is not used)
	bool try_lock();
	void unlock();
};

void test2(Mutex2 &mt2)
{
	if (mt2.try_lock())
	{
		mt2.unlock();
	}
}

class Mutex3 : public Mutex2
{
};

void test3(Mutex3 *mt3)
{
	if (mt3->try_lock()) // (these are partially recognized as a use of Mutex2)
	{
		mt3->unlock();
	}
}

class Mutex4
{
public:
	int state;
};

void mutex4_mutex_lock(Mutex4 &mutex);
void mutex4_mutex_unlock(Mutex4 &mutex);
void mutex4_mutex_lock(Mutex4 &mutex, int times);
void mutex4_mutex_unlock(Mutex4 &mutex, int times);

Mutex4 mt4;

void test4()
{
	mutex4_mutex_lock(mt4);
	mutex4_mutex_unlock(mt4);

	mutex4_mutex_lock(mt4, 1);
	mutex4_mutex_unlock(mt4, 1);
}

typedef volatile unsigned int Mutex5; // NOT RECONGIZED (not a Class)

void lock(Mutex5 &mutex);
void unlock(Mutex5 &mutex);

void test5(Mutex5 *mt5)
{
	lock(*mt5);
	unlock(*mt5);
}

class NotAMutex6
{
public:
	void lock();
	bool try_lock();
};

void test6()
{
	NotAMutex6 mt6;

	mt6.lock();
	mt6.try_lock();
}

class Mutex7
{
public:
	void custom_l();
	void custom_ul();
};

void test7()
{
	Mutex7 mt7;

	mt7.custom_l();
	mt7.custom_ul();
}

class Mutex8
{
public:
	void lock();
	void unlock();

	void myMethod() {
		this->lock();
		this->unlock();
		
		lock();
		unlock();
	};
};

class Mutex9 : public Mutex8
{
public:
	void myMethod2() {
		Mutex8 *this8 = this;
	
		this->lock(); // (partially recognized as a use of Mutex8)
		this->unlock(); // (partially recognized as a use of Mutex8)
	
		this8->lock();
		this8->unlock();
	}
};
