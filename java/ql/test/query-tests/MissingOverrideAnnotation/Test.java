import java.util.Arrays;
import java.util.stream.Collectors;

class Super {
	int m() {
		return 23;
	}
	
	private void n() {}
	
	public String f() {
		return "Hello";
	}
}

public class Test extends Super {
	// NOT OK
	int m() {
		return 42;
	}
	
	// OK
	public void n() {}
	
	// OK
	@Override
	public String f() {
		return "world";
	}
	
	public void test() {
		// OK
		Arrays.asList(1,2).stream().map(x -> x+1).collect(Collectors.toList());
	}
}