HashSet<Short> set = new HashSet<Short>();
short s = 1;
set.add(s);
// Following statement fails, because the argument is a literal int, which is auto-boxed 
// to an Integer
set.remove(1);
System.out.println(set); // Prints [1]
// Following statement succeeds, because the argument is a literal int that is cast to a short, 
// which is auto-boxed to a Short
set.remove((short)1);
System.out.println(set); // Prints []