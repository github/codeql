
class MyClass2;

void DeleteMyClass2(MyClass2 *mc)
{
	delete mc;
}

class MyClass2
{
public:
	MyClass2()
	{
	}

	~MyClass2()
	{
	}

	void Release()
	{
		delete this;
	}

	void Release2()
	{
		this->Release();
	}

	void Release3()
	{
		(*this).Release();
	}
	
	void DeleteOther(MyClass2 *other)
	{
		delete other;
	}
	
	void ReleaseOther(MyClass2 *other)
	{
		other->Release();
	}
};

class MyClass3
{
public:
	MyClass3()
	{
		ptr1 = new MyClass2(); // GOOD
		ptr2 = new MyClass2(); // GOOD
		ptr3 = new MyClass2(); // GOOD
		ptr4 = new MyClass2(); // GOOD
		ptr5 = new MyClass2(); // GOOD
		ptr10 = new MyClass2(); // BAD: not deleted in destructor
		ptr11 = new MyClass2(); // GOOD
		ptr12 = new MyClass2(); // BAD: not deleted in destructor
		ptr13 = new MyClass2(); // GOOD
		ptr14 = new MyClass2(); // BAD: not deleted in destructor
		ptr15 = new MyClass2(); // GOOD
		ptr20 = new MyClass2(); // GOOD
	}
	
	~MyClass3()
	{
		delete ptr1;
		ptr2->Release();
		(*ptr3).Release();
		ptr4->Release2();
		ptr5->Release3();

		ptr10->DeleteOther(ptr11);
		ptr12->ReleaseOther(ptr13);
		(*ptr14).ReleaseOther(ptr15);

		DeleteMyClass2(ptr20);
	}

private:
	MyClass2 *ptr1, *ptr2, *ptr3, *ptr4, *ptr5;
	MyClass2 *ptr10, *ptr11, *ptr12, *ptr13, *ptr14, *ptr15;
	MyClass2 *ptr20;
};

class MyClass4
{
public:
	virtual void Release() = 0;
};

class MyClass5 : public MyClass4
{
public:
	void Release()
	{
		delete this;
	}
};

class MyClass6 : public MyClass5
{
};

class MyClass7 : public MyClass4
{
public:
	void Release()
	{
		// do nothing
	}
};

class MyClass8 : public MyClass7
{
};

class MyClass9
{
public:
	MyClass9()
	{
		a = new MyClass5(); // GOOD
		b = new MyClass5(); // GOOD
		c = new MyClass6(); // GOOD

		d = new MyClass7(); // BAD
		e = new MyClass7(); // BAD [NOT DETECTED]
		f = new MyClass8(); // BAD [NOT DETECTED]
	}
 	~MyClass9()
	{
		a->Release(); // MyClass5::Release()
		b->Release(); // MyClass5::Release()
		c->Release(); // MyClass5::Release()

		d->Release(); // MyClass7::Release()
		e->Release(); // MyClass7::Release()
		f->Release(); // MyClass7::Release() 
	}
 	MyClass5 *a;
	MyClass4 *b;
	MyClass4 *c;

	MyClass7 *d;
	MyClass4 *e;
	MyClass4 *f;
};
