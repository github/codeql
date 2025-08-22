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

import javax.servlet.ServletContextAttributeEvent;
import javax.servlet.ServletContextAttributeListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletRequestAttributeEvent;
import javax.servlet.ServletRequestAttributeListener;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.http.HttpSessionActivationListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class TagListener implements HttpSessionListener,  HttpSessionAttributeListener, HttpSessionActivationListener, ServletContextListener, ServletContextAttributeListener, ServletRequestListener, ServletRequestAttributeListener
{
    public void attributeAdded(HttpSessionBindingEvent se)
    {
         //System.err.println("tagListener: attributedAdded "+se);
    }

    public void attributeRemoved(HttpSessionBindingEvent se)
    {
         //System.err.println("tagListener: attributeRemoved "+se);
    }

    public void attributeReplaced(HttpSessionBindingEvent se)
    {
         //System.err.println("tagListener: attributeReplaced "+se);
    }

    public void sessionWillPassivate(HttpSessionEvent se)
    {
         //System.err.println("tagListener: sessionWillPassivate "+se);
    }

    public void sessionDidActivate(HttpSessionEvent se)
    {
         //System.err.println("tagListener: sessionDidActivate "+se);
    }

    public void contextInitialized(ServletContextEvent sce)
    {
         //System.err.println("tagListener: contextInitialized "+sce);
    }

    public void contextDestroyed(ServletContextEvent sce)
    {
         //System.err.println("tagListener: contextDestroyed "+sce);
    }

    public void attributeAdded(ServletContextAttributeEvent scab)
    {
         //System.err.println("tagListener: attributeAdded "+scab);
    }

    public void attributeRemoved(ServletContextAttributeEvent scab)
    {
         //System.err.println("tagListener: attributeRemoved "+scab);
    }

    public void attributeReplaced(ServletContextAttributeEvent scab)
    {
         //System.err.println("tagListener: attributeReplaced "+scab);
    }

    public void requestDestroyed(ServletRequestEvent sre)
    {
         //System.err.println("tagListener: requestDestroyed "+sre);
    }

    public void requestInitialized(ServletRequestEvent sre)
    {
         //System.err.println("tagListener: requestInitialized "+sre);
    }

    public void attributeAdded(ServletRequestAttributeEvent srae)
    {
         //System.err.println("tagListener: attributeAdded "+srae);
    }

    public void attributeRemoved(ServletRequestAttributeEvent srae)
    {
         //System.err.println("tagListener: attributeRemoved "+srae);
    }

    public void attributeReplaced(ServletRequestAttributeEvent srae)
    {
         //System.err.println("tagListener: attributeReplaced "+srae);
    }

    public void sessionCreated(HttpSessionEvent se)
    {
         //System.err.println("tagListener: sessionCreated "+se);
    }

    public void sessionDestroyed(HttpSessionEvent se)
    {
         //System.err.println("tagListener: sessionDestroyed "+se);
    }

}
