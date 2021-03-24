if(len<0) return 1;
memset(dest, source, len); // GOOD: variable `len` checked before call

...

memset(dest, source, len); // BAD: variable `len` checked after call
if(len<0) return 1;
