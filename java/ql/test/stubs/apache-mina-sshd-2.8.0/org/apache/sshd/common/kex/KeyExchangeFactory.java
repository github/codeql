// Generated automatically from org.apache.sshd.common.kex.KeyExchangeFactory for testing purposes

package org.apache.sshd.common.kex;

import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.kex.KeyExchange;
import org.apache.sshd.common.session.Session;

public interface KeyExchangeFactory extends NamedResource
{
    KeyExchange createKeyExchange(Session p0);
}
