
class MyRect
{
public:
	MyRect()
	{
		MyRect(100.0f, 100.0f); // BAD
	}

	MyRect(float _width, float _height) : width(_width), height(_height)
	{
	}

	MyRect(float _width)
	{
		MyRect(_width, _width); // BAD
	}

	MyRect(int a) : MyRect(10.0f, 10.0f) // GOOD
	{
		MyRect other1(20.0f, 20.0f); // GOOD
		MyRect other2 = MyRect(30.0f, 30.0f); // GOOD
	}

	MyRect(int a, int b)
	{
		*this = MyRect(40.0f, 40.0f); // GOOD
	}

private:
	float width, height;
};
