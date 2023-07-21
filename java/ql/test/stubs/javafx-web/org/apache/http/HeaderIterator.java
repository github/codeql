// Generated automatically from org.apache.http.HeaderIterator for testing purposes

package org.apache.http;

import java.util.Iterator;
import org.apache.http.Header;

public interface HeaderIterator extends Iterator<Object>
{
    Header nextHeader();
    boolean hasNext();
}
