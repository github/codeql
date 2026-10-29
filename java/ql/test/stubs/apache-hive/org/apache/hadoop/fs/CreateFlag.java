// Generated automatically from org.apache.hadoop.fs.CreateFlag for testing purposes

package org.apache.hadoop.fs;

import java.util.EnumSet;

public enum CreateFlag
{
    APPEND, CREATE, LAZY_PERSIST, NEW_BLOCK, NO_LOCAL_WRITE, OVERWRITE, SHOULD_REPLICATE, SYNC_BLOCK;
    private CreateFlag() {}
    public static void validate(EnumSet<CreateFlag> p0){}
    public static void validate(Object p0, boolean p1, EnumSet<CreateFlag> p2){}
    public static void validateForAppend(EnumSet<CreateFlag> p0){}
}
