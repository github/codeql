/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// API class

package org.mozilla.javascript;

/**
 * This is interface that all objects in JavaScript must implement.
 * The interface provides for the management of properties and for
 * performing conversions.
 * <p>
 * Host system implementors may find it easier to extend the ScriptableObject
 * class rather than implementing Scriptable when writing host objects.
 * <p>
 * There are many static methods defined in ScriptableObject that perform
 * the multiple calls to the Scriptable interface needed in order to
 * manipulate properties in prototype chains.
 * <p>
 *
 * @see org.mozilla.javascript.ScriptableObject
 * @author Norris Boyd
 * @author Nick Thompson
 * @author Brendan Eich
 */

public interface Scriptable {

    /**
     * Get the name of the set of objects implemented by this Java class.
     * This corresponds to the [[Class]] operation in ECMA and is used
     * by Object.prototype.toString() in ECMA.<p>
     * See ECMA 8.6.2 and 15.2.4.2.
     */
    public String getClassName();

    /**
     * Get a named property from the object.
     *
     * Looks property up in this object and returns the associated value
     * if found. Returns NOT_FOUND if not found.
     * Note that this method is not expected to traverse the prototype
     * chain. This is different from the ECMA [[Get]] operation.
     *
     * Depending on the property selector, the runtime will call
     * this method or the form of <code>get</code> that takes an
     * integer:
     * <table>
     * <tr><th>JavaScript code</th><th>Java code</th></tr>
     * <tr><td>a.b      </td><td>a.get("b", a)</td></tr>
     * <tr><td>a["foo"] </td><td>a.get("foo", a)</td></tr>
     * <tr><td>a[3]     </td><td>a.get(3, a)</td></tr>
     * <tr><td>a["3"]   </td><td>a.get(3, a)</td></tr>
     * <tr><td>a[3.0]   </td><td>a.get(3, a)</td></tr>
     * <tr><td>a["3.0"] </td><td>a.get("3.0", a)</td></tr>
     * <tr><td>a[1.1]   </td><td>a.get("1.1", a)</td></tr>
     * <tr><td>a[-4]    </td><td>a.get(-4, a)</td></tr>
     * </table>
     * <p>
     * The values that may be returned are limited to the following:
     * <UL>
     * <LI>java.lang.Boolean objects</LI>
     * <LI>java.lang.String objects</LI>
     * <LI>java.lang.Number objects</LI>
     * <LI>org.mozilla.javascript.Scriptable objects</LI>
     * <LI>null</LI>
     * <LI>The value returned by Context.getUndefinedValue()</LI>
     * <LI>NOT_FOUND</LI>
     * </UL>
     * @param name the name of the property
     * @param start the object in which the lookup began
     * @return the value of the property (may be null), or NOT_FOUND
     * @see org.mozilla.javascript.Context#getUndefinedValue
     */
    public Object get(String name, Scriptable start);

    /**
     * Get a property from the object selected by an integral index.
     *
     * Identical to <code>get(String, Scriptable)</code> except that
     * an integral index is used to select the property.
     *
     * @param index the numeric index for the property
     * @param start the object in which the lookup began
     * @return the value of the property (may be null), or NOT_FOUND
     * @see org.mozilla.javascript.Scriptable#get(String,Scriptable)
     */
    public Object get(int index, Scriptable start);

    /**
     * Indicates whether or not a named property is defined in an object.
     *
     * Does not traverse the prototype chain.<p>
     *
     * The property is specified by a String name
     * as defined for the <code>get</code> method.<p>
     *
     * @param name the name of the property
     * @param start the object in which the lookup began
     * @return true if and only if the named property is found in the object
     * @see org.mozilla.javascript.Scriptable#get(String, Scriptable)
     * @see org.mozilla.javascript.ScriptableObject#getProperty(Scriptable, String)
     */
    public boolean has(String name, Scriptable start);

    /**
     * Indicates whether or not an indexed  property is defined in an object.
     *
     * Does not traverse the prototype chain.<p>
     *
     * The property is specified by an integral index
     * as defined for the <code>get</code> method.<p>
     *
     * @param index the numeric index for the property
     * @param start the object in which the lookup began
     * @return true if and only if the indexed property is found in the object
     * @see org.mozilla.javascript.Scriptable#get(int, Scriptable)
     * @see org.mozilla.javascript.ScriptableObject#getProperty(Scriptable, int)
     */
    public boolean has(int index, Scriptable start);

