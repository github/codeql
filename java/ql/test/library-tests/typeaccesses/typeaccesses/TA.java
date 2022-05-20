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
}
