import org.apache.shiro.web.mgt.CookieRememberMeManager;

public class HardcodedShiroKey {

    //BAD: hard-coded shiro key
	public void testHardcodedShiroKey(String input) {
		CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        cookieRememberMeManager.setCipherKey("TEST123".getBytes());

	}

	
	//BAD: hard-coded shiro key 
	public void testHardcodedbase64ShiroKey(String input) {
		CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        cookieRememberMeManager.setCipherKey(Base64.decode("4AvVhmFLUs0KTA3Kprsdag=="));

	}

	//GOOD: random shiro key
	public void testRandomShiroKey(String input) {
		CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
	}



	static class Base64 {

		static byte[] decode(String str){

			byte[] x = new byte[1024];

			return x;

		}

	}




}