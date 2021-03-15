import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.net.URL;

public class ServletContextListenerMain implements ServletContextListener {
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("listener starts to work!");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("listener stopped!");
	}

	// BAD - Implement a main method in servlet listener.
	public static void main(String[] args) {
		try {
			URL url = new URL("https://www.example.com");
			url.openConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
