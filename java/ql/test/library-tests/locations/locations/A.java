package locations;

@interface TestAnnotation {
	public int foo();
}

@TestAnnotation(foo=-42)
public class A {
	{ int x = -23; }
	{ System.out.println("Hello, " + "world!"); }
	{ System.out.println("Hello" + ", " + "world!"); }
	{ String s = null; }
}
