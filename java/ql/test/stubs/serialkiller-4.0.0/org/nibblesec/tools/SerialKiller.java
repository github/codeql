/*
 * SerialKiller.java
 *
 * Copyright (c) 2015-2016 Luca Carettoni
 *
 * SerialKiller is an easy-to-use look-ahead Java deserialization library
 * to secure application from untrusted input. When Java serialization is
 * used to exchange information between a client and a server, attackers
 * can replace the legitimate serialized stream with malicious data.
 * SerialKiller inspects Java classes during naming resolution and allows
 * a combination of blacklisting/whitelisting to secure your application.
 *
 * Dual-Licensed Software: Apache v2.0 and GPL v2.0
 */
package org.nibblesec.tools;

import java.io.ObjectInputStream;
import java.io.InputStream;
import java.io.IOException;

public class SerialKiller extends ObjectInputStream {
    public SerialKiller(InputStream inputStream, String configFile) throws IOException {}
}