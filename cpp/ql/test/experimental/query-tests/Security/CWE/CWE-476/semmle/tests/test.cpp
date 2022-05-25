#define NULL ((void*)0)
typedef unsigned long size_t;
namespace std {
  enum class align_val_t : size_t {};
}

class exception {};

void cleanFunction();

void* operator new(size_t, float);
void* operator new[](size_t, float);
void* operator new(size_t, std::align_val_t, float);
void* operator new[](size_t, std::align_val_t, float);
void operator delete(void*, float);
void operator delete[](void*, float);
void operator delete(void*, std::align_val_t, float);
void operator delete[](void*, std::align_val_t, float);

struct myData
{
    int		sizeInt;
    char*	buffer;
};

struct myGlobalData
{
    int		sizeInt;
    myData**	bufMyData;
};

void allocData(myData ** bufMyData) {
    for (size_t i = 0; i < 10; i++)
    {
        bufMyData[i] = new myData;
	bufMyData[i]->sizeInt = 10;
	bufMyData[i]->buffer = new char[10];
    }
}


void throwFunction(int a) {
	if (a == 5)  throw "my exception!";
}
void throwFunction2(int a) {
	if (a == 5) throw exception();
}
void funcWork1b() {
  int a;
  myData **bufMyData;

  try { 
  	cleanFunction();
	throwFunction(a);

        bufMyData =  new myData*[10];
	cleanFunction();
	allocData(bufMyData);
	cleanFunction();
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < 10; i++)
    {
    	delete[] bufMyData[i]->buffer; // BAD
        delete bufMyData[i];
    }
    delete [] bufMyData;

  }
}

void funcWork1() {
  int a;
  int i;
  myData **bufMyData;

  bufMyData =  new myData*[10];
  for (i = 0; i < 10; i++)
    bufMyData[i] = 0;
  try { 
  	cleanFunction();
	throwFunction(a);
	cleanFunction();
	allocData(bufMyData);
	cleanFunction();
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < 10; i++)
    {
	if (bufMyData[i]) 
       	    delete[] bufMyData[i]->buffer; // BAD
        delete bufMyData[i];
    }
    delete [] bufMyData;

  }
}

void funcWork2() {
  int a;
  myData **bufMyData;

  bufMyData =  new myData*[10];
  try { 
 	do {
		cleanFunction();
		allocData(bufMyData);
		cleanFunction();
		throwFunction(a);

	}
	while(0);
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < 10; i++)
    {
    	delete[] bufMyData[i]->buffer; // BAD
        delete bufMyData[i];
    }
    delete [] bufMyData;

  }
}
void funcWork3() {
  int a;
  myData **bufMyData;

  bufMyData =  new myData*[10];
  try { 
	cleanFunction();
	allocData(bufMyData);
	cleanFunction();
	throwFunction(a);
 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < 10; i++)
    {
    	delete[] bufMyData[i]->buffer; // BAD
        delete bufMyData[i];
    }
    delete [] bufMyData;

  }
}


void funcWork4() {
  int a;
  myGlobalData *valData = 0;
  try { 
	valData = new myGlobalData;
	cleanFunction();
	delete valData;
	valData = 0;
	throwFunction(a);	 
  } 
  catch (...) 
  {
    delete valData; // GOOD
  }
}

void funcWork4b() {
  int a;
  myGlobalData *valData = 0;
  try { 
	valData = new myGlobalData;
	cleanFunction();
	delete valData;
	throwFunction(a);	 
  } 
  catch (...) 
  {
    delete valData; // BAD
  }
}
void funcWork5() {
  int a;
  myGlobalData *valData = 0;
  try { 
	valData = new myGlobalData;
	cleanFunction();
	delete valData;
	valData = 0;
	throwFunction2(a);	 
  } 
  catch (const exception &) {
	delete valData;
	valData = 0;
	throw;
  }
  catch (...) 
  {
        delete valData; // GOOD
  }
}

void funcWork5b() {
  int a;
  myGlobalData *valData = 0;
  try { 
	valData = new myGlobalData;
	cleanFunction();
	throwFunction2(a);	 
  } 
  catch (const exception &) {
	delete valData;
	throw;
  }
  catch (...) 
  {
        delete valData; // BAD
  }
}
void funcWork6() {
  int a;
  int flagB = 0;
  myGlobalData *valData = 0;
  try { 
	valData = new myGlobalData;
	cleanFunction();
	throwFunction2(a);	 
  } 
  catch (const exception &) {
	delete valData;
	flagB = 1;
	throw;
  }
  catch (...) 
  {
	if(flagB == 0)
        delete valData; // GOOD
  }
}

void runnerFunc()
{
  funcWork1();
  funcWork1b();
  funcWork2();
  funcWork3();
  funcWork4();
  funcWork4b();
  funcWork5();
  funcWork5b();
  funcWork6();
}
