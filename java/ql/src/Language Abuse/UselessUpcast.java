public class UselessUpcast {
	private static class B {}
	private static class D extends B {}

	private static void Foo(B b) { System.out.println("Foo(B)"); }
	private static void Foo(D d) { System.out.println("Foo(D)"); }

	private static class Expr {}
	private static class AddExpr extends Expr {}
	private static class SubExpr extends Expr {}

	public static void main(String[] args) {
		D d = new D();
		B b_ = (B)d;	// violation: redundant cast, consider removing

		B b = new D();
		D d_ = (D)b;	// non-violation: required downcast

		Foo(d);
		Foo((B)d);		// non-violation: required to call Foo(B)

		// Non-violation: required to specify the type of the ternary operands.
		Expr e = d != null ? (Expr)new AddExpr() : new SubExpr();
	}
}