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
void TestFunc()
{
  funcTest1();
  DllMain();
  funcTest2();
}
