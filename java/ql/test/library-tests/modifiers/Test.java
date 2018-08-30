public class Test {
	enum FinalEnum { RED, GREEN, BLUE };
	enum NonFinalEnum {
		RED() { @Override public String toString() { return "red"; } },
		GREEN,
		BLUE
	};
}