import android.os.AsyncTask;

public class Test {

    private static Object source(String kind) {
        return null;
    }

    private static void sink(Object o) {}

    public void test() {
        TestAsyncTask t = new TestAsyncTask();
        t.execute(source("execute"), null);
        t.executeOnExecutor(null, source("executeOnExecutor"), null);
        SafeAsyncTask t2 = new SafeAsyncTask();
        t2.execute("safe");
        TestConstructorTask t3 = new TestConstructorTask(source("constructor"), "safe");
        t3.execute(source("params"));
    }

    private class TestAsyncTask extends AsyncTask<Object, Object, Object> {
        @Override
        protected Object doInBackground(Object... params) {
            sink(params[0]); // $ hasTaintFlow=execute hasTaintFlow=executeOnExecutor
            sink(params[1]); // $ SPURIOUS: hasTaintFlow=execute hasTaintFlow=executeOnExecutor
            return null;
        }
    }

    private class SafeAsyncTask extends AsyncTask<Object, Object, Object> {
        @Override
        protected Object doInBackground(Object... params) {
            sink(params[0]); // Safe
            return null;
        }
    }

    static class TestConstructorTask extends AsyncTask<Object, Object, Object> {
        private Object field;
        private Object safeField;
        private Object initField;
        {
            initField = Test.source("init");
        }

        public TestConstructorTask(Object field, Object safeField) {
            this.field = field;
            this.safeField = safeField;
        }

        @Override
        protected Object doInBackground(Object... params) {
            sink(params[0]); // $ hasTaintFlow=params
            sink(field); // $ hasValueFlow=constructor
            sink(safeField); // Safe
            sink(initField); // $ hasValueFlow=init
            return params[0];
        }

        @Override
        protected void onPostExecute(Object param) {
            sink(param); // $ hasTaintFlow=params
            sink(field); // $ hasValueFlow=constructor
            sink(safeField); // Safe
            sink(initField); // $ hasValueFlow=init
        }

    }
}
