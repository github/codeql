
#define NULL (0)

template <typename T>
inline void templateDeleter(T *&ptr)
{
	if (ptr != NULL)
	{
		delete ptr;
		ptr = NULL;
	}
}

class TemplateDeleteTest
{
public:
	TemplateDeleteTest()
	{
		ptr1 = new int; // GOOD
		ptr2 = new short; // GOOD
	}
	
	~TemplateDeleteTest()
	{
		templateDeleter<int>(ptr1);
		templateDeleter(ptr2);
	}

private:
	int *ptr1;
	short *ptr2;
};
