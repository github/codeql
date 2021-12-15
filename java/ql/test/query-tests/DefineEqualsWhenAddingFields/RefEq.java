
public class RefEq {
	{
		class Super {
			@Override
			public boolean equals(Object obj) {
				return super.equals(obj);
			}
		}
		class Sub extends Super {
			int i; // OK
		}
	}
	{
		class Super {
			@Override
			public boolean equals(Object obj) {
				return (obj==this);
			}
		}
		class Sub extends Super {
			int i; // OK
		}
	}
	{
		class Super {
			@Override
			public boolean equals(Object obj) {
				if (obj==this)
					return true;
				else
					return false;
			}
		}
		class Sub extends Super {
			int i; // OK
		}
	}
}
