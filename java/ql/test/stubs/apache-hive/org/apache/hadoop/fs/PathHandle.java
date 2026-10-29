// Generated automatically from org.apache.hadoop.fs.PathHandle for testing purposes

package org.apache.hadoop.fs;

import java.io.Serializable;
import java.nio.ByteBuffer;

public interface PathHandle extends Serializable
{
    ByteBuffer bytes();
    boolean equals(Object p0);
    default byte[] toByteArray(){ return null; }
}
