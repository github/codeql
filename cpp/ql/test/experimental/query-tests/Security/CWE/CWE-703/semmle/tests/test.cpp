namespace std
{
	class exception {
	};

	class runtime_error : public exception {
	public:
		runtime_error(const char *msg);
	};
}

typedef unsigned int size_t;
void clean();


void funcTest1()
{
   throw ("my exception!",546);  // BAD
}

void DllMain()
{
  try { throw "my exception!"; } // BAD
  catch (...) {  }
}

void funcTest2()
{
  try { throw "my exception!"; } // GOOD
  catch (...) { clean(); }
}

void funcTest3()
{
  std::runtime_error("msg error"); // BAD
  throw std::runtime_error("msg error"); // GOOD
}

void TestFunc()
{
  funcTest1();
  DllMain();
  funcTest2();
}
