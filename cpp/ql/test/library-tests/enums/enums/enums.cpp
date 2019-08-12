const int j = 0;

enum Day { sun, mon, tue, wed, thu, fri, sat };
enum Day2 { sun2 = j, mon2, tue2 };
enum Flag { b = 'a', c = 'b', d = 'd' };

Day& operator++(Day& d)
{
	int i = d;
	Flag f = Flag(7);
	Flag g = Flag(8);
	//const int *p = &sat;
	Day2 d2 = (Day2)d;
	return d = (sat==d) ? sun: Day(d+1);
}

void myFunction()
{
	enum myLocalEnum
	{
		myLocalEnumConstant
	};
};

class MyClass
{
  enum MyNestedEnum
  {
    MyNestedEnumConstant
  };
};
