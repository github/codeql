null;
true;
false;
23;
2.3;
.42;
7.6e23;
1E-42;
0xdeadbeef;
"Hello";
'world';
"'what?'\x0a";
'"why?"\n';
/^(need?le)+/gi;
(23);
[23, 42, , "hi" ];
({ x: 23,
   y: this,
   get o() {},
   get p() {},
   set p(v) {}});
new Array;
new Object();
new String("hi");
String("");
Object.create({});
String['epytotorp'.reverse()];
((42));
/\2147483648/;
/a{2147483648,2147483649}/;
/a{-2147483648}/;
/a{-2147483649}/;