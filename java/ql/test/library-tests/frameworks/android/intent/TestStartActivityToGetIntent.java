import android.app.Activity;
import android.content.Context;
import android.content.Intent;

public class TestStartActivityToGetIntent {

    static Object source(String kind) {
        return null;
    }

    static void sink(Object sink) {}

    public void test(Context ctx, Activity act) {

        // test all methods that start an activity
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("ctx-start"));
            ctx.startActivity(intent);
        }
        {
            // Intent intent1 = new Intent(null, SomeActivity2.class);
            // intent1.putExtra("data", (String) source("ctx-starts"));
            // Intent intent2 = new Intent(null, SomeActivity3.class);
            // intent2.putExtra("data", (String) source("ctx-starts"));
            // Intent[] intents = {intent1, intent2};
            // ctx.startActivities(intents);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("act-start"));
            act.startActivity(intent);
        }
        {
            // Intent[] intent = {new Intent(null, SomeActivity.class)};
            // intent[0].putExtra("data", (String) source("act-starts"));
            // act.startActivities(intent);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("start-for-result"));
            act.startActivityForResult(intent, 0);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("start-if-needed"));
            act.startActivityIfNeeded(intent, 0);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("start-matching"));
            act.startNextMatchingActivity(intent);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("start-from-child"));
            act.startActivityFromChild(null, intent, 0);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("start-from-frag"));
            act.startActivityFromFragment(null, intent, 0);
        }

        // test 4-arg Intent constructor
        {
            Intent intent = new Intent(null, null, null, SomeActivity.class);
            intent.putExtra("data", (String) source("4-arg"));
            ctx.startActivity(intent);
        }

        // safe test
        {
            Intent intent = new Intent(null, SafeActivity.class);
            intent.putExtra("data", "safe");
            ctx.startActivity(intent);
        }
    }

    static class SomeActivity extends Activity {

        public void test() {
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow=ctx-start hasValueFlow=act-start hasValueFlow=start-for-result hasValueFlow=start-if-needed hasValueFlow=start-matching hasValueFlow=start-from-child hasValueFlow=start-from-frag hasValueFlow=4-arg
        }

    }

    // static class SomeActivity2 extends Activity {

    //     public void test() {
    //         sink(getIntent().getStringExtra("data")); // $ hasValueFlow=ctx-starts
    //     }

    // }

    // static class SomeActivity3 extends Activity {

    //     public void test() {
    //         sink(getIntent().getStringExtra("data")); // $ hasValueFlow=ctx-starts
    //     }

    // }

    static class SafeActivity extends Activity {

        public void test() {
            sink(getIntent().getStringExtra("data")); // Safe
        }
    }
}
