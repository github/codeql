// Generated automatically from javafx.scene.web.WebEngine for testing purposes

package javafx.scene.web;

import java.io.File;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.ReadOnlyStringProperty;
import javafx.beans.property.StringProperty;
import javafx.concurrent.Worker;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.geometry.Rectangle2D;
import javafx.print.PrinterJob;
import javafx.scene.web.PopupFeatures;
import javafx.scene.web.PromptData;
import javafx.scene.web.WebErrorEvent;
import javafx.scene.web.WebEvent;
import javafx.scene.web.WebHistory;
import javafx.util.Callback;
import org.w3c.dom.Document;

public class WebEngine
{
    public Object executeScript(String p0){ return null; }
    public WebEngine(){}
    public WebEngine(String p0){}
    public WebHistory getHistory(){ return null; }
    public final BooleanProperty javaScriptEnabledProperty(){ return null; }
    public final Callback<PopupFeatures, WebEngine> getCreatePopupHandler(){ return null; }
    public final Callback<PromptData, String> getPromptHandler(){ return null; }
    public final Callback<String, Boolean> getConfirmHandler(){ return null; }
    public final Document getDocument(){ return null; }
    public final EventHandler<WebErrorEvent> getOnError(){ return null; }
    public final EventHandler<WebEvent<Boolean>> getOnVisibilityChanged(){ return null; }
    public final EventHandler<WebEvent<Rectangle2D>> getOnResized(){ return null; }
    public final EventHandler<WebEvent<String>> getOnAlert(){ return null; }
    public final EventHandler<WebEvent<String>> getOnStatusChanged(){ return null; }
    public final File getUserDataDirectory(){ return null; }
    public final ObjectProperty<Callback<PopupFeatures, WebEngine>> createPopupHandlerProperty(){ return null; }
    public final ObjectProperty<Callback<PromptData, String>> promptHandlerProperty(){ return null; }
    public final ObjectProperty<Callback<String, Boolean>> confirmHandlerProperty(){ return null; }
    public final ObjectProperty<EventHandler<WebErrorEvent>> onErrorProperty(){ return null; }
    public final ObjectProperty<EventHandler<WebEvent<Boolean>>> onVisibilityChangedProperty(){ return null; }
    public final ObjectProperty<EventHandler<WebEvent<Rectangle2D>>> onResizedProperty(){ return null; }
    public final ObjectProperty<EventHandler<WebEvent<String>>> onAlertProperty(){ return null; }
    public final ObjectProperty<EventHandler<WebEvent<String>>> onStatusChangedProperty(){ return null; }
    public final ObjectProperty<File> userDataDirectoryProperty(){ return null; }
    public final ReadOnlyObjectProperty<Document> documentProperty(){ return null; }
    public final ReadOnlyStringProperty locationProperty(){ return null; }
    public final ReadOnlyStringProperty titleProperty(){ return null; }
    public final String getLocation(){ return null; }
    public final String getTitle(){ return null; }
    public final String getUserAgent(){ return null; }
    public final String getUserStyleSheetLocation(){ return null; }
    public final StringProperty userAgentProperty(){ return null; }
    public final StringProperty userStyleSheetLocationProperty(){ return null; }
    public final Worker<Void> getLoadWorker(){ return null; }
    public final boolean isJavaScriptEnabled(){ return false; }
    public final void setConfirmHandler(Callback<String, Boolean> p0){}
    public final void setCreatePopupHandler(Callback<PopupFeatures, WebEngine> p0){}
    public final void setJavaScriptEnabled(boolean p0){}
    public final void setOnAlert(EventHandler<WebEvent<String>> p0){}
    public final void setOnError(EventHandler<WebErrorEvent> p0){}
    public final void setOnResized(EventHandler<WebEvent<Rectangle2D>> p0){}
    public final void setOnStatusChanged(EventHandler<WebEvent<String>> p0){}
    public final void setOnVisibilityChanged(EventHandler<WebEvent<Boolean>> p0){}
    public final void setPromptHandler(Callback<PromptData, String> p0){}
    public final void setUserAgent(String p0){}
    public final void setUserDataDirectory(File p0){}
    public final void setUserStyleSheetLocation(String p0){}
    public void load(String p0){}
    public void loadContent(String p0){}
    public void loadContent(String p0, String p1){}
    public void print(PrinterJob p0){}
    public void reload(){}
}
