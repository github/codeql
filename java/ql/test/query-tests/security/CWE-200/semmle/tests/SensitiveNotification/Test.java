import android.app.Activity;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

class Test extends Activity {
    void test(String password) {
        NotificationManagerCompat manager = NotificationManagerCompat.from(this);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "");
        builder.setContentText(password);
        manager.notify(0, builder.build()); // sensitive-notification
    }
}