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

package com.acme;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;

import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.JspFragment;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class Date2Tag extends SimpleTagSupport
{
    String format;

    public void setFormat(String value) {
        this.format = value;
    }

    public void doTag() throws JspException, IOException {
        String formatted =
            new SimpleDateFormat("long".equals(format)?"EEE 'the' d:MMM:yyyy":"d:MM:yy")
            .format(new Date());
        StringTokenizer tok = new StringTokenizer(formatted,":");
        JspContext context = getJspContext();
        context.setAttribute("day", tok.nextToken() );
        context.setAttribute("month", tok.nextToken() );
        context.setAttribute("year", tok.nextToken() );

        JspFragment fragment = getJspBody();
        fragment.invoke(null);
    }
}

