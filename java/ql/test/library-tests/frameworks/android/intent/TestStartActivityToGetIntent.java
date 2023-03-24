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
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("ctx-start-acts"));
            Intent[] intents = new Intent[] {intent};
            ctx.startActivities(intents);
        }
        {
            Intent intent = new Intent(null, AnotherActivity.class);
            intent.putExtra("data", (String) source("ctx-start-acts-2"));
            Intent[] intents = new Intent[] {intent};
            ctx.startActivities(intents);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("act-start"));
            act.startActivity(intent);
        }
        {
            Intent intent = new Intent(null, SomeActivity.class);
            intent.putExtra("data", (String) source("act-start-acts"));
            Intent[] intents = new Intent[] {intent};
            act.startActivities(intents);
        }
        {
            Intent intent = new Intent(null, Object.class);
            intent.putExtra("data", (String) source("start-activities-should-not-reach"));
            Intent[] intents = new Intent[] {intent};
            act.startActivities(intents);
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
            // @formatter:off
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow=ctx-start hasValueFlow=act-start hasValueFlow=start-for-result hasValueFlow=start-if-needed hasValueFlow=start-matching hasValueFlow=start-from-child hasValueFlow=start-from-frag hasValueFlow=4-arg hasValueFlow=ctx-start-acts hasValueFlow=act-start-acts
            // @formatter:on
        }
    }

    static class AnotherActivity extends Activity {
        public void test() {
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow=ctx-start-acts-2
        }
    }

    static class SafeActivity extends Activity {

        public void test() {
            sink(getIntent().getStringExtra("data")); // Safe
        }
    }
}
