// Generated automatically from org.apache.sshd.common.NamedResource for testing purposes

package org.apache.sshd.common;

import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.function.Function;

public interface NamedResource
{
    String getName();
    static <R extends NamedResource> R findByName(String p0, Comparator<? super String> p1, Collection<? extends R> p2){ return null; }
    static <R extends NamedResource> R findFirstMatchByName(Collection<String> p0, Comparator<? super String> p1, Collection<? extends R> p2){ return null; }
    static <R extends NamedResource> R removeByName(String p0, Comparator<? super String> p1, Collection<? extends R> p2){ return null; }
    static Comparator<NamedResource> BY_NAME_COMPARATOR = null;
    static Function<NamedResource, String> NAME_EXTRACTOR = null;
    static List<String> getNameList(Collection<? extends NamedResource> p0){ return null; }
    static NamedResource ofName(String p0){ return null; }
    static String getNames(Collection<? extends NamedResource> p0){ return null; }
    static int safeCompareByName(NamedResource p0, NamedResource p1, boolean p2){ return 0; }
}
