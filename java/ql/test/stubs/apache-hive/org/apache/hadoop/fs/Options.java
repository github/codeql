// Generated automatically from org.apache.hadoop.fs.Options for testing purposes

package org.apache.hadoop.fs;

import java.util.Optional;
import java.util.function.BiFunction;
import java.util.function.Function;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.PathHandle;
import org.apache.hadoop.util.DataChecksum;

public class Options
{
    public Options(){}
    static public class ChecksumOpt
    {
        public ChecksumOpt(){}
        public ChecksumOpt(DataChecksum.Type p0, int p1){}
        public DataChecksum.Type getChecksumType(){ return null; }
        public String toString(){ return null; }
        public int getBytesPerChecksum(){ return 0; }
        public static Options.ChecksumOpt createDisabled(){ return null; }
        public static Options.ChecksumOpt processChecksumOpt(Options.ChecksumOpt p0, Options.ChecksumOpt p1){ return null; }
        public static Options.ChecksumOpt processChecksumOpt(Options.ChecksumOpt p0, Options.ChecksumOpt p1, int p2){ return null; }
    }
    static public class HandleOpt
    {
        protected HandleOpt(){}
        public static <T extends Options.HandleOpt> java.util.Optional<T> getOpt(java.lang.Class<T> p0, Options.HandleOpt... p1){ return null; }
        public static Function<FileStatus, PathHandle> resolve(BiFunction<FileStatus, Options.HandleOpt[], PathHandle> p0, Options.HandleOpt... p1){ return null; }
        public static Function<FileStatus, PathHandle> resolve(FileSystem p0, Options.HandleOpt... p1){ return null; }
        public static Options.HandleOpt.Data changed(boolean p0){ return null; }
        public static Options.HandleOpt.Location moved(boolean p0){ return null; }
        public static Options.HandleOpt[] content(){ return null; }
        public static Options.HandleOpt[] exact(){ return null; }
        public static Options.HandleOpt[] path(){ return null; }
        public static Options.HandleOpt[] reference(){ return null; }
        static public class Data extends Options.HandleOpt
        {
            protected Data() {}
            public String toString(){ return null; }
            public boolean allowChange(){ return false; }
        }
        static public class Location extends Options.HandleOpt
        {
            protected Location() {}
            public String toString(){ return null; }
            public boolean allowChange(){ return false; }
        }
    }
    static public enum Rename
    {
        NONE, OVERWRITE, TO_TRASH;
        private Rename() {}
        public byte value(){ return 0; }
    }
}
