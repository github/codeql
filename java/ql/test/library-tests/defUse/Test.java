package defUse;

public class Test {
	public void ifs(long w) {
		int x = 0;
		long y = 50;
		
		use(y);
		use(w);
		
		if (x > 0) {
			y = 20;
			use(y);
		} else {
			y = 30;
			w = 10;
			use(w);
		}
		
		use(y);
		use(w);
		
		if(x < 0) {
			y = 40;
			w = 20;
		}
		else 
			return;
		
		use(y);
		use(w);
		
		if (x == 0) {
			y = 60;
		}
		
		use(y);
		
		return;
	}
	
	public static void use(long u) { return; }
}