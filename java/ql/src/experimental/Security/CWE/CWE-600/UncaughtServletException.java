import java.io.InputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

class UncaughtServletException extends HttpServlet {
    // BAD: Uncaught exceptions
    {
        public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            String ip = request.getParameter("srcIP");
            InetAddress addr = InetAddress.getByName(ip); //BAD: getByName(String) throws UnknownHostException.

            String username = request.getRemoteUser();
            Integer.parseInt(username); //BAD: Integer.parse(String) throws RuntimeException.
        }
    }

    // GOOD
    {
        public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            try {
                String ip = request.getParameter("srcIP");
                InetAddress addr = InetAddress.getByName(ip);
            } catch (UnknownHostException uhex) {  //GOOD: Catch the subclass exception UnknownHostException of IOException.
                uhex.printStackTrace();
            }
        }
    }

    // GOOD
    {
        public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            String ip = "10.100.10.81";
            InetAddress addr = InetAddress.getByName(ip); // OK: Hard-coded variable value or system property is not controlled by attacker.
        }
    }

}