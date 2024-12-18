import android.app.Activity;
import android.app.Notification;
import androidx.core.app.NotificationCompat;
import android.content.Intent;
import android.app.PendingIntent;
import android.widget.RemoteViews;

class Test extends Activity {
    void test(String password) {
        Notification.Builder builder = new Notification.Builder(this, "");
        builder.setContentText(password); // $sensitive-notification
        builder.setContentTitle(password); // $sensitive-notification
        builder.setContentInfo(password); // $sensitive-notification

        Intent intent = new Intent();
        intent.putExtra("a", password);

        builder.addExtras(intent.getExtras()); // $sensitive-notification
        builder.setCategory(password); // $sensitive-notification
        builder.setChannelId(password); // $sensitive-notification
        builder.setGroup(password); // $sensitive-notification
        builder.setExtras(intent.getExtras()); // $sensitive-notification
        builder.setGroup(password); // $sensitive-notification
        builder.setSortKey(password); // $sensitive-notification
        builder.setSettingsText(password); // $sensitive-notification
        builder.setRemoteInputHistory(new CharSequence[] { password }); // $sensitive-notification
        builder.setTicker(password); // $sensitive-notification
        builder.setTicker(password, null); // $sensitive-notification

        builder.setStyle(new Notification.BigPictureStyle()
            .setContentDescription(password) // $sensitive-notification
            .setSummaryText(password) // $sensitive-notification
            .setBigContentTitle(password)); // $sensitive-notification
        builder.setStyle(new Notification.BigTextStyle()
            .bigText(password) // $sensitive-notification
            .setSummaryText(password) // $sensitive-notification
            .setBigContentTitle(password)); // $sensitive-notification
        builder.setStyle(new Notification.InboxStyle()
            .addLine(password) // $sensitive-notification
            .setBigContentTitle(password) // $sensitive-notification
            .setSummaryText(password)); // $sensitive-notification
        builder.setStyle(new Notification.MediaStyle()
            .setRemotePlaybackInfo(password, 0, null)); // $sensitive-notification
        builder.setStyle( 
                new Notification.MessagingStyle(password) // $sensitive-notification
                    .setConversationTitle(password) // $sensitive-notification
                    .addMessage(password, 0, "") // $sensitive-notification
                    .addMessage(password, 0, (android.app.Person)null) // $sensitive-notification
                    .addMessage("", 0, password) // $sensitive-notification
                    .addMessage(new Notification.MessagingStyle.Message(password, 0, "")) // $sensitive-notification
                    .addMessage(new Notification.MessagingStyle.Message(password, 0, (android.app.Person)null)) // $sensitive-notification
                    .addMessage(new Notification.MessagingStyle.Message("", 0, password)) // $sensitive-notification
                );

        builder.addAction(0, password, null); // $sensitive-notification
        builder.addAction(new Notification.Action(0, password, null)); // $sensitive-notification
        builder.addAction(new Notification.Action.Builder(0, password, null) // $sensitive-notification
            .addExtras(intent.getExtras()) // $sensitive-notification
            .build());
        builder.addAction(new Notification.Action.Builder(null, password, null).build()); // $sensitive-notification

        builder.setStyle(Notification.CallStyle.forScreeningCall(null, null, null) 
            .setVerificationText(password)); // $sensitive-notification
    }

    void test2(RemoteViews passwordView) {
        Notification.Builder builder = new Notification.Builder(this, "");
        builder.setContent(passwordView); // $sensitive-notification
        builder.setCustomBigContentView(passwordView); // $sensitive-notification
        builder.setCustomContentView(passwordView); // $sensitive-notification
        builder.setCustomHeadsUpContentView(passwordView); // $sensitive-notification
        builder.setTicker("", passwordView); // $sensitive-notification
    }

    void test3(String password) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "");
        builder.setContentText(password); // $sensitive-notification
        builder.setContentTitle(password); // $sensitive-notification
        builder.setContentInfo(password); // $sensitive-notification

        Intent intent = new Intent();
        intent.putExtra("a", password);

        builder.addExtras(intent.getExtras()); // $sensitive-notification
        builder.setCategory(password); // $sensitive-notification
        builder.setChannelId(password); // $sensitive-notification
        builder.setGroup(password); // $sensitive-notification
        builder.setExtras(intent.getExtras()); // $sensitive-notification
        builder.setGroup(password); // $sensitive-notification
        builder.setSortKey(password); // $sensitive-notification
        builder.setSettingsText(password); // $sensitive-notification
        builder.setRemoteInputHistory(new CharSequence[] { password }); // $sensitive-notification
        builder.setTicker(password); // $sensitive-notification
        builder.setTicker(password, null); // $sensitive-notification

        builder.setStyle(new NotificationCompat.BigPictureStyle()
            .setContentDescription(password) // $sensitive-notification
            .setSummaryText(password) // $sensitive-notification
            .setBigContentTitle(password)); // $sensitive-notification
        builder.setStyle(new NotificationCompat.BigTextStyle()
            .bigText(password) // $sensitive-notification
            .setSummaryText(password) // $sensitive-notification
            .setBigContentTitle(password)); // $sensitive-notification
        builder.setStyle(new NotificationCompat.InboxStyle()
            .addLine(password) // $sensitive-notification
            .setBigContentTitle(password) // $sensitive-notification
            .setSummaryText(password)); // $sensitive-notification
        builder.setStyle( 
                new NotificationCompat.MessagingStyle(password) // $sensitive-notification
                    .setConversationTitle(password) // $sensitive-notification
                    .addMessage(password, 0, "") // $sensitive-notification
                    .addMessage(password, 0, (androidx.core.app.Person)null) // $sensitive-notification
                    .addMessage("", 0, password) // $sensitive-notification
                    .addMessage(new NotificationCompat.MessagingStyle.Message(password, 0, "")) // $sensitive-notification
                    .addMessage(new NotificationCompat.MessagingStyle.Message(password, 0, (androidx.core.app.Person)null)) // $sensitive-notification
                    .addMessage(new NotificationCompat.MessagingStyle.Message("", 0, password)) // $sensitive-notification
                );

        builder.addAction(0, password, null); // $sensitive-notification
        builder.addAction(new NotificationCompat.Action(0, password, null)); // $sensitive-notification
        builder.addAction(new NotificationCompat.Action.Builder(0, password, null) // $sensitive-notification
            .addExtras(intent.getExtras()) // $sensitive-notification
            .build());
        builder.addAction(new NotificationCompat.Action.Builder(null, password, null).build()); // $sensitive-notification

        builder.setStyle(NotificationCompat.CallStyle.forScreeningCall(null, null, null)
            .setVerificationText(password)); // $sensitive-notification
    }
}