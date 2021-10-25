
#define NULL (0)

typedef unsigned int size_t;

void *malloc(size_t size);
void free(void *ptr);

class MyThing
{
public:
	MyThing() : next(NULL) {};

	struct MyThing *next;
};

class MyThingColection
{
public:
	MyThingColection() {
		first = new MyThing; // GOOD (all deleted in destructor) [FALSE POSITIVE]

		first->next = new MyThing; // GOOD (all deleted in destructor)

		x = new MyThing; // GOOD (all deleted in destructor)
		add(x);

		add(y = new MyThing); // GOOD (all deleted in destructor)
	}
	
	~MyThingColection() {
		MyThing *to_delete;

		// delete all added things
		while (first != NULL) {
			to_delete = first;
			first = first->next;
			delete to_delete;
		}
	}

	void add(MyThing *t)
	{
		// add a thing
		t->next = first;
		first = t;
	}

private:
	MyThing *first, *x, *y;
};
