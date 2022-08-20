/*
 * Copyright (c) 1997, 2018 Oracle and/or its affiliates. All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0, which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary
 * Licenses when the conditions for such availability set forth in the
 * Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
 * version 2 with the GNU Classpath Exception, which is available at
 * https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 */

package javax.faces.context;


import javax.faces.component.UIComponent;
import java.io.IOException;
import java.io.Writer;


/**
 * <p><span
 * class="changed_modified_2_2"><strong>ResponseWriter</strong></span>
 * is an abstract class describing an adapter to an underlying output
 * mechanism for character-based output.  In addition to the low-level
 * <code>write()</code> methods inherited from
 * <code>java.io.Writer</code>, this class provides utility methods that
 * are useful in producing elements and attributes for markup languages
 * like HTML and XML.</p>
 */

public abstract class ResponseWriter extends Writer {


    /**
     * <p>Return the content type (such as "text/html") for this {@link
     * ResponseWriter}.  Note: this must not include the "charset="
     * suffix.</p>
     *
     * @return the content type
     */
    public abstract String getContentType();


    /**
     * <p>Return the character encoding (such as "ISO-8859-1") for this
     * {@link ResponseWriter}.  Please see <a
     * href="http://www.iana.org/assignments/character-sets">the
     * IANA</a> for a list of character encodings.</p>
     *
     * @return the character encoding
     */
    public abstract String getCharacterEncoding();


    /**
     * <p>Flush any ouput buffered by the output method to the
     * underlying Writer or OutputStream.  This method
     * will not flush the underlying Writer or OutputStream;  it
     * simply clears any values buffered by this {@link ResponseWriter}.</p>
     */
    @Override
    public abstract void flush() throws IOException;


    /**
     * <p>Write whatever text should begin a response.</p>
     *
     * @throws IOException if an input/output error occurs
     */
    public abstract void startDocument() throws IOException;


    /**
     * <p>Write whatever text should end a response.  If there is an open
     * element that has been created by a call to <code>startElement()</code>,
     * that element will be closed first.</p>
     *
     * @throws IOException if an input/output error occurs
     */
    public abstract void endDocument() throws IOException;


    /**
     * <p><span class="changed_modified_2_2">Write</span> the start of an element, 
       up to and including the
     * element name.  Once this method has been called, clients can
     * call the <code>writeAttribute()</code> or
     * <code>writeURIAttribute()</code> methods to add attributes and
     * corresponding values.  The starting element will be closed
     * (that is, the trailing '&gt;' character added)
     * on any subsequent call to <code>startElement()</code>,
     * <code>writeComment()</code>,
     * <code>writeText()</code>, <code>endElement()</code>,
     * <code>endDocument()</code>, <code>close()</code>,
     * <code>flush()</code>, or <code>write()</code>.</p>
     * 
     * <div class="changed_added_2_2">
     * 
     * <p>If the argument component's pass through attributes 
     * includes an attribute of the name given by the value of the symbolic
     * constant {@link javax.faces.render.Renderer#PASSTHROUGH_RENDERER_LOCALNAME_KEY},
     * use that as the element name, instead of the value passed as the first 
     * parameter to this method.  Care must be taken so that this value
     * is not also rendered when any other pass through attributes on this component
     * are rendered.</p>
     * 
     * </div>
     *
     * @param name      Name of the element to be started

     * @param component The {@link UIComponent} (if any) to which this
     *                  element corresponds.  <span
     *                  class="changed_added_2_2"> This component is
     *                  inspected for its pass through attributes as
     *                  described in the standard HTML_BASIC {@code
     *                  RenderKit} specification.</span>

     * @throws IOException          if an input/output error occurs
     * @throws NullPointerException if <code>name</code>
     *                              is <code>null</code>
     */
    public abstract void startElement(String name, UIComponent component)
            throws IOException;


