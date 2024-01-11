import android.app.Activity;
import android.app.Notification;
import androidx.core.app.NotificationCompat;

class Test extends Activity {
    void test(String password) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "");
        builder.setContentText(password); // $sensitive-notification

    }

    void test2(String password) {
        Notification.Builder builder = new Notification.Builder(this, "");
        builder.setContentText(password); // $sensitive-notification
    }
}