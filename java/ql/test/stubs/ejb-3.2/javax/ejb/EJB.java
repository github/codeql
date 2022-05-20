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

import java.lang.annotation.Target;
import static java.lang.annotation.ElementType.*;
import java.lang.annotation.Retention;
import static java.lang.annotation.RetentionPolicy.*;

/**
 * Indicates a dependency on the local, no-interface, or remote view of an Enterprise
 * JavaBean.
 * <p>
 * Either the <code>beanName</code> or the <code>lookup</code> element can 
 * be used to resolve the EJB dependency to its target session bean component.  
 * It is an error to specify values for both <code>beanName</code> and 
 * <code>lookup</code>.
 * <p>
 * If no explicit linking information is provided and there is only one session
 * bean within the same application that exposes the matching client view type,
 * by default the EJB dependency resolves to that session bean.
 *
 * @since EJB 3.0
 */

@Target({TYPE, METHOD, FIELD})
@Retention(RUNTIME)
public @interface EJB {

    /**
     * The logical name of the ejb reference within the declaring component's
     * (e.g., java:comp/env) environment.
     */
    String name() default "";

    /**
     * A string describing the bean.
     */
    String description() default "";

    /**
     * The <code>beanName</code> element references the value of the <code>name</code> 
     * element of the <code>Stateful</code> or <code>Stateless</code> annotation, 
     * whether defaulted or explicit. If the deployment descriptor was used to define 
     * the name of the bean, the <code>beanName</code> element references the 
     * <code>ejb-name</code> element of the bean definition.
     * <p>
     * The <code>beanName</code> element allows disambiguation if multiple session 
     * beans in the ejb-jar implement the same interface. 
     * <p>
     * In order to reference a bean in another ejb-jar file in the same application, 
     * the <code>beanName</code> may be composed of a path name specifying the ejb-jar 
     * containing the referenced bean with the bean name of the target bean appended and 
     * separated from the path name by &#35;. The path name is relative to the jar file 
     * containing the component that is referencing the target bean.
     * <p>
     * Only applicable if the target EJB is defined within the 
     * same application or stand-alone module as the declaring component.
     */
    String beanName() default "";

    /**
     * The interface type of the Enterprise Java Bean to which this reference
     * is mapped.
     * <p>
     * Holds one of the following types of the target EJB :
     * <ul>
     * <li> Local business interface
     * <li> Bean class (for no-interface view)
     * <li> Remote business interface
     * <li> Local Home interface
     * <li> Remote Home interface
     * </ul>
     */
    Class beanInterface() default Object.class;

    /**
     * The product specific name of the EJB component to which this
     * ejb reference should be mapped.  This mapped name is often a
     * global JNDI name, but may be a name of any form. 
     * <p>
     * Application servers are not required to support any particular 
     * form or type of mapped name, nor the ability to use mapped names. 
     * The mapped name is product-dependent and often installation-dependent. 
     * No use of a mapped name is portable. 
     */ 
    String mappedName() default "";

    /**
     * A portable lookup string containing the JNDI name for the target EJB component. 
     *
     * @since EJB 3.1
     */ 
    String lookup() default "";
}
