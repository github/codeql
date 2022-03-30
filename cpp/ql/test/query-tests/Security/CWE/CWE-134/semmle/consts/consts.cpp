// Semmle test case for rule NonConstantFormat.ql (non-constant format string).
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// Constant strings are compliant with CWE-134 and non-constant strings may be non-compliant with CWE-134.
 
int printf(const char *format, ...);
int sprintf(char *s, const char *format, ...);
char *gets(char *s);
void readString(char **line); 
void readStringRef(char *&line);
char *varFunc(); 
char *constFunc() {
 return "asd";
}
 
char *gc1[] = {
 "a",
 "b"
};
 
char *constFuncToArray(int i) {
 return gc1[i];
}
 
char *gv1[] = {
 "a",
 "b"
};
 
char *nonConstFuncToArray(int i) {
 return gv1[i];
}
 
void a() {
 // GOOD: format is always constant
 printf("-");
 
 // GOOD: c1 value is always constant
 const char *c1 = "a";
 printf(c1);
  
 // GOOD: c2 value is always constant
 const char *c2;
 c2 = "b";
 printf(c2);
  
 // GOOD: c3 value is copied from c1 which is always constant
 //
 const char *c3 = c1;
 printf(c3);
  
 // GOOD: c4 value is copied from c1 which is always constant
 //
 const char *c4;
 c4 = c1;
 printf(c4);
  
 // GOOD: constFunc() always returns a constant string
 printf(constFunc());
  
 // GOOD: constFunc() always returns a constant string
 // But we still don't track constantness flow from functions to variables
 char *c5 = constFunc();
 printf(c5);
  
 // GOOD: constFunc() always returns a constant string
 // But we still don't track constantness flow from functions to variables
 char *c6;
 c6 = constFunc();
 printf(c6);
  
 // GOOD: all elements of c7 are always constant
 char *c7[] = { "a", "b" };
 printf(c7[0]);
  
 // GOOD: constFuncToArray() always returns a value from gc1, which is always constant
 printf(constFuncToArray(0));
  
 // BAD: format string is not constant
 char c8[10];
 sprintf(c8, "%d", 1);
 printf(c8);
  
 // BAD: v1 value came from the user
 char v1[100];
 gets(v1);
 printf(v1);
 
 // BAD: v2 value came from the user
 char *v2;
 v2 = gets(v1);
 printf(v2);
  
 // BAD: v3 value is copied from v1, which came from the user
 char *v3 = v1;
 printf(v3);
  
 // BAD: v4 value is copied from v1, which came from the user
 char *v4;
 v4 = v1;
 printf(v4);
  
 // BAD: varFunc() is not defined, so it may not be constant
 printf(varFunc());
  
 // BAD: varFunc() is not defined, so it may not be constant
 char *v5 = varFunc();
 printf(v5);
 
 // BAD: varFunc() is not defined, so it may not be constant
 char *v6;
 v6 = varFunc();
 printf(v6);
 
 // BAD: all elements of v7 came from the user
 char *v7[] = { v1, v2 };
 printf(v7[0]);
  
 // BAD: v8 started as constant, but changed to a value that came from the user
 char *v8 = "a";
 v8 = v7[1];
 printf(v8);
  
 gv1[1] = v1;
  
 // BAD: nonConstFuncToArray() always returns a value from gv1, which is started as constant but was changed to a value that came from the user
 printf(nonConstFuncToArray(0));
  
 // BAD: v9 value is copied from v1, which came from the user
 const char *v9 = v1;
 printf(v9);
  
 // BAD: v10 value is derived from values that are not constant
 char v10[10];
 sprintf(v10, "%s", v1);
 printf(v10);
 
 // BAD: v11 is initialized via a pointer
 char *v11;
 readString(&v11);
 printf(v11);

 // BAD: v12 is initialized via a reference
 char *v12;
 readStringRef(v12);
 printf(v12);
}
