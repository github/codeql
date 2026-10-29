
class myClass
{
public:
	int x, y;
};

template<class T>
int myFunction()
{
	return __is_pod(T);
}

int main()
{
	return __is_pod(int) + __has_trivial_destructor(myClass) + myFunction<short>();
}
