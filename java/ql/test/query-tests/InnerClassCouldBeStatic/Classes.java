
public class Classes {
	private static int staticFoo;
	protected int foo;
	
	public int bar() { return foo; }
	private static int staticBar() { return staticFoo; }
	
	/** Already static. */
	private static class Static {
		
	}
	
	/** Could be static. */
	private class MaybeStatic {
		
	}
	
	/** Only accesses enclosing instance in constructor. */
	private class MaybeStatic1 {
		public MaybeStatic1() {
			System.out.println(foo);
		}
	}
	
	/** Only accesses enclosing instance in constructor. */
	private class MaybeStatic2 {
		public MaybeStatic2() {
			System.out.println(Classes.this);
		}
		
		private int bar(Classes c) {
			return c.bar();
		}
	}

	/**
	 * Supertype could be static, and no enclosing instance accesses.
	 */
	private class MaybeStatic3 extends MaybeStatic2 {
		public void foo(int i) { staticFoo = i; }
	}
	
	private static class Static1 {
		public void foo(int i) {}
		
		/** Nested and extending classes that can be static; using enclosing
		 * state only in constructor.
		 */
		public class MaybeStatic4 extends Static {
			MaybeStatic4() {
				System.out.println(staticFoo);
			}
		}
	}
	
	/**
	 * Access to bar() is through inheritance, not enclosing state.
	 */
	private class MaybeStatic5 extends Classes {
		public void doit() {
			System.out.println(bar());
		}
	}
	
	private class MaybeStatic6 {
		private final int myFoo = staticFoo;
		MaybeStatic6() { staticBar(); }
	}
	
	/** A qualified `this` access needn't refer to the enclosing instance. */
	private class MaybeStatic7 {
		private void foo() { MaybeStatic7.this.foo(); }
	}
	
	public interface Interface {
		public int interfaceFoo = 0;
		
		/** Class is implicitly static as a member of an interface. */
		public class Static2 {
			private void bar() {
				System.out.println(interfaceFoo);
			}
			
			class MaybeStatic8 {
				private void bar() {
					System.out.println(interfaceFoo);
				}
			}
		}
	}
	
	/** Accesses implicitly static interface field. */
	public class MaybeStatic9 extends MaybeStatic7 {
		private void bar() {
			System.out.println(Interface.interfaceFoo);
		}
	}
	
	/** A qualified `super` access that doesn't refer to the enclosing scope. */
	class MaybeStatic10 extends Classes {
		private void baz() {
			System.out.println(MaybeStatic10.super.getClass());
		}
	}
	
	static class A {
	    interface B {
	        class ThisIsStatic {
	        	final int outer = 0;
	            class MaybeStaticToo {
	            	final int a = 0;
	            }
	            class MayNotBeStatic {
	                public void foo() {
	                    class ThisIsNotStatic {
	                    	int b = outer; // see?
	                        class NeitherIsThis {
	                        	int c = outer; // yeah. It also can't be.
	                        }
	                    }
	                    new ThisIsNotStatic() {
	                    	int d = outer; // either. Also can't be.
	                    };
	                }
	            }
	        }
	    }
	}
	
	enum E {
		A;
		class NotStaticButCouldBe {}
	}

	/**
	 * Uses enclosing field outside constructor.
	 */
	private class NotStatic {
		public int foo() { return foo; }
	}
	
	/** Uses enclosing method outside constructor. */
	private class NotStatic1 {
		public void foo() { bar(); }
	}
	
	/** Uses enclosing instance outside constructor. */
	private class NotStatic2 {
		public void bar() { Classes.this.bar(); }
	}
	
	private void enclosing() {
		/** A local class can't be static. */
		class NotStatic3 {
			
		}
	}
	
	/** Extends a class that can't be static. */
	private class NotStatic4 extends NotStatic2 {
		/** Nested in a class that can't be static. */
		private class NotStatic5 {
			
		}
	}
	
	/** Explicitly calls enclosing instance method, not inherited method. */
	private class NotStatic6 extends Classes {
		public void doit() {
			System.out.println(Classes.this.bar());
		}
	}
	
	/** Uses enclosing field in instance initialiser */
	private class NotStatic7 {
		private final int myFoo = foo;
	}
	
	/** A qualified `super` access referring to an enclosing instance's `super`. */
	static class Outer extends Classes {
		class NotStatic8 extends Classes {
			private void baz() {
				System.out.println(Outer.super.getClass());
			}
		}
	}
	
	/** Could be static. */
	private class SadlyNotStatic {
		/** Could be static, provided the enclosing class is made static. */
		private class SadlyNotStaticToo {
		}
	}
	
	/** Anonymous classes can't be static.  */
	private final Object anon = new Object() {};
	
	/** Constructs a class that needs an enclosing instance. */
	private class NotStatic8 {
		{
			new NotStatic();
		}
	}

	private class MaybeStatic11 {
		{ new MaybeStatic11(); }
	}

	private class MaybeStatic12 {
		{ new Classes().new NotStatic(); }
	}

	private class MaybeStatic13 {
		{ new Static(); }
	}

	class CouldBeStatic {
		{
			new Object() {
				class CannotBeStatic {
				}
			};
		}
		class CouldBeStatic2 {
			int i;
			class NotStatic {
				{
					i = 0;
				}
			}
		}
	}

	/** An inner class extends a non-static class. */
	class CannotBeStatic2 {
		int i;
		class NotStatic extends Classes.NotStatic {
			{
				i = 0;
			}
		}
	}

	/** Has an inner anonymous class with a field initializer accessing an enclosing instance of this class. */
	class CannotBeStatic3 {
		{
			new Object() {
				int i = foo;
			};
		}
	}

	/** Has an inner anonymous class with a field initializer accessing a member of this class. */
	class CouldBeStatic3 {
		int j;
		{
			new Object() {
				int i = j;
			};
		}
	}

	/** Has a method that calls a constructor that accessing an enclosing instance of this class. */
	class CannotBeStatic4 {
		CannotBeStatic4() {
			System.out.println(foo);
		}
		void foo() {
			new CannotBeStatic4();
		}
	}
}
