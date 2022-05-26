...
try {
  if (checkValue) throw exception();
  bufMyData =  new myData*[sizeInt];
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < sizeInt; i++)
    {
    	delete[] bufMyData[i]->buffer; // BAD
        delete bufMyData[i];
    }
...
try {
  if (checkValue) throw exception();
  bufMyData =  new myData*[sizeInt];
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < sizeInt; i++)
    {
      if(bufMyData[i])
      {
    	delete[] bufMyData[i]->buffer; // GOOD
        delete bufMyData[i];
      }
    }

...
  catch (const exception &) {
	  delete valData;
	  throw;
  }
  catch (...) 
  {
    delete valData; // BAD
...
  catch (const exception &) {
	  delete valData;
    valData = NULL;
	  throw;
  }
  catch (...) 
  {
    delete valData; // GOOD  
...
