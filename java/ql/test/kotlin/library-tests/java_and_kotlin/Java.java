import kotlin.coroutines.Continuation;

public class Java {
	void javaFun() {
		new Kotlin().kotlinFun();
	}

	public class Djava extends Base {
		@Override
		public String fn0(int x) {
			return super.fn0(x);
		}

		@Override
		public Object fn1(int x, Continuation<? super String> $completion) {
			return super.fn1(x, $completion);
		}
	}
}