    /**
     * Sets a named property in this object.
     * <p>
     * The property is specified by a string name
     * as defined for <code>get</code>.
     * <p>
     * The possible values that may be passed in are as defined for
     * <code>get</code>. A class that implements this method may choose
     * to ignore calls to set certain properties, in which case those
     * properties are effectively read-only.<p>
     * For properties defined in a prototype chain,
     * use <code>putProperty</code> in ScriptableObject. <p>
     * Note that if a property <i>a</i> is defined in the prototype <i>p</i>
     * of an object <i>o</i>, then evaluating <code>o.a = 23</code> will cause
     * <code>set</code> to be called on the prototype <i>p</i> with
     * <i>o</i> as the  <i>start</i> parameter.
     * To preserve JavaScript semantics, it is the Scriptable
     * object's responsibility to modify <i>o</i>. <p>
     * This design allows properties to be defined in prototypes and implemented
     * in terms of getters and setters of Java values without consuming slots
     * in each instance.
     * <p>
     * The values that may be set are limited to the following:
     * <UL>
     * <LI>java.lang.Boolean objects</LI>
     * <LI>java.lang.String objects</LI>
     * <LI>java.lang.Number objects</LI>
     * <LI>org.mozilla.javascript.Scriptable objects</LI>
     * <LI>null</LI>
     * <LI>The value returned by Context.getUndefinedValue()</LI>
     * </UL><p>
     * Arbitrary Java objects may be wrapped in a Scriptable by first calling
     * <code>Context.toObject</code>. This allows the property of a JavaScript
     * object to contain an arbitrary Java object as a value.<p>
     * Note that <code>has</code> will be called by the runtime first before
     * <code>set</code> is called to determine in which object the
     * property is defined.
     * Note that this method is not expected to traverse the prototype chain,
     * which is different from the ECMA [[Put]] operation.
     * @param name the name of the property
     * @param start the object whose property is being set
     * @param value value to set the property to
     * @see org.mozilla.javascript.Scriptable#has(String, Scriptable)
     * @see org.mozilla.javascript.Scriptable#get(String, Scriptable)
     * @see org.mozilla.javascript.ScriptableObject#putProperty(Scriptable, String, Object)
     * @see org.mozilla.javascript.Context#toObject(Object, Scriptable)
     */
    public void put(String name, Scriptable start, Object value);

    /**
     * Sets an indexed property in this object.
     * <p>
     * The property is specified by an integral index
     * as defined for <code>get</code>.<p>
     *
     * Identical to <code>put(String, Scriptable, Object)</code> except that
     * an integral index is used to select the property.
     *
     * @param index the numeric index for the property
     * @param start the object whose property is being set
     * @param value value to set the property to
     * @see org.mozilla.javascript.Scriptable#has(int, Scriptable)
     * @see org.mozilla.javascript.Scriptable#get(int, Scriptable)
     * @see org.mozilla.javascript.ScriptableObject#putProperty(Scriptable, int, Object)
     * @see org.mozilla.javascript.Context#toObject(Object, Scriptable)
     */
    public void put(int index, Scriptable start, Object value);

    /**
     * Removes a property from this object.
     * This operation corresponds to the ECMA [[Delete]] except that
     * the no result is returned. The runtime will guarantee that this
     * method is called only if the property exists. After this method
     * is called, the runtime will call Scriptable.has to see if the
     * property has been removed in order to determine the boolean
     * result of the delete operator as defined by ECMA 11.4.1.
     * <p>
     * A property can be made permanent by ignoring calls to remove
     * it.<p>
     * The property is specified by a String name
     * as defined for <code>get</code>.
     * <p>
     * To delete properties defined in a prototype chain,
     * see deleteProperty in ScriptableObject.
     * @param name the identifier for the property
     * @see org.mozilla.javascript.Scriptable#get(String, Scriptable)
     * @see org.mozilla.javascript.ScriptableObject#deleteProperty(Scriptable, String)
     */
    public void delete(String name);

    /**
     * Removes a property from this object.
     *
     * The property is specified by an integral index
     * as defined for <code>get</code>.
     * <p>
     * To delete properties defined in a prototype chain,
     * see deleteProperty in ScriptableObject.
     *
     * Identical to <code>delete(String)</code> except that
     * an integral index is used to select the property.
     *
     * @param index the numeric index for the property
     * @see org.mozilla.javascript.Scriptable#get(int, Scriptable)
     * @see org.mozilla.javascript.ScriptableObject#deleteProperty(Scriptable, int)
     */
    public void delete(int index);

    /**
     * Get the prototype of the object.
     * @return the prototype
     */
    public Scriptable getPrototype();

    /**
     * Set the prototype of the object.
     * @param prototype the prototype to set
     */
    public void setPrototype(Scriptable prototype);

    /**
     * Get the parent scope of the object.
     * @return the parent scope
     */
    public Scriptable getParentScope();

    /**
     * Set the parent scope of the object.
     * @param parent the parent scope to set
     */
    public void setParentScope(Scriptable parent);

    /**
     * Get an array of property ids.
     *
     * Not all property ids need be returned. Those properties
     * whose ids are not returned are considered non-enumerable.
     *
     * @return an array of Objects. Each entry in the array is either
     *         a java.lang.String or a java.lang.Number
     */
    public Object[] getIds();

    /**
     * Get the default value of the object with a given hint.
     * The hints are String.class for type String, Number.class for type
     * Number, Scriptable.class for type Object, and Boolean.class for
     * type Boolean. <p>
     *
     * A <code>hint</code> of null means "no hint".
     *
     * See ECMA 8.6.2.6.
     *
     * @param hint the type hint
     * @return the default value
     */
    public Object getDefaultValue(Class<?> hint);

    /**
     * The instanceof operator.
     *
     * <p>
     * The JavaScript code "lhs instanceof rhs" causes rhs.hasInstance(lhs) to
     * be called.
     *
     * <p>
     * The return value is implementation dependent so that embedded host objects can
     * return an appropriate value.  See the JS 1.3 language documentation for more
     * detail.
     *
     * <p>This operator corresponds to the proposed EMCA [[HasInstance]] operator.
     *
     * @param instance The value that appeared on the LHS of the instanceof
     *              operator
     *
     * @return an implementation dependent value
     */
    public boolean hasInstance(Scriptable instance);
}

