/*
 * Copyright (c) 2005, 2017, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */
/*
 * $Id: XMLSignatureFactory.java,v 1.14 2005/09/15 14:29:01 mullan Exp $
 */
package javax.xml.crypto.dsig;

import javax.xml.crypto.MarshalException;
import javax.xml.crypto.XMLStructure;
import javax.xml.crypto.dsig.dom.DOMValidateContext;

/**
 * A factory for creating {@link XMLSignature} objects from scratch or
 * for unmarshalling an <code>XMLSignature</code> object from a corresponding
 * XML representation.
 *
 * <h2>XMLSignatureFactory Type</h2>
 *
 * <p>Each instance of <code>XMLSignatureFactory</code> supports a specific
 * XML mechanism type. To create an <code>XMLSignatureFactory</code>, call one
 * of the static {@link #getInstance getInstance} methods, passing in the XML
 * mechanism type desired, for example:
 *
 * <blockquote><code>
 * XMLSignatureFactory factory = XMLSignatureFactory.getInstance("DOM");
 * </code></blockquote>
 *
 * <p>The objects that this factory produces will be based
 * on DOM and abide by the DOM interoperability requirements as defined in the
 * {@extLink security_guide_xmldsig_rqmts DOM Mechanism Requirements} section
 * of the API overview. See the
 * {@extLink security_guide_xmldsig_provider Service Providers} section of
 * the API overview for a list of standard mechanism types.
 *
 * <p><code>XMLSignatureFactory</code> implementations are registered and loaded
 * using the {@link java.security.Provider} mechanism.
 * For example, a service provider that supports the
 * DOM mechanism would be specified in the <code>Provider</code> subclass as:
 * <pre>
 *     put("XMLSignatureFactory.DOM", "org.example.DOMXMLSignatureFactory");
 * </pre>
 *
 * <p>An implementation MUST minimally support the default mechanism type: DOM.
 *
 * <p>Note that a caller must use the same <code>XMLSignatureFactory</code>
 * instance to create the <code>XMLStructure</code>s of a particular
 * <code>XMLSignature</code> that is to be generated. The behavior is
 * undefined if <code>XMLStructure</code>s from different providers or
 * different mechanism types are used together.
 *
 * <p>Also, the <code>XMLStructure</code>s that are created by this factory
 * may contain state specific to the <code>XMLSignature</code> and are not
 * intended to be reusable.
 *
 * <h2>Creating XMLSignatures from scratch</h2>
 *
 * <p>Once the <code>XMLSignatureFactory</code> has been created, objects
 * can be instantiated by calling the appropriate method. For example, a
 * {@link Reference} instance may be created by invoking one of the
 * {@link #newReference newReference} methods.
 *
 * <h2>Unmarshalling XMLSignatures from XML</h2>
 *
 * <p>Alternatively, an <code>XMLSignature</code> may be created from an
 * existing XML representation by invoking the {@link #unmarshalXMLSignature
 * unmarshalXMLSignature} method and passing it a mechanism-specific
 * {@link XMLValidateContext} instance containing the XML content:
 *
 * <pre>
 * DOMValidateContext context = new DOMValidateContext(key, signatureElement);
 * XMLSignature signature = factory.unmarshalXMLSignature(context);
 * </pre>
 *
 * Each <code>XMLSignatureFactory</code> must support the required
 * <code>XMLValidateContext</code> types for that factory type, but may support
 * others. A DOM <code>XMLSignatureFactory</code> must support {@link
 * DOMValidateContext} objects.
 *
 * <h2>Signing and marshalling XMLSignatures to XML</h2>
 *
 * Each <code>XMLSignature</code> created by the factory can also be
 * marshalled to an XML representation and signed, by invoking the
 * {@link XMLSignature#sign sign} method of the
 * {@link XMLSignature} object and passing it a mechanism-specific
 * {@link XMLSignContext} object containing the signing key and
 * marshalling parameters (see {@link DOMSignContext}).
 * For example:
 *
 * <pre>
 *    DOMSignContext context = new DOMSignContext(privateKey, document);
 *    signature.sign(context);
 * </pre>
 *
 * <b>Concurrent Access</b>
 * <p>The static methods of this class are guaranteed to be thread-safe.
 * Multiple threads may concurrently invoke the static methods defined in this
 * class with no ill effects.
 *
 * <p>However, this is not true for the non-static methods defined by this
 * class. Unless otherwise documented by a specific provider, threads that
 * need to access a single <code>XMLSignatureFactory</code> instance
 * concurrently should synchronize amongst themselves and provide the
 * necessary locking. Multiple threads each manipulating a different
 * <code>XMLSignatureFactory</code> instance need not synchronize.
 *
 * @author Sean Mullan
 * @author JSR 105 Expert Group
 * @since 1.6
 */
