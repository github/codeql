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

    //Tests broadcast of sensitive user information with permission using string literal.
    public void sendBroadcast4(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent, "com.example.user_permission");
    }

    //Tests broadcast of sensitive user information with permission using string object.
    public void sendBroadcast5(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        String perm = "com.example.user_permission";
        context.sendBroadcast(intent, perm);
    }

    //Tests broadcast of sensitive user information to a specific application.
    public void sendBroadcast6(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.setClassName("com.example2", "com.example2.UserInfoHandler");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent);
    }    

    //Tests broadcast of sensitive user information with multiple permissions using direct empty array initialization.
    public void sendBroadcast7(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcastWithMultiplePermissions(intent, new String[]{});
    }    

    //Tests broadcast of sensitive user information with multiple permissions using empty array initialization through a variable.
    public void sendBroadcast8(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        String[] perms = new String[0];
        context.sendBroadcastWithMultiplePermissions(intent, perms);
    }    

    //Tests broadcast of sensitive user information with multiple permissions using empty array initialization through two variables.
    public void sendBroadcast9(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        String[] perms = new String[0];
        String[] perms2 = perms;
        context.sendBroadcastWithMultiplePermissions(intent, perms2);
    }    

    //Tests broadcast of sensitive user information with ordered broadcast.
    public void sendBroadcast10(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendOrderedBroadcast(intent, "com.example.USER_PERM");
    }        
}
