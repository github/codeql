import javax.ws.rs.client.*;

public class JaxWsSSRF {
    public static void main(String[] args) {
        Client client = ClientBuilder.newClient();
        String url = args[1];
        client.target(url);
    }
}