public abstract class XMLSignatureFactory {
    /**
     * Default constructor, for invocation by subclasses.
     */
    protected XMLSignatureFactory() {}

    /**
     * Returns an <code>XMLSignatureFactory</code> that supports the
     * specified XML processing mechanism and representation type (ex: "DOM").
     *
     * <p>This method uses the standard JCA provider lookup mechanism to
     * locate and instantiate an <code>XMLSignatureFactory</code>
     * implementation of the desired mechanism type. It traverses the list of
     * registered security <code>Provider</code>s, starting with the most
     * preferred <code>Provider</code>.  A new <code>XMLSignatureFactory</code>
     * object from the first <code>Provider</code> that supports the specified
     * mechanism is returned.
     *
     * <p>Note that the list of registered providers may be retrieved via
     * the {@link Security#getProviders() Security.getProviders()} method.
     *
     * @implNote
     * The JDK Reference Implementation additionally uses the
     * {@code jdk.security.provider.preferred}
     * {@link Security#getProperty(String) Security} property to determine
     * the preferred provider order for the specified algorithm. This
     * may be different than the order of providers returned by
     * {@link Security#getProviders() Security.getProviders()}.
     *
     * @param mechanismType the type of the XML processing mechanism and
     *    representation. See the {@extLink security_guide_xmldsig_provider
     *    Service Providers} section of the API overview for a list of
     *    standard mechanism types.
     * @return a new <code>XMLSignatureFactory</code>
     * @throws NullPointerException if <code>mechanismType</code> is
     *    <code>null</code>
     * @throws NoSuchMechanismException if no <code>Provider</code> supports an
     *    <code>XMLSignatureFactory</code> implementation for the specified
     *    mechanism
     * @see Provider
     */
    public static XMLSignatureFactory getInstance(String mechanismType) {
        return null;
    }

    /**
     * Returns an <code>XMLSignatureFactory</code> that supports the
     * default XML processing mechanism and representation type ("DOM").
     *
     * <p>This method uses the standard JCA provider lookup mechanism to
     * locate and instantiate an <code>XMLSignatureFactory</code>
     * implementation of the default mechanism type. It traverses the list of
     * registered security <code>Provider</code>s, starting with the most
     * preferred <code>Provider</code>.  A new <code>XMLSignatureFactory</code>
     * object from the first <code>Provider</code> that supports the DOM
     * mechanism is returned.
     *
     * <p>Note that the list of registered providers may be retrieved via
     * the {@link Security#getProviders() Security.getProviders()} method.
     *
     * @return a new <code>XMLSignatureFactory</code>
     * @throws NoSuchMechanismException if no <code>Provider</code> supports an
     *    <code>XMLSignatureFactory</code> implementation for the DOM
     *    mechanism
     * @see Provider
     */
    public static XMLSignatureFactory getInstance() {
        return null;
    }

    /**
     * Unmarshals a new <code>XMLSignature</code> instance from a
     * mechanism-specific <code>XMLValidateContext</code> instance.
     *
     * @param context a mechanism-specific context from which to unmarshal the
     *    signature from
     * @return the <code>XMLSignature</code>
     * @throws NullPointerException if <code>context</code> is
     *    <code>null</code>
     * @throws ClassCastException if the type of <code>context</code> is
     *    inappropriate for this factory
     * @throws MarshalException if an unrecoverable exception occurs
     *    during unmarshalling
     */
    public abstract XMLSignature unmarshalXMLSignature
        (XMLValidateContext context) throws MarshalException;

    /**
     * Unmarshals a new <code>XMLSignature</code> instance from a
     * mechanism-specific <code>XMLStructure</code> instance.
     * This method is useful if you only want to unmarshal (and not
     * validate) an <code>XMLSignature</code>.
     *
     * @param xmlStructure a mechanism-specific XML structure from which to
     *    unmarshal the signature from
     * @return the <code>XMLSignature</code>
     * @throws NullPointerException if <code>xmlStructure</code> is
     *    <code>null</code>
     * @throws ClassCastException if the type of <code>xmlStructure</code> is
     *    inappropriate for this factory
     * @throws MarshalException if an unrecoverable exception occurs
     *    during unmarshalling
     */
    public abstract XMLSignature unmarshalXMLSignature
        (XMLStructure xmlStructure) throws MarshalException;
}
