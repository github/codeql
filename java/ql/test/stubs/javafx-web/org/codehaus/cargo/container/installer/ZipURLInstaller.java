// Generated automatically from org.codehaus.cargo.container.installer.ZipURLInstaller for testing purposes

package org.codehaus.cargo.container.installer;

import java.net.URL;
import org.codehaus.cargo.container.installer.Installer;
import org.codehaus.cargo.container.installer.Proxy;
import org.codehaus.cargo.util.FileHandler;
import org.codehaus.cargo.util.log.LoggedObject;
import org.codehaus.cargo.util.log.Logger;

public class ZipURLInstaller extends LoggedObject implements Installer
{
    protected ZipURLInstaller() {}
    protected String getSourceFileName(){ return null; }
    protected void doDownload(){}
    public FileHandler getFileHandler(){ return null; }
    public String getDownloadDir(){ return null; }
    public String getDownloadFile(){ return null; }
    public String getExtractDir(){ return null; }
    public String getHome(){ return null; }
    public ZipURLInstaller(URL p0){}
    public ZipURLInstaller(URL p0, String p1, String p2){}
    public boolean isAlreadyDownloaded(){ return false; }
    public boolean isAlreadyExtracted(){ return false; }
    public void download(){}
    public void install(){}
    public void registerInstallation(){}
    public void setDownloadDir(String p0){}
    public void setExtractDir(String p0){}
    public void setFileHandler(FileHandler p0){}
    public void setLogger(Logger p0){}
    public void setProxy(Proxy p0){}
}
