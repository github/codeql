/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 2006-2018 Oracle and/or its affiliates. All rights reserved.
 *
 * The contents of this file are subject to the terms of either the GNU
 * General Public License Version 2 only ("GPL") or the Common Development
 * and Distribution License("CDDL") (collectively, the "License").  You
 * may not use this file except in compliance with the License.  You can
 * obtain a copy of the License at
 * https://oss.oracle.com/licenses/CDDL+GPL-1.1
 * or LICENSE.txt.  See the License for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing the software, include this License Header Notice in each
 * file and include the License file at LICENSE.txt.
 *
 * GPL Classpath Exception:
 * Oracle designates this particular file as subject to the "Classpath"
 * exception as provided by Oracle in the GPL Version 2 section of the License
 * file that accompanied this code.
 *
 * Modifications:
 * If applicable, add the following below the License Header, with the fields
 * enclosed by brackets [] replaced by your own identifying information:
 * "Portions Copyright [year] [name of copyright owner]"
 *
 * Contributor(s):
 * If you wish your version of this file to be governed by only the CDDL or
 * only the GPL Version 2, indicate your decision by adding "[Contributor]
 * elects to include this software in this distribution under the [CDDL or GPL
 * Version 2] license."  If you don't indicate a single choice of license, a
 * recipient has the option to distribute your version of this file under
 * either the CDDL, the GPL Version 2 or to extend the choice of license to
 * its licensees as provided above.  However, if you add GPL Version 2 code
 * and therefore, elected the GPL Version 2 license, then the option applies
 * only if the new code is made subject to such option by the copyright
 * holder.
 */

package javax.ejb;

import java.util.*;
import java.security.Identity;
//import javax.xml.rpc.handler.MessageContext;

/**
 * The SessionContext interface provides access to the runtime session context 
 * that the container provides for a session bean instance. The 
 * container passes the SessionContext interface to an instance after the 
 * instance has been created. The session context remains associated with 
 * the instance for the lifetime of the instance.
 *
 * @since EJB 1.0
 */
public interface SessionContext extends EJBContext
{
    /**
     * Obtain a reference to the EJB local object that is  
     * associated with the instance.
     *
     * <p> An instance of a session bean can call this method at
     * anytime between the <code>PostConstruct</code> or
     * <code>ejbCreate</code> and <code>PreDestroy</code> or
     * <code>ejbRemove</code> methods, including from within these
     * methods.
     *
     * <p> An instance can use this method, for example, when it wants to
     * pass a reference to itself in a method argument or result.
     *
     * @return The EJB local object currently associated with the instance.
     *
     * @exception IllegalStateException Thrown if the instance invokes this
     *    method while the instance is in a state that does not allow the
     *    instance to invoke this method, or if the instance does not have
     *    a local interface.
     *
     * @since EJB 2.0
     */
    EJBLocalObject getEJBLocalObject() throws IllegalStateException;

    /**
     * Obtain a reference to the EJB object that is currently associated with 
     * the instance.
     *
     * <p> An instance of a session enterprise Bean can call this
     * method at anytime between the <code>PostConstruct</code> or
     * <code>ejbCreate</code> and the <code>PreDestroy</code> or
     * <code>ejbRemove</code> methods, including from within these
     * methods.
     *
     * <p> An instance can use this method, for example, when it wants to
     * pass a reference to itself in a method argument or result.
     *
     * @return The EJB object currently associated with the instance.
     *
     * @exception IllegalStateException Thrown if the instance invokes this
     *    method while the instance is in a state that does not allow the
     *    instance to invoke this method, or if the instance does not have
     *    a remote interface.
     */
    EJBObject getEJBObject() throws IllegalStateException;

    /**
     * Obtain a reference to the JAX-RPC MessageContext. 
     *
     * <p> An instance of a stateless session bean can call this method
     * from any business method invoked through its web service
     * endpoint interface.
     *
     * <p><b>Note:</b> Support for web services invocations using JAX-RPC is optional as of EJB 3.2
     *
     * @return The MessageContext for this web service invocation.
     *
     * @exception IllegalStateException Thrown if this method is invoked
     *    while the instance is in a state that does not allow access
     *    to this method.
     *
     * @since EJB 2.1
     */
    //MessageContext getMessageContext() throws IllegalStateException;

    /**
     * Obtain an object that can be used to invoke the current bean through
     * a particular business interface view or its no-interface view.
     *
     * @param businessInterface One of the local business interfaces 
     *        or remote business interfaces for this session bean. 
     *        In addition, the bean class type can be used to acquire 
     *        a reference to the bean's no-interface view.
     *
     * @return The business object corresponding to the given business 
     *         interface or no-interface view.
     *
     * @exception IllegalStateException Thrown if invoked with a parameter
     *         that does not correspond to one of the beans' business interfaces
     *         or no-interface view.
     *     
     * @since EJB 3.0    
     */
    <T> T getBusinessObject(Class<T> businessInterface) throws IllegalStateException;

    /**
     * Obtain the business interface or no-interface view type through which the 
     * current business method invocation was made. 
     *
     * @exception IllegalStateException Thrown if this method is called
     *       and the bean has not been invoked through a business interface or 
     *       no-interface view.
     *
     * @since EJB 3.0
     */
    Class getInvokedBusinessInterface() throws IllegalStateException;

    /**
     * Check whether a client invoked the <code>cancel</code> method on the
     * client <code>Future</code> object corresponding to the currently executing
     * asynchronous business method.
     *
     * @return true if the client has invoked <code>Future.cancel</code> with a value of
     *    true for the <code>mayInterruptIfRunning</code> parameter. 
     *
     * @exception IllegalStateException Thrown if not invoked from within an 
     *         asynchronous business method invocation with return type
     *        <code>Future&#060;V&#062;</code>.
     *  
     * @since EJB 3.1       
     */    
     boolean wasCancelCalled() throws IllegalStateException;

}
