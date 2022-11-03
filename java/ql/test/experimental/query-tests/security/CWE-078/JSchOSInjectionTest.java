import com.jcraft.jsch.*;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class JSchOSInjectionTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
            String host = "sshHost";
            String user = "user";
            String password = "password";
            String command = request.getParameter("command");

            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            
            JSch jsch = new JSch();
            Session session = jsch.getSession(user, host, 22);
            session.setPassword(password);
            session.setConfig(config);
            session.connect();

            Channel channel = session.openChannel("exec");
            ((ChannelExec) channel).setCommand("ping " + command);
            channel.setInputStream(null);
            ((ChannelExec) channel).setErrStream(System.err);

            channel.connect();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
            String host = "sshHost";
            String user = "user";
            String password = "password";
            String command = request.getParameter("command");

            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            
            JSch jsch = new JSch();
            Session session = jsch.getSession(user, host, 22);
            session.setPassword(password);
            session.setConfig(config);
            session.connect();

            ChannelExec channel = (ChannelExec)session.openChannel("exec");
            channel.setCommand("ping " + command);
            channel.setInputStream(null);
            channel.setErrStream(System.err);

            channel.connect();
    }
}