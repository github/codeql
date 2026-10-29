
public class ConstructedOverrides {
	{
		new Sub().used("");
		new Super<String>().used("");
		new Super<String>().usedGeneric(1, "");
	}
	public <S> S indirectUse(S t) { return new Super<S>().usedGeneric(null, t); }
}
class Super<T> {
	public T used(T t) { return t; }
	public T unused(T t) { return t; }
	public <U> U usedGeneric(U u, T t) { return u; }
	public <U> U unusedGeneric(U u, T t) { return u; }
}

class Sub extends Super<String> {
	@Override public String used(String s) { return s; }
	@Override public String unused(String s) { return s; }
	@Override public <U> U usedGeneric(U u, String t) { return u; }
}

class Sub2 extends Sub {
	@Override public <V> V usedGeneric(V u, String t) { return u; }
	@Override public <V> V unusedGeneric(V u, String t) { return u; }
}
