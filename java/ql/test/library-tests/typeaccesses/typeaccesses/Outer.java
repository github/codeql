package typeaccesses;

public class Outer {
	class Inner {}
	{
		Object o = new Outer[1],
		       i = new Outer.Inner[1];
	}
}