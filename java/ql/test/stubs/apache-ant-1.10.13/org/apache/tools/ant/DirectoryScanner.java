// Generated automatically from org.apache.tools.ant.DirectoryScanner for testing purposes

package org.apache.tools.ant;

import java.io.File;
import java.util.Vector;
import org.apache.tools.ant.FileScanner;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceFactory;
import org.apache.tools.ant.types.selectors.FileSelector;
import org.apache.tools.ant.types.selectors.SelectorScanner;

public class DirectoryScanner implements FileScanner, ResourceFactory, SelectorScanner
{
    protected File basedir = null;
    protected FileSelector[] selectors = null;
    protected String[] excludes = null;
    protected String[] includes = null;
    protected Vector<String> dirsDeselected = null;
    protected Vector<String> dirsExcluded = null;
    protected Vector<String> dirsIncluded = null;
    protected Vector<String> dirsNotIncluded = null;
    protected Vector<String> filesDeselected = null;
    protected Vector<String> filesExcluded = null;
    protected Vector<String> filesIncluded = null;
    protected Vector<String> filesNotIncluded = null;
    protected boolean couldHoldIncluded(String p0){ return false; }
    protected boolean errorOnMissingDir = false;
    protected boolean everythingIncluded = false;
    protected boolean haveSlowResults = false;
    protected boolean isCaseSensitive = false;
    protected boolean isExcluded(String p0){ return false; }
    protected boolean isIncluded(String p0){ return false; }
    protected boolean isSelected(String p0, File p1){ return false; }
    protected static String[] DEFAULTEXCLUDES = null;
    protected static boolean match(String p0, String p1, boolean p2){ return false; }
    protected static boolean matchPath(String p0, String p1){ return false; }
    protected static boolean matchPath(String p0, String p1, boolean p2){ return false; }
    protected static boolean matchPatternStart(String p0, String p1){ return false; }
    protected static boolean matchPatternStart(String p0, String p1, boolean p2){ return false; }
    protected void clearResults(){}
    protected void scandir(File p0, String p1, boolean p2){}
    protected void slowScan(){}
    public DirectoryScanner(){}
    public File getBasedir(){ return null; }
    public Resource getResource(String p0){ return null; }
    public String[] getDeselectedDirectories(){ return null; }
    public String[] getDeselectedFiles(){ return null; }
    public String[] getExcludedDirectories(){ return null; }
    public String[] getExcludedFiles(){ return null; }
    public String[] getIncludedDirectories(){ return null; }
    public String[] getIncludedFiles(){ return null; }
    public String[] getNotFollowedSymlinks(){ return null; }
    public String[] getNotIncludedDirectories(){ return null; }
    public String[] getNotIncludedFiles(){ return null; }
    public boolean isCaseSensitive(){ return false; }
    public boolean isEverythingIncluded(){ return false; }
    public boolean isFollowSymlinks(){ return false; }
    public int getIncludedDirsCount(){ return 0; }
    public int getIncludedFilesCount(){ return 0; }
    public static String DOES_NOT_EXIST_POSTFIX = null;
    public static String[] getDefaultExcludes(){ return null; }
    public static boolean addDefaultExclude(String p0){ return false; }
    public static boolean match(String p0, String p1){ return false; }
    public static boolean removeDefaultExclude(String p0){ return false; }
    public static int MAX_LEVELS_OF_SYMLINKS = 0;
    public static void resetDefaultExcludes(){}
    public void addDefaultExcludes(){}
    public void addExcludes(String[] p0){}
    public void scan(){}
    public void setBasedir(File p0){}
    public void setBasedir(String p0){}
    public void setCaseSensitive(boolean p0){}
    public void setErrorOnMissingDir(boolean p0){}
    public void setExcludes(String[] p0){}
    public void setFollowSymlinks(boolean p0){}
    public void setIncludes(String[] p0){}
    public void setMaxLevelsOfSymlinks(int p0){}
    public void setSelectors(FileSelector[] p0){}
}
