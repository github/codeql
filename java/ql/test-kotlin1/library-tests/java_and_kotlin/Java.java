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

/*
// Java interop disabled as it currently doesn't work (no symbol fn1(int, Completion<...>) gets created)
// TODO: re-enable this test once a correct function signature is extracted
		@Override
		public Object fn1(int x, Continuation<? super String> $completion) {
			return super.fn1(x, $completion);
		}
*/
	}
}
