// Generated automatically from org.apache.commons.compress.archivers.zip.ExtraFieldParsingBehavior for testing purposes

package org.apache.commons.compress.archivers.zip;

import org.apache.commons.compress.archivers.zip.UnparseableExtraFieldBehavior;
import org.apache.commons.compress.archivers.zip.ZipExtraField;
import org.apache.commons.compress.archivers.zip.ZipShort;

public interface ExtraFieldParsingBehavior extends UnparseableExtraFieldBehavior
{
    ZipExtraField createExtraField(ZipShort p0);
    ZipExtraField fill(ZipExtraField p0, byte[] p1, int p2, int p3, boolean p4);
}
