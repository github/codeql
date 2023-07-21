// Generated automatically from com.sun.javafx.tk.TKClipboard for testing purposes

package com.sun.javafx.tk;

import java.security.AccessControlContext;
import java.util.Set;
import javafx.scene.image.Image;
import javafx.scene.input.DataFormat;
import javafx.scene.input.TransferMode;
import javafx.util.Pair;

public interface TKClipboard
{
    Image getDragView();
    Object getContent(DataFormat p0);
    Set<DataFormat> getContentTypes();
    Set<TransferMode> getTransferModes();
    boolean hasContent(DataFormat p0);
    boolean putContent(Pair<DataFormat, Object>... p0);
    double getDragViewOffsetX();
    double getDragViewOffsetY();
    void setDragView(Image p0);
    void setDragViewOffsetX(double p0);
    void setDragViewOffsetY(double p0);
    void setSecurityContext(AccessControlContext p0);
}
