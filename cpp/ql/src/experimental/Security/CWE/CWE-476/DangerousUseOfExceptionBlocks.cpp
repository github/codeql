...
try {
  if (checkValue) throw exception();
  valData->bufMyData =  new myData*[valData->sizeInt];
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < valData->sizeInt; i++)
    {
    	delete[] valData->bufMyData[i]->buffer; // BAD
        delete valData->bufMyData[i];
    }
...
try {
  if (checkValue) throw exception();
  valData->bufMyData =  new myData*[valData->sizeInt];
	 
  } 
  catch (...) 
  {
    for (size_t i = 0; i < valData->sizeInt; i++)
    {
      if(valData->bufMyData[i])
      {
    	  delete[] valData->bufMyData[i]->buffer; // GOOD
        delete valData->bufMyData[i];
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
