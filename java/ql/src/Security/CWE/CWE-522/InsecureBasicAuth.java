public class InsecureBasicAuth {
  /**
   * Test basic authentication with Apache HTTP request.
   */	
  public void testApacheHttpRequest(String username, String password) {
  {
    // BAD: basic authentication over HTTP
    String url = "http://www.example.com/rest/getuser.do?uid=abcdx";
  }

  {
    // GOOD: basic authentication over HTTPS
    String url = "https://www.example.com/rest/getuser.do?uid=abcdx";
  }

    HttpPost post = new HttpPost(url);
    post.setHeader("Accept", "application/json");
    post.setHeader("Content-type", "application/json");
		
    String authString = username + ":" + password;
    byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
    String authStringEnc = new String(authEncBytes);

    post.addHeader("Authorization", "Basic " + authStringEnc);
  }

  /**
   * Test basic authentication with Java HTTP URL connection.
   */
  public void testHttpUrlConnection(String username, String password) {
  {
    // BAD: basic authentication over HTTP
    String urlStr = "http://www.example.com/rest/getuser.do?uid=abcdx";
  }

  {
    // GOOD: basic authentication over HTTPS
    String urlStr = "https://www.example.com/rest/getuser.do?uid=abcdx";
  }

    String authString = username + ":" + password;
    String encoding = Base64.getEncoder().encodeToString(authString.getBytes("UTF-8"));
    URL url = new URL(urlStr);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setDoOutput(true);
    conn.setRequestProperty("Authorization", "Basic " + encoding);
  }
}
