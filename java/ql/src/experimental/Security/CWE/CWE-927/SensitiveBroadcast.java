public void sendBroadcast1(Context context, String token, String refreshToken) 
{
    {
        // BAD: broadcast sensitive information to all listeners
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent);
    }

    {
        // GOOD: broadcast sensitive information only to those with permission
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent, "com.example.user_permission");
    }

    {
        // GOOD: broadcast sensitive information to a specific application
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.setClassName("com.example2", "com.example2.UserInfoHandler");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent);
    }
}