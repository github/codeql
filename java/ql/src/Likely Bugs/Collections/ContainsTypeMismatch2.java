HashSet<Short> set = new HashSet<Short>();
short s = 1;
set.add(s);
// Following statement prints 'false', because the argument is a literal int, which is auto-boxed
// to an Integer
System.out.println(set.contains(1));
// Following statement prints 'true', because the argument is a literal int that is cast to a short, 
// which is auto-boxed to a Short
System.out.println(set.contains((short)1));
