//
//  ========================================================================
//  Copyright (c) 1995-2013 Mort Bay Consulting Pty. Ltd.
//  ------------------------------------------------------------------------
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Eclipse Public License v1.0
//  and Apache License v2.0 which accompanies this distribution.
//
//      The Eclipse Public License is available at
//      http://www.eclipse.org/legal/epl-v10.html
//
//      The Apache License v2.0 is available at
//      http://www.opensource.org/licenses/apache2.0.php
//
//  You may elect to redistribute this code under either of these licenses.
//  ========================================================================
//

package org.eclipse.jetty.demo;

import java.util.logging.Handler;
import java.util.logging.LogRecord;

public class SystemOutHandler extends Handler
{
    @Override
    public void publish(LogRecord record)
    {
        StringBuilder buf = new StringBuilder();
        buf.append("[").append(record.getLevel().getName()).append("] ");
        String logname = record.getLoggerName();
        int idx = logname.lastIndexOf('.');
        if (idx > 0)
        {
            logname = logname.substring(idx + 1);
        }
        buf.append(logname);
        buf.append(": ");
        buf.append(record.getMessage());

        System.out.println(buf.toString());
        if (record.getThrown() != null)
        {
            record.getThrown().printStackTrace(System.out);
        }
    }

    @Override
    public void flush()
    {
    }

    @Override
    public void close() throws SecurityException
    {
    }
}
