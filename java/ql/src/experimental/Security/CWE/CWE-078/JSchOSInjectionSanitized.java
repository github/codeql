public class JSchOSInjectionSanitized {
    void jschOsExecutionPing(HttpServletRequest request) {
        String untrusted = request.getParameter("command");

        //GOOD - Validate user the input.
        if (!com.google.common.net.InetAddresses.isInetAddress(untrusted)) {
            System.out.println("Invalid IP address");
            return;
        }

        JSch jsch = new JSch();
        Session session = jsch.getSession("user", "host", 22);
        session.setPassword("password");
        session.connect();

        Channel channel = session.openChannel("exec");
        ((ChannelExec) channel).setCommand("ping " + untrusted);

        channel.connect();
    }

    void jschOsExecutionDig(HttpServletRequest request) {
        String untrusted = request.getParameter("command");

        //GOOD - check whether the user input doesn't contain dangerous shell characters.
        String[] badChars = new String[] {"^", "~" ," " , "&", "|", ";", "$", ">", "<", "`", "\\", ",", "!", "{", "}", "(", ")", "@", "%", "#", "%0A", "%0a", "\n", "\r\n"};

        for (String badChar : badChars) {
            if (untrusted.contains(badChar)) {
                System.out.println("Invalid host");
                return;
            }    
        }

        JSch jsch = new JSch();
        Session session = jsch.getSession("user", "host", 22);
        session.setPassword("password");
        session.connect();

        Channel channel = session.openChannel("exec");
        ((ChannelExec) channel).setCommand("dig " + untrusted);

        channel.connect();
    }
}

