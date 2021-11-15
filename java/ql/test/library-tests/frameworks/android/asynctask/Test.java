import android.os.AsyncTask;

public class Test {

    private static Object source(String kind) {
        return null;
    }

    private static void sink(Object o) {}

    public void test() {
        TestAsyncTask t = new TestAsyncTask();
        t.execute(source("execute"));
        t.executeOnExecutor(null, source("executeOnExecutor"));
        SafeAsyncTask t2 = new SafeAsyncTask();
        t2.execute("safe");
    }

    private class TestAsyncTask extends AsyncTask<Object, Object, Object> {
        @Override
        protected Object doInBackground(Object... params) {
            sink(params); // $ hasValueFlow=execute hasValueFlow=executeOnExecutor
            return null;
        }
    }

    private class SafeAsyncTask extends AsyncTask<Object, Object, Object> {
        @Override
        protected Object doInBackground(Object... params) {
            sink(params); // Safe
            return null;
        }
    }
}
