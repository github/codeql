
class a
{
};

typedef a &a_ref;
typedef a *a_ptr;
typedef a a_array[10];

template<class T>
class container
{
public:
	T t;
};

class strange : public container<container<a> >
{
public:
};
