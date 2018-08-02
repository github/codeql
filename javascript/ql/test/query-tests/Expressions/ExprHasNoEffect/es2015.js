function* foo(){
  var index = 0;
  while(index <= 2)
    // OK
    yield index++;
}
