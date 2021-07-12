public class JSchOSInjectionBad {
    void jschOsExecution(HttpServletRequest request) {
        String command = request.getParameter("command");

        JSch jsch = new JSch();
        Session session = jsch.getSession("user", "sshHost", 22);
        session.setPassword("password");
        session.connect();

        Channel channel = session.openChannel("exec");
        // BAD - untrusted user data is used directly in a command
        ((ChannelExec) channel).setCommand("ping " + command);
        
        channel.connect();
    }
}

