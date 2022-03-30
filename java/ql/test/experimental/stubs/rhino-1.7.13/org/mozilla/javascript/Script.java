/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// API class

package org.mozilla.javascript;

/**
 * All compiled scripts implement this interface.
 * <p>
 * This class encapsulates script execution relative to an
 * object scope.
 * @since 1.3
 * @author Norris Boyd
 */

public interface Script {

    /**
     * Execute the script.
     * <p>
     * The script is executed in a particular runtime Context, which
     * must be associated with the current thread.
     * The script is executed relative to a scope--definitions and
     * uses of global top-level variables and functions will access
     * properties of the scope object. For compliant ECMA
     * programs, the scope must be an object that has been initialized
     * as a global object using <code>Context.initStandardObjects</code>.
     * <p>
     *
     * @param cx the Context associated with the current thread
     * @param scope the scope to execute relative to
     * @return the result of executing the script
     * @see org.mozilla.javascript.Context#initStandardObjects()
     */
    public Object exec(Context cx, Scriptable scope);

}