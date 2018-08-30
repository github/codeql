package annotations;

public class SuppressWarningsExample {
	@Deprecated void f() {}
	
	@SuppressWarnings({"deprecation"})
	public void g() {
		f();
	}
	  
	@SuppressWarnings("deprecation")
	public void h() {
		f();
	}
	
	@SuppressWarnings({"deprecation", "rawtypes"})
	public void k(java.util.List l) {
		f();
	}
}