// BAD: `password` is exposed in a notification.
void confirmPassword(String password) {
    NotificationManager manager = NotificationManager.from(this);
    manager.send(
        new Notification.Builder(this, CHANNEL_ID)
        .setContentText("Your password is: " + password)
        .build());
}