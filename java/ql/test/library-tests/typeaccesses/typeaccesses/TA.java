package typeaccesses;

import java.util.ArrayList;

public class TA extends ArrayList<TA> {
	public ArrayList<TA> field;
	public ArrayList<TA> method1() { return null; }
	public void method2(ArrayList<TA> param) { }
	public static void method3() { ArrayList<TA> local; }
	public <T extends ArrayList<TA>> void method4() { }
	public void method5() { ((ArrayList<TA>) null).toString(); }
	public void method6() { new ArrayList<TA>(); }
	public void method7() { TA.method3(); }
	class Inner<T extends ArrayList<TA>> { }
	public TA.Inner<?> method8() { return null; }
	public java.util.List<TA> method9() { return null; }
	
	public void method10(ArrayList<? extends Number> l) { }
	public void method11(ArrayList<? extends Number[]> l) { }
	public void method12(ArrayList<? super Number[]> l) { }

	public interface I1 { }
	public interface I2 { }
	class Inner2<T extends I1 & I2> { }
	class Inner3<T extends I2 & I1> { }
	class Inner4<T extends Object & I2 & I1> { }
	public <T extends I1 & I2> void method13() { }
	public <T extends I2 & I1> void method14() { }
	public <T extends Object & I2 & I1> void method15() { }

	public <T extends Number & Runnable, R extends T, S extends ArrayList<? super R[]>> ArrayList<? super ArrayList<? extends ArrayList<T>[]>> method16() { }
}
