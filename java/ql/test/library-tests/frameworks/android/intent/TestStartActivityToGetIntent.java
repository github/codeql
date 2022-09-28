import android.app.Activity;
import android.content.Context;
import android.content.Intent;

// ! Original - saving for reference
// public class TestStartActivityToGetIntent {

//     static Object source() {
//         return null;
//     }

//     static void sink(Object sink) {
//     }

//     public void test(Context ctx) {
//         Intent intent = new Intent(null, SomeActivity.class);
//         intent.putExtra("data", (String) source());
//         ctx.startActivity(intent);
//     }

//     static class SomeActivity extends Activity {

//         public void test() {
//             sink(getIntent().getStringExtra("data")); // $ hasValueFlow
//         }
//     }
// }

public class TestStartActivityToGetIntent {

    static Object source(String kind) {
        return null;
    }

    static void sink(Object sink) {
    }

    public void test(Context ctx, Activity act) {
        {
            Intent intentCtx = new Intent(null, SomeActivity.class);
            Intent intentAct = new Intent(null, SomeActivity.class);
            intentCtx.putExtra("data", (String) source("context"));
            intentAct.putExtra("data", (String) source("activity"));
            ctx.startActivity(intentCtx);
            act.startActivity(intentAct);
        }

        {
            Intent intentCtx = new Intent(null, SafeActivity.class);
            Intent intentAct = new Intent(null, SafeActivity.class);
            ctx.startActivity(intentCtx);
            act.startActivity(intentAct);
        }
    }

    static class SomeActivity extends Activity {

        public void test() {
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow=context hasValueFlow=activity
        }
    }

    static class SafeActivity extends Activity {

        public void test() {
            sink(getIntent().getStringExtra("data")); // Safe
        }
    }
}
