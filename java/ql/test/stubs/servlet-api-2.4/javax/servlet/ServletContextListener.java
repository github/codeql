/*
 * Copyright (c) 1997-2018 Oracle and/or its affiliates. All rights reserved.
 * Copyright 2004 The Apache Software Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package javax.servlet;

import java.util.EventListener;

/** 
 * Interface for receiving notification events about ServletContext
 * lifecycle changes.
 *
 * <p>In order to receive these notification events, the implementation
 * class must be either declared in the deployment descriptor of the web
 * application, annotated with {@link javax.servlet.annotation.WebListener},
 * or registered via one of the addListener methods defined on
 * {@link ServletContext}.
 *
 * <p>Implementations of this interface are invoked at their
 * {@link #contextInitialized} method in the order in which they have been
 * declared, and at their {@link #contextDestroyed} method in reverse
 * order.
 *
 * @see ServletContextEvent
 *
 * @since Servlet 2.3
 */
public interface ServletContextListener extends EventListener {

    /**
     * Receives notification that the web application initialization
     * process is starting.
     *
     * <p>All ServletContextListeners are notified of context
     * initialization before any filters or servlets in the web
     * application are initialized.
     *
     * @param sce the ServletContextEvent containing the ServletContext
     * that is being initialized
     *
     * @implSpec
     * The default implementation takes no action.
     */
    default public void contextInitialized(ServletContextEvent sce) {}

    /**
     * Receives notification that the ServletContext is about to be
     * shut down.
     *
     * <p>All servlets and filters will have been destroyed before any
     * ServletContextListeners are notified of context
     * destruction.
     *
     * @param sce the ServletContextEvent containing the ServletContext
     * that is being destroyed
     *
     * @implSpec
     * The default implementation takes no action.
     */
    default public void contextDestroyed(ServletContextEvent sce) {}
}
