function A() {}
A(); // OK

function MyString() {}
String = MyString;
new String(); // OK