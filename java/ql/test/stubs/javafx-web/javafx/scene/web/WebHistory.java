// Generated automatically from javafx.scene.web.WebHistory for testing purposes

package javafx.scene.web;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.ReadOnlyIntegerProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.collections.ObservableList;

public class WebHistory
{
    protected WebHistory() {}
    public IntegerProperty maxSizeProperty(){ return null; }
    public ObservableList<WebHistory.Entry> getEntries(){ return null; }
    public ReadOnlyIntegerProperty currentIndexProperty(){ return null; }
    public class Entry
    {
        protected Entry() {}
        public ReadOnlyObjectProperty<String> titleProperty(){ return null; }
        public ReadOnlyObjectProperty<java.util.Date> lastVisitedDateProperty(){ return null; }
        public String getTitle(){ return null; }
        public String getUrl(){ return null; }
        public String toString(){ return null; }
        public java.util.Date getLastVisitedDate(){ return null; }
    }
    public int getCurrentIndex(){ return 0; }
    public int getMaxSize(){ return 0; }
    public void go(int p0){}
    public void setMaxSize(int p0){}
}
