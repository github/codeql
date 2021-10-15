package localvars;

import java.util.List;

public class LocalVarTest {
	public int test1() {
        int x = 23 , y = 19;
        int z = 56 ;
        List<String> l1, l2 = null;
        switch(x) {
        case 23:
            Object o = null, p[];
        }
        return x+y;
	}
	
	public void test2(List<String> l) {
        for(int i=0;i<10;i++);
        for(int j=10,k=0;j>k;--j,++k);
        for(String s : l);
        try {
        } catch(RuntimeException e) {}
	}
}