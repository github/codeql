
typedef unsigned long size_t;

namespace std
{
	using ::size_t;
	struct nothrow_t {};
	extern const nothrow_t nothrow;
}

// nothrow new
void* operator new(std::size_t size, const std::nothrow_t&) throw();

// placement new
void* operator new (std::size_t size, void* ptr) throw();

// ---

class MyClassForPlacementNew
{
public:
	MyClassForPlacementNew(int _v) : v(_v) {}
	~MyClassForPlacementNew() {}

private:
	int v;
};

class MyTestForPlacementNew
{
public:
	MyTestForPlacementNew()
	{
		void *buffer_ptr = buffer;

		p1 = new MyClassForPlacementNew(1); // BAD: not released
		p2 = new (std::nothrow) MyClassForPlacementNew(2); // BAD: not released [NOT DETECTED]
		p3 = new (buffer_ptr) MyClassForPlacementNew(3); // GOOD: placement new, not an allocation
	}

	~MyTestForPlacementNew()
	{
	}

	MyClassForPlacementNew *p1, *p2, *p3;
	char buffer[sizeof(MyClassForPlacementNew)];
};
