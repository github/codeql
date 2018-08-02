
#define NULL (0)

class MyWidget
{
public:
	MyWidget() : next(NULL) {};

private:
	MyWidget *next;

	friend class MyCollection;
};

class MyCollection
{
public:
	MyCollection() : first(NULL) {};

	~MyCollection() {
		MyWidget *to_delete;

		// delete all added widgets
		while (first != NULL) {
			to_delete = first;
			first = first->next;
			delete to_delete;
		}
	}

	void add(MyWidget *obj)
	{
		// add a widget
		obj->next = first;
		first = obj;
	}

private:
	MyWidget *first;
};

MyWidget *globalWidget = NULL;

class MyScreen
{
public:
	MyScreen()
	{
		a = new MyWidget(); // BAD (not deleted)

		b = new MyWidget(); // GOOD (deleted in widgets destructor)
		widgets.add(b);

		c = new MyWidget(); // GOOD (deleted in externalOwnersMain)
		globalWidget = c;

		widgets.add(d = new MyWidget()); // GOOD (deleted in widgets destructor)
	};

private:
	MyWidget *a, *b, *c, *d;
	MyCollection widgets;
};

void externalOwnersMain()
{
	// do stuff
	{
		MyScreen myScreen;
		
		// ...
	}

	// clean up (delete globalWidget)
	if (globalWidget != NULL)
	{
		delete globalWidget;
		globalWidget = NULL;
	}
}
