public void sendBroadcast1(Context context, String token, String refreshToken) 
{
    {
        // BAD: broadcast sensitive information without permission
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent);
    }

    {
        // GOOD: broadcast sensitive information with permission
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent, "com.example.user_permission");
    }
}