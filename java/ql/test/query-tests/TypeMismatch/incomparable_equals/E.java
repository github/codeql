package incomparable_equals;

class GraBase<T> {
	class GrBase {
		public boolean equals(Object other) { return false; }
	}
}

class GraDelegator<T,U> extends GraBase<T> {}

class Gra4To4Hist<T> extends GraDelegator<T, T> {
	class Gr4To4Hist extends GraBase<T>.GrBase {}
}

public class E<P> {
	Gra4To4Hist<P>.Gr4To4Hist getGr4Main() { return null; }
	
	public boolean equals(Object other) {
		E<?> that = (E<?>)other;
		return getGr4Main().equals(that.getGr4Main());
	}
}
