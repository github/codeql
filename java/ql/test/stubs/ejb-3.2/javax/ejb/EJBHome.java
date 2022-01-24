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

import java.rmi.RemoteException;

/**
 * The EJBHome interface must be extended by all enterprise beans'
 * remote home interfaces. An enterprise bean's remote home interface
 * defines the methods that allow a remote client to create, find, and
 * remove EJB objects.
 *
 * <p> The remote home interface is defined by the enterprise bean provider and 
 * implemented by the enterprise bean container.
 * <p>
 * Enterprise beans written to the EJB 3.0 and later APIs do not require
 * a home interface.
 *
 * @since EJB 1.0
 */
public interface EJBHome extends java.rmi.Remote {

    /**
     * Remove an EJB object identified by its handle.
     *
     * @param handle the handle of the EJB object to be removed
     *
     * @exception RemoveException Thrown if the enterprise bean or
     *    the container does not allow the client to remove the object.
     *
     * @exception RemoteException Thrown when the method failed due to a
     *    system-level failure.
     */
    void remove(Handle handle) throws RemoteException, RemoveException;

    /**
     * Remove an EJB object identified by its primary key.
     *
     * <p>This method can be used only for an entity bean. An attempt
     * to call this method on a session bean will result in a RemoveException.
     *
     * <p><b>Note:</b> Support for entity beans is optional as of EJB 3.2.
     *
     * @param primaryKey the primary key of the EJB object to be removed
     *
     * @exception RemoveException Thrown if the enterprise bean or
     *    the container does not allow the client to remove the object.
     *
     * @exception RemoteException Thrown when the method failed due to a
     *    system-level failure.
     */
    void remove(Object primaryKey) throws RemoteException, RemoveException;

    /**
     * Obtain the EJBMetaData interface for the enterprise bean. The
     * EJBMetaData interface allows the client to obtain information about
     * the enterprise bean.
     *
     * <p> The information obtainable via the EJBMetaData interface is
     * intended to be used by tools.
     *
     * @return The enterprise Bean's EJBMetaData interface.
     *
     * @exception RemoteException Thrown when the method failed due to a
     *    system-level failure.
     */
    EJBMetaData getEJBMetaData() throws RemoteException;

    /**
     * Obtain a handle for the remote home object. The handle can be used at 
     * later time to re-obtain a reference to the remote home object, possibly 
     * in a different Java Virtual Machine.
     *
     * @return A handle for the remote home object.
     *
     * @exception RemoteException Thrown when the method failed due to a
     *    system-level failure. 
     *
     * @since EJB 1.1    
     */
    HomeHandle getHomeHandle() throws RemoteException;
}
