import org.apache.shiro.web.mgt.CookieRememberMeManager;


public class HardcodedShiroKey {

    //BAD: hard-coded shiro key
    public void testHardcodedShiroKey(String input) {
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        cookieRememberMeManager.setCipherKey("TEST123".getBytes());

    }


    //BAD: hard-coded shiro key encoded by java.util.Base64 
    public void testHardcodedbase64ShiroKey1(String input) {
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        java.util.Base64.Decoder decoder = java.util.Base64.getDecoder();
        cookieRememberMeManager.setCipherKey(decoder.decode("4AvVhmFLUs0KTA3Kprsdag=="));

    }


    //BAD: hard-coded shiro key encoded by org.apache.shiro.codec.Base64
    public void testHardcodedbase64ShiroKey2(String input) {
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        cookieRememberMeManager.setCipherKey(org.apache.shiro.codec.Base64.decode("6ZmI6I2j5Y+R5aSn5ZOlAA=="));

    }

    //GOOD: random shiro key
    public void testRandomShiroKey(String input) {
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
    }






}