    /**
     * <p><span class="changed_modified_2_2">Write</span> the end of an element, 
     * after closing any open element
     * created by a call to <code>startElement()</code>.  Elements must be
     * closed in the inverse order from which they were opened; it is an
     * error to do otherwise.</p>
     *
     * <div class="changed_added_2_2">
     * 
     * <p>If the argument component's pass through attributes 
     * includes an attribute of the name given by the value of the symbolic
     * constant {@link javax.faces.render.Renderer#PASSTHROUGH_RENDERER_LOCALNAME_KEY},
     * use that as the element name, instead of the value passed as the first 
     * parameter to this method.</p>
     * 
     * </div>
     *
     * @param name Name of the element to be ended
     * @throws IOException          if an input/output error occurs
     * @throws NullPointerException if <code>name</code>
     *                              is <code>null</code>
     */
    public abstract void endElement(String name) throws IOException;


    /**
     * <p>Write an attribute name and corresponding value, after converting
     * that text to a String (if necessary), and after performing any escaping
     * appropriate for the markup language being rendered.
     * This method may only be called after a call to
     * <code>startElement()</code>, and before the opened element has been
     * closed.</p>
     *
     * @param name     Attribute name to be added
     * @param value    Attribute value to be added
     * @param property Name of the property or attribute (if any) of the
     *                 {@link UIComponent} associated with the containing element,
     *                 to which this generated attribute corresponds
     * @throws IllegalStateException if this method is called when there
     *                               is no currently open element
     * @throws IOException           if an input/output error occurs
     * @throws NullPointerException  if <code>name</code> is
     *                               <code>null</code>
     */
    public abstract void writeAttribute(String name, Object value,
                                        String property)
            throws IOException;


    /**
     * <p><span class="changed_modified_2_2">Write</span> a URI
     * attribute name and corresponding value, after converting that
     * text to a String (if necessary), and after performing any
     * encoding <span class="changed_modified_2_2">or escaping</span>
     * appropriate to the markup language being rendered.  <span
     * class="changed_modified_2_2">When rendering in a WWW environment,
     * the escaping conventions established in the W3C URI spec document
     * &lt;<a
     * href="http://www.w3.org/Addressing/URL/uri-spec.html">http://www.w3.org/Addressing/URL/uri-spec.html</a>&gt;
     * must be followed.  In particular, spaces ' ' must be encoded as
     * %20 and not the plus character '+'.</span> This method may only
     * be called after a call to <code>startElement()</code>, and before
     * the opened element has been closed.</p>
     *
     * @param name     Attribute name to be added
     * @param value    Attribute value to be added
     * @param property Name of the property or attribute (if any) of the
     *                 {@link UIComponent} associated with the containing element,
     *                 to which this generated attribute corresponds
     * @throws IllegalStateException if this method is called when there
     *                               is no currently open element
     * @throws IOException           if an input/output error occurs
     * @throws NullPointerException  if <code>name</code> is
     *                               <code>null</code>
     */
    public abstract void writeURIAttribute(String name, Object value,
                                           String property)
            throws IOException;

    /**
     * <p class="changed_added_2_0">Open an XML <code>CDATA</code>
     * block.  Note that XML does not allow nested <code>CDATA</code>
     * blocks, though this method does not enforce that constraint.  The
     * default implementation of this method takes no action when
     * invoked.</p>
     * @throws IOException if input/output error occures
     */
    public void startCDATA() throws IOException {

    }


    /**

     * <p class="changed_added_2_0">Close an XML <code>CDATA</code>
     * block.  The default implementation of this method takes no action
     * when invoked.</p>

     * @throws IOException if input/output error occures
     */
    public void endCDATA() throws IOException {
        throw new UnsupportedOperationException();
    }


