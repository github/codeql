// Generated automatically from org.apache.sshd.client.simple.SimpleSessionClient for testing purposes

package org.apache.sshd.client.simple;

import java.net.InetAddress;
import java.net.SocketAddress;
import java.nio.channels.Channel;
import java.security.KeyPair;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.simple.SimpleClientConfigurator;

public interface SimpleSessionClient extends Channel, SimpleClientConfigurator
{
    ClientSession sessionLogin(SocketAddress p0, String p1, KeyPair p2);
    ClientSession sessionLogin(SocketAddress p0, String p1, String p2);
    ClientSession sessionLogin(String p0, KeyPair p1);
    ClientSession sessionLogin(String p0, String p1);
    default ClientSession sessionLogin(InetAddress p0, String p1, KeyPair p2){ return null; }
    default ClientSession sessionLogin(InetAddress p0, String p1, String p2){ return null; }
    default ClientSession sessionLogin(InetAddress p0, int p1, String p2, KeyPair p3){ return null; }
    default ClientSession sessionLogin(InetAddress p0, int p1, String p2, String p3){ return null; }
    default ClientSession sessionLogin(String p0, String p1, KeyPair p2){ return null; }
    default ClientSession sessionLogin(String p0, String p1, String p2){ return null; }
    default ClientSession sessionLogin(String p0, int p1, String p2, KeyPair p3){ return null; }
    default ClientSession sessionLogin(String p0, int p1, String p2, String p3){ return null; }
}
