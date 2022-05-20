function* foo(){
  var index = 0;
  while(index <= 2) // when index reaches 2, yield's done will be true and its value will be undefined;
    yield index++;
}