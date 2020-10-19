import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

class SensitiveBroadcast {

    //Tests broadcast of access token with intent extra.
    public void sendBroadcast1(Context context, String token, String refreshToken) {
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent);
    }

    //Tests broadcast of sensitive user information with intent extra.
    public void sendBroadcast2(Context context) {
        String username = "test123";
        String password = "abc12345";

        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent);
    }

    //Tests broadcast of sensitive user information with extra bundle.
    public void sendBroadcast3(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        Bundle bundle = new Bundle();
        bundle.putCharSequence("name", username);
        bundle.putCharSequence("pwd", password);
        intent.putExtras(bundle);
        context.sendBroadcast(intent);
    }    

    //Tests broadcast of sensitive user information with permission.
    public void sendBroadcast4(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent, "com.example.user_permission");
    }

    //Tests broadcast of sensitive user information to a specific application.
    public void sendBroadcast5(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.setClassName("com.example2", "com.example2.UserInfoHandler");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent);
    }    
}
