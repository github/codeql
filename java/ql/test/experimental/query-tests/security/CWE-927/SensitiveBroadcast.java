import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import java.util.ArrayList;

class SensitiveBroadcast {

    // BAD - Tests broadcast of access token with intent extra.
    public void sendBroadcast1(Context context, String token, String refreshToken) {
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("token", token);
        intent.putExtra("refreshToken", refreshToken);
        context.sendBroadcast(intent);
    }

    // BAD - Tests broadcast of sensitive user information with intent extra.
    public void sendBroadcast2(Context context) {
        String userName = "test123";
        String password = "abc12345";

        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", userName);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent);
    }

    // BAD - Tests broadcast of email information with extra bundle.
    public void sendBroadcast3(Context context) {
        String email = "user123@example.com";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        Bundle bundle = new Bundle();
        bundle.putString("email", email);
        intent.putExtras(bundle);
        context.sendBroadcast(intent);
    }    

    // BAD - Tests broadcast of sensitive user information with null permission.
    public void sendBroadcast4(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        ArrayList<String> userinfo = new ArrayList<String>();
        userinfo.add(username);
        userinfo.add(password);
        intent.putStringArrayListExtra("userinfo", userinfo);
        context.sendBroadcast(intent, null);
    }

    // GOOD - Tests broadcast of sensitive user information with permission using string literal.
    public void sendBroadcast5(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent, "com.example.user_permission");
    }

    // GOOD - Tests broadcast of access ticket with permission using string object.
    public void sendBroadcast6(Context context) {
        String ticket = "Tk9UIFNlY3VyZSBUaWNrZXQ=";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("ticket", ticket);
        String perm = "com.example.user_permission";
        context.sendBroadcast(intent, perm);
    }

    // GOOD - Tests broadcast of sensitive user information to a specific application.
    public void sendBroadcast7(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.setClassName("com.example2", "com.example2.UserInfoHandler");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendBroadcast(intent);
    }    

    // BAD - Tests broadcast of access ticket with multiple permissions using direct empty array initialization.
    public void sendBroadcast8(Context context) {
        String ticket = "Tk9UIFNlY3VyZSBUaWNrZXQ=";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("ticket", ticket);
        context.sendBroadcastWithMultiplePermissions(intent, new String[]{});
    }    

    // BAD - Tests broadcast of sensitive user information with multiple permissions using empty array initialization through a variable.
    public void sendBroadcast9(Context context) {
        String username = "test123";
        String passcode = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", passcode);
        String[] perms = new String[0];
        context.sendBroadcastWithMultiplePermissions(intent, perms);
    }    

    // GOOD - Tests broadcast of sensitive user information with multiple permissions.
    public void sendBroadcast10(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        String[] perms = new String[]{"com.example.custom_action", "com.example.custom_action2"};
        context.sendBroadcastWithMultiplePermissions(intent, perms);
    }    
   
    // BAD - Tests broadcast of sensitive user information with multiple permissions using empty array initialization through two variables and `intent.putExtras(bundle)`.
    public void sendBroadcast11(Context context) {
        String username = "test123";
        String passwd = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        Bundle bundle = new Bundle();
        bundle.putString("name", username);
        bundle.putString("pwd", passwd);
        intent.putExtras(bundle);
        String[] perms = new String[0];
        String[] perms2 = perms;
        context.sendBroadcastWithMultiplePermissions(intent, perms2);
    }    

    /** 
     * BAD - Tests broadcast of sensitive user information with multiple permissions using empty array initialization through two variables and `intent.getExtras().putString()`.
     * Note this case of `getExtras().putString(...)` is not yet detected thus is beyond what the query is capable of.
     */ 
    public void sendBroadcast12(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        Bundle bundle = new Bundle();
        intent.putExtras(bundle);
        intent.getExtras().putString("name", username);
        intent.getExtras().putString("pwd", password);
        String[] perms = new String[0];
        String[] perms2 = perms;
        context.sendBroadcastWithMultiplePermissions(intent, perms2);
    }    

    // GOOD - Tests broadcast of sensitive user information with ordered broadcast.
    public void sendBroadcast13(Context context) {
        String username = "test123";
        String password = "abc12345";
    
        Intent intent = new Intent();
        intent.setAction("com.example.custom_action");
        intent.putExtra("name", username);
        intent.putExtra("pwd", password);
        context.sendOrderedBroadcast(intent, "com.example.USER_PERM");
    }        
}
