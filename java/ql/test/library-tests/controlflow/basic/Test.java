package dominance;

public class Test {
	public void test() {
		int x = 0;
		long y = 50;
		int z = 0;
		int w = 0;
		
		// if-else, multiple statements in block
		if (x > 0) {
			y = 20;
			z = 10;
		} else {
			y = 30;
		}
		
		z = 0;
		
		// if-else with return in one branch
		if(x < 0)
			y = 40;
		else 
			return;
		
		// this is not the start of a BB due to the return
		z = 10;
		
		// single-branch if-else
		if (x == 0) {
			y = 60;
			z = 10;
		}
		
		z = 20;
		
		// while loop
		while(x > 0) {
			y = 10;
			x--;
		}
		
		z = 30;
		
		// for loop
		for(int j = 0; j < 10; j++) {
			y = 0;
			w = 10;
		}
		
		z = 40;
		
		// nested control flow
		for(int j = 0; j < 10; j++) {
			y = 30;
			if(z > 0)
				if(y > 0) {
					w = 0;
					break;
				} else {
					w = 20;
				}
			else {
				w = 10;
				continue;
			}
			x = 0;
		}
		
		z = 50;
		
		// nested control-flow
		
		w = 40;
		return;
	}
}