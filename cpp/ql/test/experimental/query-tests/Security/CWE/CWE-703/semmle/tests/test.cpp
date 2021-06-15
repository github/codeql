typedef unsigned int size_t;
void clean();


class testClass1
{
public:
	~testClass1();
};


testClass1 :: ~testClass1()
{
   throw "my exception!";  // BAD
}

class testClass2
{
public:
	~testClass2();
};


testClass2 :: ~testClass2()
{
  try { throw "my exception!"; } // BAD
  catch (...) {  }
}

class testClass3
{
public:
	~testClass3();
};


testClass3 :: ~testClass3()
{
  try { throw "my exception!"; } // GOOD
  catch (...) { clean(); }
}
void TestFunc()
{
  testClass1 cl1;
  testClass2 cl2;
  testClass3 cl3;
}
