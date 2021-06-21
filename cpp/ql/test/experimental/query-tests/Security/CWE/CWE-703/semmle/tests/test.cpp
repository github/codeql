typedef unsigned int size_t;
void clean();


class testClass1
{
public:
	void testMethod();
};


void testClass1 :: testMethod()
{
   throw "my exception!";  // BAD
}

class testClass2
{
public:
	void testMethod();
};


void testClass2 :: testMethod()
{
  try { throw "my exception!"; } // BAD
  catch (...) {  }
}

class testClass3
{
public:
	void testMethod();
};


void testClass3 :: testMethod()
{
  try { throw "my exception!"; } // GOOD
  catch (...) { clean(); }
}
void TestFunc()
{
  testClass1 cl1;
	cl1.testMethod();
  testClass2 cl2;
	cl2.testMethod();
  testClass3 cl3;
	cl3.testMethod();
}
