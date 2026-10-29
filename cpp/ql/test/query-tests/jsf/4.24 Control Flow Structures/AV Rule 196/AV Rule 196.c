static void f(int x) {
  switch(x) {
  } // $ Alert
  
  switch(x) {
  default:;
  } // $ Alert
  
  switch(x) {
  case 0:;
  } // $ Alert
  
  switch(x) {
  default:
  case 0:;
  } // $ Alert
  
  switch(x) {
  case 0:;
  case 1:;
  }
  
  switch(x) {
  default:;
  case 0:;
  case 1:;
  }
}
