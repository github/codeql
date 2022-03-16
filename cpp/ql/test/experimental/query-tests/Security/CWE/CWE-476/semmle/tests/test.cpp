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

void allocData(myGlobalData * dataP) {
    for (size_t i = 0; i < dataP->sizeInt; i++)
    {
        dataP->bufMyData[i] = new myData;
	dataP->bufMyData[i]->sizeInt = 10;
	dataP->bufMyData[i]->buffer = new char[dataP->bufMyData[i]->sizeInt];
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
  myGlobalData *valData = new myGlobalData;

  try { 
  	cleanFunction();
	throwFunction(a);
	valData->sizeInt  = 10;
        valData->bufMyData =  new myData*[valData->sizeInt];
	cleanFunction();
	allocData(valData);
	cleanFunction();
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < valData->sizeInt; i++)
    {
    	delete[] valData->bufMyData[i]->buffer; // BAD
        delete valData->bufMyData[i];
    }
    delete [] valData->bufMyData;
    delete valData;
  }
}

void funcWork1() {
  int a;
  int i;
  myGlobalData *valData = new myGlobalData;
  valData->sizeInt  = 10;
  valData->bufMyData =  new myData*[valData->sizeInt];
  for (i = 0; i < valData->sizeInt; i++)
    valData->bufMyData[i] = 0;
  try { 
  	cleanFunction();
	throwFunction(a);
	cleanFunction();
	allocData(valData);
	cleanFunction();
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < valData->sizeInt; i++)
    {
	if (valData->bufMyData[i]) 
       	    delete[] valData->bufMyData[i]->buffer; // GOOD
        delete valData->bufMyData[i];
    }
    delete [] valData->bufMyData;
    delete valData;
  }
}

void funcWork2() {
  int a;
  myGlobalData *valData = new myGlobalData;
  valData->sizeInt  = 10;
  valData->bufMyData =  new myData*[valData->sizeInt];
  try { 
 	do {
		cleanFunction();
		allocData(valData);
		cleanFunction();
		throwFunction(a);

	}
	while(0);
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < valData->sizeInt; i++)
    {
    	delete[] valData->bufMyData[i]->buffer; // GOOD
        delete valData->bufMyData[i];
    }
    delete [] valData->bufMyData;
    delete valData;
  }
}
void funcWork3() {
  int a;
  myGlobalData *valData = new myGlobalData;
  valData->sizeInt  = 10;
  valData->bufMyData =  new myData*[valData->sizeInt];
  try { 
	cleanFunction();
	allocData(valData);
	cleanFunction();
	throwFunction(a);
 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < valData->sizeInt; i++)
    {
    	delete[] valData->bufMyData[i]->buffer; // GOOD
        delete valData->bufMyData[i];
    }
    delete [] valData->bufMyData;
    delete valData;
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
