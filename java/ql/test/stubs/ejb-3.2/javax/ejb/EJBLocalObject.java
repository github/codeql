/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 1997-2018 Oracle and/or its affiliates. All rights reserved.
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

/**
 * The EJBLocalObject interface must be extended by all enterprise beans' local
 * interfaces. An enterprise bean's local interface provides the local client 
 * view of an EJB object. An enterprise bean's local interface defines 
 * the business methods callable by local clients.
 *
 * <p> The enterprise bean's local interface is defined by the enterprise
 * bean provider and implemented by the enterprise bean container.
 * 
 * <p>
 * Enterprise beans written to the EJB 3.0 and later APIs do not require
 * a local interface that extends the EJBLocalObject interface.  A local
 * business interface can be used instead.
 *
 * @since EJB 2.0
 */
public interface EJBLocalObject {
    /**
     * Obtain the enterprise bean's local home interface. The local home
     * interface defines the enterprise bean's create, finder, remove,
     * and home business methods that are available to local clients.
     * 
     * @return A reference to the enterprise bean's local home interface.
     *
     * @exception EJBException Thrown when the method failed due to a
     *    system-level failure.
     *
     */
    public EJBLocalHome getEJBLocalHome() throws EJBException; 

    /**
     * Obtain the primary key of the EJB local object. 
     *
     * <p> This method can be called on an entity bean. 
     * An attempt to invoke this method on a session bean will result in
     * an EJBException.
     *
     * <p><b>Note:</b> Support for entity beans is optional as of EJB 3.2.
     *
     * @return The EJB local object's primary key.
     *
     * @exception EJBException Thrown when the method failed due to a
     *    system-level failure or when invoked on a session bean.
     *
     */
    public Object getPrimaryKey() throws EJBException;

    /**
     * Remove the EJB local object.
     *
     * @exception RemoveException The enterprise bean or the container
     *    does not allow destruction of the object.
     *
     * @exception EJBException Thrown when the method failed due to a
     *    system-level failure.
     *
     */ 
    public void remove() throws RemoveException, EJBException;

    /**
     * Test if a given EJB local object is identical to the invoked EJB 
     * local object.
     *
     * @param obj An object to test for identity with the invoked object.
     *
     * @return True if the given EJB local object is identical to the 
     * invoked object, false otherwise.
     *
     *
     * @exception EJBException Thrown when the method failed due to a
     *    system-level failure.
     *
     */
    boolean isIdentical(EJBLocalObject obj) throws EJBException;
} 
