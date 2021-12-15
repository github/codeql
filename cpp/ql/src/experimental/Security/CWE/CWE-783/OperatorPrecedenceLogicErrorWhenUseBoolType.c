if(len=funcReadData()==0) return 1; // BAD: variable `len` will not equal the value returned by function `funcReadData()`
...
if((len=funcReadData())==0) return 1; // GOOD: variable `len` equal the value returned by function `funcReadData()`
...
bool a=true;
a++;// BAD: variable `a` does not change its meaning
bool b;
b=-a;// BAD: variable `b` equal `true`
...
a=false;// GOOD: variable `a` equal `false`
b=!a;// GOOD: variable `b` equal `false`
