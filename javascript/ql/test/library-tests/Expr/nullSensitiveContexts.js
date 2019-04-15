///////////////////
//               //
//  SHOULD FIND  //
//               //
///////////////////

foo[bar];
foo.bar;
new Foo;
new Foo();
foo.bar = 5;
foo(bar);
x + y;
x - y;
x * y;
x / y;
x % y;
+x;
-x;
++x;
x++;
--x;
x--;
x += y;
x -= y;
x *= y;
x /= y;
x %= y;
[x , y] = p;
//[1,2,...xs]
x & y;
x | y;
x ^ y;
x << y;
x >> y;
x >>> y;
~x;
x &= y;
x |= y;
x ^= y;
x <<= y;
x >>= y;
x >>>= y;
for (let x of y) { }



///////////////////////
//                   //
//  SHOULD NOT FIND  //
//                   //
///////////////////////

x && y;
x || y;
!x;
if (x) { }
while (x) { }
for (; y; z) { }
for (let x in y) { }
