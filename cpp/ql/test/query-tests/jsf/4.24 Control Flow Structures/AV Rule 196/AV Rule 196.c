static void f(int x) {
  switch(x) { // $ Alert
  }
  
  switch(x) { // $ Alert
  default:;
  }
  
  switch(x) { // $ Alert
  case 0:;
  }
  
  switch(x) { // $ Alert
  default:
  case 0:;
  }
  
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
