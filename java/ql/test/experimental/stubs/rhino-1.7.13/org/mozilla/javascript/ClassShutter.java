/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// API class

package org.mozilla.javascript;

/**
Embeddings that wish to filter Java classes that are visible to scripts
through the LiveConnect, should implement this interface.

@see Context#setClassShutter(ClassShutter)
@since 1.5 Release 4
@author Norris Boyd
*/

 public interface ClassShutter {

    /**
     * Return true iff the Java class with the given name should be exposed
     * to scripts.
     * <p>
     * An embedding may filter which Java classes are exposed through
     * LiveConnect to JavaScript scripts.
     * <p>
     * Due to the fact that there is no package reflection in Java,
     * this method will also be called with package names. There
     * is no way for Rhino to tell if "Packages.a.b" is a package name
     * or a class that doesn't exist. What Rhino does is attempt
     * to load each segment of "Packages.a.b.c": It first attempts to
     * load class "a", then attempts to load class "a.b", then
     * finally attempts to load class "a.b.c". On a Rhino installation
     * without any ClassShutter set, and without any of the
     * above classes, the expression "Packages.a.b.c" will result in
     * a [JavaPackage a.b.c] and not an error.
     * <p>
     * With ClassShutter supplied, Rhino will first call
     * visibleToScripts before attempting to look up the class name. If
     * visibleToScripts returns false, the class name lookup is not
     * performed and subsequent Rhino execution assumes the class is
     * not present. So for "java.lang.System.out.println" the lookup
     * of "java.lang.System" is skipped and thus Rhino assumes that
     * "java.lang.System" doesn't exist. So then for "java.lang.System.out",
     * Rhino attempts to load the class "java.lang.System.out" because
     * it assumes that "java.lang.System" is a package name.
     * <p>
     * @param fullClassName the full name of the class (including the package
     *                      name, with '.' as a delimiter). For example the
     *                      standard string class is "java.lang.String"
     * @return whether or not to reveal this class to scripts
     */
    public boolean visibleToScripts(String fullClassName);
}
