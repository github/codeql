static void f(int x) {
  switch(x) {
  }
  
  switch(x) {
  default:;
  }
  
  switch(x) {
  case 0:;
  }
  
  switch(x) {
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
