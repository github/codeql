import android.app.Activity;
import android.app.Notification;
import androidx.core.app.NotificationCompat;
import android.content.Intent;
import android.app.PendingIntent;

class Test extends Activity {
    void test(String password) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "");
        builder.setContentText(password); // $sensitive-notification

    }

    void test2(String password) {
        Notification.Builder builder = new Notification.Builder(this, "");
        builder.setContentText(password); // $sensitive-notification
        builder.setContentTitle(password); // $sensitive-notification
        builder.addAction(0, password, null); // $sensitive-notification
        builder.addAction(new Notification.Action(0, password, null)); // $sensitive-notification
        // builder.setStyle( // TODO: update stubs to include MessagingStyle
        //         new Notification.MessagingStyle(password) // $sensitive-notification
        //             .setConversationTitle(password)) // $sensitive-notification
        //             .addMessage(password, 0, null); // $sensitive-notification
        builder.setStyle(new Notification.BigTextStyle().bigText(password)); // $sensitive-notification 
        Intent intent = new Intent();
        intent.putExtra("a", password);
        builder.setContentIntent(PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)); // $MISSING: sensitive-notification // missing model for getActivity

    }
}