
#define NULL (0)

class MyElement
{
public:
	MyElement() {};
	MyElement(class MyOwner *owner) {
		bind(owner);
	}

	void bind(MyOwner *owner); // register with owner
	void donothing(int x) {};
};

class MyOwner
{
public:
	MyOwner() : numRegisteredElements(0) {
		top = new MyElement(this); // GOOD

		bottom = new MyElement(); // GOOD
		bottom->bind(this);

		side = new MyElement(); // BAD (never released)
		side->donothing(123);
	}

	~MyOwner() {
		// delete all registered elements
		for (int i = 0; i < numRegisteredElements; i++)
		{
			delete registeredElements[i];
		}
	}

	void registerElement(MyElement *obj)
	{
		// register an element
		if (numRegisteredElements < 100)
		{
			registeredElements[numRegisteredElements++] = obj;
		} else {
			throw "too many elements";
		}
	}

private:
	// elements
	MyElement *top, *bottom, *side;

	// registered elements
	MyElement *registeredElements[100];
	int numRegisteredElements;
};

void MyElement :: bind(MyOwner *owner) {
	// register with owner
	owner->registerElement(this);
}

void selfRegisteringMain()
{
	MyOwner myOwner;

	// ...
}
