/*
 * Copyright (c) 2005, 2014, Oracle and/or its affiliates. All rights reserved.
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
 * ===========================================================================
 *
 * (C) Copyright IBM Corp. 2003 All Rights Reserved.
 *
 * ===========================================================================
 */
/*
 * $Id: XMLSignature.java,v 1.10 2005/05/10 16:03:48 mullan Exp $
 */
package javax.xml.crypto.dsig;

import javax.xml.crypto.MarshalException;
import javax.xml.crypto.XMLStructure;

/**
 * A representation of the XML <code>Signature</code> element as
 * defined in the <a href="http://www.w3.org/TR/xmldsig-core/">
 * W3C Recommendation for XML-Signature Syntax and Processing</a>.
 * This class contains methods for signing and validating XML signatures
 * with behavior as defined by the W3C specification. The XML Schema Definition
 * is defined as:
 * <pre><code>
 * &lt;element name="Signature" type="ds:SignatureType"/&gt;
 * &lt;complexType name="SignatureType"&gt;
 *    &lt;sequence&gt;
 *      &lt;element ref="ds:SignedInfo"/&gt;
 *      &lt;element ref="ds:SignatureValue"/&gt;
 *      &lt;element ref="ds:KeyInfo" minOccurs="0"/&gt;
 *      &lt;element ref="ds:Object" minOccurs="0" maxOccurs="unbounded"/&gt;
 *    &lt;/sequence&gt;
 *    &lt;attribute name="Id" type="ID" use="optional"/&gt;
 * &lt;/complexType&gt;
 * </code></pre>
 * <p>
 * An <code>XMLSignature</code> instance may be created by invoking one of the
 * {@link XMLSignatureFactory#newXMLSignature newXMLSignature} methods of the
 * {@link XMLSignatureFactory} class.
 *
 * <p>If the contents of the underlying document containing the
 * <code>XMLSignature</code> are subsequently modified, the behavior is
 * undefined.
 *
 * <p>Note that this class is named <code>XMLSignature</code> rather than
 * <code>Signature</code> to avoid naming clashes with the existing
 * {@link Signature java.security.Signature} class.
 *
 * @see XMLSignatureFactory#newXMLSignature(SignedInfo, KeyInfo)
 * @see XMLSignatureFactory#newXMLSignature(SignedInfo, KeyInfo, List, String, String)
 * @author Joyce L. Leung
 * @author Sean Mullan
 * @author Erwin van der Koogh
 * @author JSR 105 Expert Group
 * @since 1.6
 */
public interface XMLSignature extends XMLStructure {

    /**
     * The XML Namespace URI of the W3C Recommendation for XML-Signature
     * Syntax and Processing.
     */
    final static String XMLNS = "http://www.w3.org/2000/09/xmldsig#";

    /**
     * Validates the signature according to the
     * <a href="http://www.w3.org/TR/xmldsig-core/#sec-CoreValidation">
     * core validation processing rules</a>. This method validates the
     * signature using the existing state, it does not unmarshal and
     * reinitialize the contents of the <code>XMLSignature</code> using the
     * location information specified in the context.
     *
     * <p>This method only validates the signature the first time it is
     * invoked. On subsequent invocations, it returns a cached result.
     *
     * @param validateContext the validating context
     * @return <code>true</code> if the signature passed core validation,
     *    otherwise <code>false</code>
     * @throws ClassCastException if the type of <code>validateContext</code>
     *    is not compatible with this <code>XMLSignature</code>
     * @throws NullPointerException if <code>validateContext</code> is
     *    <code>null</code>
     * @throws XMLSignatureException if an unexpected error occurs during
     *    validation that prevented the validation operation from completing
     */
    boolean validate(XMLValidateContext validateContext)
        throws XMLSignatureException;
}
