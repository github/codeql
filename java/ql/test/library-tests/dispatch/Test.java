package security.library.dataflowdynamicdispatch;

class Test {
	public static void main(String[] args) {
		Tests test = new Tests();
		test.run();
	}

	private static class Tests extends ImplAlpha {
		public void run() {
			// Expect call to ImplAlpha.m().
			Interface int_alpha = new ImplAlpha();
			int_alpha.m(System.getenv("test"));

			// Expect call to ImplBeta.m().
			Interface int_beta = new ImplBeta();
			int_beta.m(System.getenv("test"));

			// Expect call to ImplAlpha.m().
			ImplAlpha alpha_alpha = new ImplAlpha();
			alpha_alpha.m(System.getenv("test"));

			// Expect no detected calls as correct implementation cannot be determined.
			Interface int_both = new ImplAlpha();
			if (getBool()) { int_both = new ImplBeta(); }
			int_both.m(System.getenv("test"));

			// Expect call to ImplBeta.m().
			Interface int_beta_inheriter = new Inheriter();
			int_beta_inheriter.m(System.getenv("test"));

			// Expect call to unqualifiedM().
			unqualifiedM(System.getenv("test"));

			// Expect call to SecondLevelImpl.m().
			Interface int_secondlevelimpl = new SecondLevelImpl();
			int_secondlevelimpl.m(System.getenv("test"));

			// Expect call to OnlyStaticClass.m().
			OnlyStaticClass.m(System.getenv("test"));

			// Expect call to ImplAlpha.m
			alphaFactory().m(System.getenv("test"));

			// Expect no detected calls as correct implementation cannot be determined (could be ImplAlpha or SecondLevelImpl).
			alphaFactory2().m(System.getenv("test"));

			// Expect call to ImplBeta.m().
			betaFactory().m(System.getenv("test"));

			// Expect call to ImplAlpha.m
			interfaceFactory().m(System.getenv("test"));

			// Expect no detected calls as correct implementation cannot be determined.
			interfaceFactory2().m(System.getenv("test"));

			// Expect call to ImplAlpha.m
			super.m(System.getenv("test"));

			// Expect call to ImplBeta.m().
			inheriterFactory().m(System.getenv("test"));
		}

		public void m(String param) {System.out.print(param);}
	}

	private static interface Interface {
		public void m(String param);
	}

	private static class ImplAlpha implements Interface {
		public void m(String param) {System.out.print(param);}
	}

	private static class ImplBeta implements Interface {
		public void m(String param) {System.out.print(param);}
	}

	private static class Inheriter extends ImplBeta {}

	private static class SecondLevelImpl extends ImplAlpha {
		public void m(String param) {System.out.print(param);}
	}

	private static void unqualifiedM(String param) {
		System.out.print(param);
	}

	private static class OnlyStaticClass {
		public static void m(String param) {System.out.print(param);}
	}

	private static ImplAlpha alphaFactory() {
		return new ImplAlpha();
	}

	private static ImplAlpha alphaFactory2() {
		return getBool() ? new ImplAlpha() : new SecondLevelImpl();
	}

	private static ImplBeta betaFactory() {
		return new ImplBeta();
	}

	private static Interface interfaceFactory() {
		return new ImplAlpha();
	}

	private static Interface interfaceFactory2() {
		return getBool() ? new ImplAlpha() : new SecondLevelImpl();
	}

	private static Inheriter inheriterFactory() {
		return new Inheriter();
	}

	private static boolean getBool() {
		return System.getenv("test").equals("A");
	}
}