    /**
     * <p>Write a comment containing the specified text, after converting
     * that text to a String (if necessary), and after performing any escaping
     * appropriate for the markup language being rendered.  If there is
     * an open element that has been created by a call to
     * <code>startElement()</code>, that element will be closed first.</p>
     *
     * @param comment Text content of the comment
     * @throws IOException          if an input/output error occurs
     * @throws NullPointerException if <code>comment</code>
     *                              is <code>null</code>
     */
    public abstract void writeComment(Object comment) throws IOException;
    
    
    /**
     * <p class="changed_added_2_2">Write a string containing the markup specific
     * preamble.
     * No escaping is performed. The default 
     * implementation simply calls through to {@link #write(java.lang.String)} .</p>
     * 
     * <div class="changed_added_2_2">
     * 
     * <p>The implementation makes no checks if this is the correct place
     * in the response to have a preamble, nor does it prevent the preamble
     * from being written more than once.</p>
     * 
     * </div>
     * 
     * @since 2.2
     * @param preamble Text content of the preamble
     * @throws IOException if an input/output error occurs
     */
    public void writePreamble(String preamble) throws IOException {
        write(preamble);
    }

    /**
     * <p class="changed_added_2_2">Write a string containing the markup specific
     * doctype.
     * No escaping is performed. The default 
     * implementation simply calls through to {@link #write(java.lang.String)} .</p>
     * 
     * <div class="changed_added_2_2">
     * 
     * <p>The implementation makes no checks if this is the correct place
     * in the response to have a doctype, nor does it prevent the doctype
     * from being written more than once.</p>
     * 
     * </div>
     * 
     * @since 2.2
     * @param doctype Text content of the doctype
     * @throws IOException if an input/output error occurs
     */
    public void writeDoctype(String doctype) throws IOException {
        write(doctype);
    }


    /**
     * <p>Write an object, after converting it to a String (if necessary),
     * and after performing any escaping appropriate for the markup language
     * being rendered.  If there is an open element that has been created
     * by a call to <code>startElement()</code>, that element will be closed
     * first.</p>
     *
     * @param text     Text to be written
     * @param property Name of the property or attribute (if any) of the
     *                 {@link UIComponent} associated with the containing element,
     *                 to which this generated text corresponds
     * @throws IOException          if an input/output error occurs
     * @throws NullPointerException if <code>text</code>
     *                              is <code>null</code>
     */
    public abstract void writeText(Object text, String property)
            throws IOException;

    /**
     * <p>Write an object, after converting it to a String (if
     * necessary), and after performing any escaping appropriate for the
     * markup language being rendered.  This method is equivalent to
     * {@link #writeText(java.lang.Object,java.lang.String)} but adds a
     * <code>component</code> property to allow custom
     * <code>ResponseWriter</code> implementations to associate a
     * component with an arbitrary portion of text.</p>
     * 
     * <p>The default implementation simply ignores the
     * <code>component</code> argument and calls through to {@link
     * #writeText(java.lang.Object,java.lang.String)}</p>
     *
     * @param text      Text to be written
     * @param component The {@link UIComponent} (if any) to which
     *                  this element corresponds
     * @param property  Name of the property or attribute (if any) of the
     *                  {@link UIComponent} associated with the containing element,
     *                  to which this generated text corresponds
     * @throws IOException          if an input/output error occurs
     * @throws NullPointerException if <code>text</code>
     *                              is <code>null</code>
     * @since 1.2
     */
    public void writeText(Object text, UIComponent component, String property)
            throws IOException {
        writeText(text, property);
    }


    /**
     * <p>Write text from a character array, after any performing any
     * escaping appropriate for the markup language being rendered.
     * If there is an open element that has been created by a call to
     * <code>startElement()</code>, that element will be closed first.</p>
     *
     * @param text Text to be written
     * @param off  Starting offset (zero-relative)
     * @param len  Number of characters to be written
     * @throws IndexOutOfBoundsException if the calculated starting or
     *                                   ending position is outside the bounds of the character array
     * @throws IOException               if an input/output error occurs
     * @throws NullPointerException      if <code>text</code>
     *                                   is <code>null</code>
     */
    public abstract void writeText(char text[], int off, int len)
            throws IOException;


    /**
     * <p>Create and return a new instance of this {@link ResponseWriter},
     * using the specified <code>Writer</code> as the output destination.</p>
     *
     * @param writer The <code>Writer</code> that is the output destination
     *
     * @return the new <code>ResponseWriter</code>
     */
    public abstract ResponseWriter cloneWithWriter(Writer writer);
}
