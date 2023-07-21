// Generated automatically from org.apache.tools.ant.types.ResourceCollection for testing purposes

package org.apache.tools.ant.types;

import java.util.stream.Stream;
import org.apache.tools.ant.types.Resource;

public interface ResourceCollection extends Iterable<Resource>
{
    boolean isFilesystemOnly();
    default Stream<? extends Resource> stream(){ return null; }
    default boolean isEmpty(){ return false; }
    int size();
}
