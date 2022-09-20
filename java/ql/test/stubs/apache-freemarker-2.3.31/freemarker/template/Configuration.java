// Generated automatically from freemarker.template.Configuration for testing purposes

package freemarker.template;

import freemarker.cache.CacheStorage;
import freemarker.cache.TemplateConfigurationFactory;
import freemarker.cache.TemplateLoader;
import freemarker.cache.TemplateLookupStrategy;
import freemarker.cache.TemplateNameFormat;
import freemarker.core.Configurable;
import freemarker.core.Environment;
import freemarker.core.OutputFormat;
import freemarker.core.ParserConfiguration;
import freemarker.template.AttemptExceptionReporter;
import freemarker.template.ObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.TemplateHashModelEx;
import freemarker.template.TemplateModel;
import freemarker.template.Version;
import java.io.File;
import java.util.Collection;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

public class Configuration extends Configurable implements Cloneable, ParserConfiguration
{
    protected String getCorrectedNameForUnknownSetting(String p0){ return null; }
    protected void doAutoImportsAndIncludes(Environment p0){}
    public CacheStorage getCacheStorage(){ return null; }
    public Collection<? extends OutputFormat> getRegisteredCustomOutputFormats(){ return null; }
    public Configuration(){}
    public Configuration(Version p0){}
    public Object clone(){ return null; }
    public OutputFormat getOutputFormat(){ return null; }
    public OutputFormat getOutputFormat(String p0){ return null; }
    public Set getSharedVariableNames(){ return null; }
    public Set getSupportedBuiltInDirectiveNames(){ return null; }
    public Set getSupportedBuiltInNames(){ return null; }
    public Set<String> getSettingNames(boolean p0){ return null; }
    public Set<String> getSupportedBuiltInDirectiveNames(int p0){ return null; }
    public Set<String> getSupportedBuiltInNames(int p0){ return null; }
    public String getDefaultEncoding(){ return null; }
    public String getEncoding(Locale p0){ return null; }
    public String getIncompatibleEnhancements(){ return null; }
    public Template getTemplate(String p0){ return null; }
    public Template getTemplate(String p0, Locale p1){ return null; }
    public Template getTemplate(String p0, Locale p1, Object p2, String p3, boolean p4, boolean p5){ return null; }
    public Template getTemplate(String p0, Locale p1, String p2){ return null; }
    public Template getTemplate(String p0, Locale p1, String p2, boolean p3){ return null; }
    public Template getTemplate(String p0, Locale p1, String p2, boolean p3, boolean p4){ return null; }
    public Template getTemplate(String p0, String p1){ return null; }
    public TemplateConfigurationFactory getTemplateConfigurations(){ return null; }
    public TemplateLoader getTemplateLoader(){ return null; }
    public TemplateLookupStrategy getTemplateLookupStrategy(){ return null; }
    public TemplateModel getSharedVariable(String p0){ return null; }
    public TemplateNameFormat getTemplateNameFormat(){ return null; }
    public Version getIncompatibleImprovements(){ return null; }
    public boolean getFallbackOnNullLoopVariable(){ return false; }
    public boolean getLocalizedLookup(){ return false; }
    public boolean getRecognizeStandardFileExtensions(){ return false; }
    public boolean getStrictSyntaxMode(){ return false; }
    public boolean getWhitespaceStripping(){ return false; }
    public boolean isAttemptExceptionReporterExplicitlySet(){ return false; }
    public boolean isCacheStorageExplicitlySet(){ return false; }
    public boolean isDefaultEncodingExplicitlySet(){ return false; }
    public boolean isLocaleExplicitlySet(){ return false; }
    public boolean isLogTemplateExceptionsExplicitlySet(){ return false; }
    public boolean isObjectWrapperExplicitlySet(){ return false; }
    public boolean isOutputFormatExplicitlySet(){ return false; }
    public boolean isRecognizeStandardFileExtensionsExplicitlySet(){ return false; }
    public boolean isTemplateExceptionHandlerExplicitlySet(){ return false; }
    public boolean isTemplateLoaderExplicitlySet(){ return false; }
    public boolean isTemplateLookupStrategyExplicitlySet(){ return false; }
    public boolean isTemplateNameFormatExplicitlySet(){ return false; }
    public boolean isTimeZoneExplicitlySet(){ return false; }
    public boolean isWrapUncheckedExceptionsExplicitlySet(){ return false; }
    public int getAutoEscapingPolicy(){ return 0; }
    public int getInterpolationSyntax(){ return 0; }
    public int getNamingConvention(){ return 0; }
    public int getParsedIncompatibleEnhancements(){ return 0; }
    public int getTabSize(){ return 0; }
    public int getTagSyntax(){ return 0; }
    public long getTemplateUpdateDelayMilliseconds(){ return 0; }
    public static Configuration getDefaultConfiguration(){ return null; }
    public static ObjectWrapper getDefaultObjectWrapper(Version p0){ return null; }
    public static String AUTO_ESCAPING_POLICY_KEY = null;
    public static String AUTO_ESCAPING_POLICY_KEY_CAMEL_CASE = null;
    public static String AUTO_ESCAPING_POLICY_KEY_SNAKE_CASE = null;
    public static String AUTO_IMPORT_KEY = null;
    public static String AUTO_IMPORT_KEY_CAMEL_CASE = null;
    public static String AUTO_IMPORT_KEY_SNAKE_CASE = null;
    public static String AUTO_INCLUDE_KEY = null;
    public static String AUTO_INCLUDE_KEY_CAMEL_CASE = null;
    public static String AUTO_INCLUDE_KEY_SNAKE_CASE = null;
    public static String CACHE_STORAGE_KEY = null;
    public static String CACHE_STORAGE_KEY_CAMEL_CASE = null;
    public static String CACHE_STORAGE_KEY_SNAKE_CASE = null;
    public static String DEFAULT_ENCODING_KEY = null;
    public static String DEFAULT_ENCODING_KEY_CAMEL_CASE = null;
    public static String DEFAULT_ENCODING_KEY_SNAKE_CASE = null;
    public static String DEFAULT_INCOMPATIBLE_ENHANCEMENTS = null;
    public static String FALLBACK_ON_NULL_LOOP_VARIABLE_KEY = null;
    public static String FALLBACK_ON_NULL_LOOP_VARIABLE_KEY_CAMEL_CASE = null;
    public static String FALLBACK_ON_NULL_LOOP_VARIABLE_KEY_SNAKE_CASE = null;
    public static String INCOMPATIBLE_ENHANCEMENTS = null;
    public static String INCOMPATIBLE_IMPROVEMENTS = null;
    public static String INCOMPATIBLE_IMPROVEMENTS_KEY = null;
    public static String INCOMPATIBLE_IMPROVEMENTS_KEY_CAMEL_CASE = null;
    public static String INCOMPATIBLE_IMPROVEMENTS_KEY_SNAKE_CASE = null;
    public static String INTERPOLATION_SYNTAX_KEY = null;
    public static String INTERPOLATION_SYNTAX_KEY_CAMEL_CASE = null;
    public static String INTERPOLATION_SYNTAX_KEY_SNAKE_CASE = null;
    public static String LOCALIZED_LOOKUP_KEY = null;
    public static String LOCALIZED_LOOKUP_KEY_CAMEL_CASE = null;
    public static String LOCALIZED_LOOKUP_KEY_SNAKE_CASE = null;
    public static String NAMING_CONVENTION_KEY = null;
    public static String NAMING_CONVENTION_KEY_CAMEL_CASE = null;
    public static String NAMING_CONVENTION_KEY_SNAKE_CASE = null;
    public static String OUTPUT_FORMAT_KEY = null;
    public static String OUTPUT_FORMAT_KEY_CAMEL_CASE = null;
    public static String OUTPUT_FORMAT_KEY_SNAKE_CASE = null;
    public static String RECOGNIZE_STANDARD_FILE_EXTENSIONS_KEY = null;
    public static String RECOGNIZE_STANDARD_FILE_EXTENSIONS_KEY_CAMEL_CASE = null;
    public static String RECOGNIZE_STANDARD_FILE_EXTENSIONS_KEY_SNAKE_CASE = null;
    public static String REGISTERED_CUSTOM_OUTPUT_FORMATS_KEY = null;
    public static String REGISTERED_CUSTOM_OUTPUT_FORMATS_KEY_CAMEL_CASE = null;
    public static String REGISTERED_CUSTOM_OUTPUT_FORMATS_KEY_SNAKE_CASE = null;
    public static String STRICT_SYNTAX_KEY = null;
    public static String STRICT_SYNTAX_KEY_CAMEL_CASE = null;
    public static String STRICT_SYNTAX_KEY_SNAKE_CASE = null;
    public static String TAB_SIZE_KEY = null;
    public static String TAB_SIZE_KEY_CAMEL_CASE = null;
    public static String TAB_SIZE_KEY_SNAKE_CASE = null;
    public static String TAG_SYNTAX_KEY = null;
    public static String TAG_SYNTAX_KEY_CAMEL_CASE = null;
    public static String TAG_SYNTAX_KEY_SNAKE_CASE = null;
    public static String TEMPLATE_CONFIGURATIONS_KEY = null;
    public static String TEMPLATE_CONFIGURATIONS_KEY_CAMEL_CASE = null;
    public static String TEMPLATE_CONFIGURATIONS_KEY_SNAKE_CASE = null;
    public static String TEMPLATE_LOADER_KEY = null;
    public static String TEMPLATE_LOADER_KEY_CAMEL_CASE = null;
    public static String TEMPLATE_LOADER_KEY_SNAKE_CASE = null;
    public static String TEMPLATE_LOOKUP_STRATEGY_KEY = null;
    public static String TEMPLATE_LOOKUP_STRATEGY_KEY_CAMEL_CASE = null;
    public static String TEMPLATE_LOOKUP_STRATEGY_KEY_SNAKE_CASE = null;
    public static String TEMPLATE_NAME_FORMAT_KEY = null;
    public static String TEMPLATE_NAME_FORMAT_KEY_CAMEL_CASE = null;
    public static String TEMPLATE_NAME_FORMAT_KEY_SNAKE_CASE = null;
    public static String TEMPLATE_UPDATE_DELAY_KEY = null;
    public static String TEMPLATE_UPDATE_DELAY_KEY_CAMEL_CASE = null;
    public static String TEMPLATE_UPDATE_DELAY_KEY_SNAKE_CASE = null;
    public static String WHITESPACE_STRIPPING_KEY = null;
    public static String WHITESPACE_STRIPPING_KEY_CAMEL_CASE = null;
    public static String WHITESPACE_STRIPPING_KEY_SNAKE_CASE = null;
    public static String getVersionNumber(){ return null; }
    public static Version DEFAULT_INCOMPATIBLE_IMPROVEMENTS = null;
    public static Version VERSION_2_3_0 = null;
    public static Version VERSION_2_3_19 = null;
    public static Version VERSION_2_3_20 = null;
    public static Version VERSION_2_3_21 = null;
    public static Version VERSION_2_3_22 = null;
    public static Version VERSION_2_3_23 = null;
    public static Version VERSION_2_3_24 = null;
    public static Version VERSION_2_3_25 = null;
    public static Version VERSION_2_3_26 = null;
    public static Version VERSION_2_3_27 = null;
    public static Version VERSION_2_3_28 = null;
    public static Version VERSION_2_3_29 = null;
    public static Version VERSION_2_3_30 = null;
    public static Version VERSION_2_3_31 = null;
    public static Version getVersion(){ return null; }
    public static int ANGLE_BRACKET_TAG_SYNTAX = 0;
    public static int AUTO_DETECT_NAMING_CONVENTION = 0;
    public static int AUTO_DETECT_TAG_SYNTAX = 0;
    public static int CAMEL_CASE_NAMING_CONVENTION = 0;
    public static int DISABLE_AUTO_ESCAPING_POLICY = 0;
    public static int DOLLAR_INTERPOLATION_SYNTAX = 0;
    public static int ENABLE_IF_DEFAULT_AUTO_ESCAPING_POLICY = 0;
    public static int ENABLE_IF_SUPPORTED_AUTO_ESCAPING_POLICY = 0;
    public static int LEGACY_INTERPOLATION_SYNTAX = 0;
    public static int LEGACY_NAMING_CONVENTION = 0;
    public static int PARSED_DEFAULT_INCOMPATIBLE_ENHANCEMENTS = 0;
    public static int SQUARE_BRACKET_INTERPOLATION_SYNTAX = 0;
    public static int SQUARE_BRACKET_TAG_SYNTAX = 0;
    public static void setDefaultConfiguration(Configuration p0){}
    public void clearEncodingMap(){}
    public void clearSharedVariables(){}
    public void clearTemplateCache(){}
    public void loadBuiltInEncodingMap(){}
    public void removeTemplateFromCache(String p0){}
    public void removeTemplateFromCache(String p0, Locale p1){}
    public void removeTemplateFromCache(String p0, Locale p1, Object p2, String p3, boolean p4){}
    public void removeTemplateFromCache(String p0, Locale p1, String p2){}
    public void removeTemplateFromCache(String p0, Locale p1, String p2, boolean p3){}
    public void removeTemplateFromCache(String p0, String p1){}
    public void setAllSharedVariables(TemplateHashModelEx p0){}
    public void setAttemptExceptionReporter(AttemptExceptionReporter p0){}
    public void setAutoEscapingPolicy(int p0){}
    public void setCacheStorage(CacheStorage p0){}
    public void setClassForTemplateLoading(Class p0, String p1){}
    public void setClassLoaderForTemplateLoading(ClassLoader p0, String p1){}
    public void setDefaultEncoding(String p0){}
    public void setDirectoryForTemplateLoading(File p0){}
    public void setEncoding(Locale p0, String p1){}
    public void setFallbackOnNullLoopVariable(boolean p0){}
    public void setIncompatibleEnhancements(String p0){}
    public void setIncompatibleImprovements(Version p0){}
    public void setInterpolationSyntax(int p0){}
    public void setLocale(Locale p0){}
    public void setLocalizedLookup(boolean p0){}
    public void setLogTemplateExceptions(boolean p0){}
    public void setNamingConvention(int p0){}
    public void setObjectWrapper(ObjectWrapper p0){}
    public void setOutputFormat(OutputFormat p0){}
    public void setRecognizeStandardFileExtensions(boolean p0){}
    public void setRegisteredCustomOutputFormats(Collection<? extends OutputFormat> p0){}
    public void setServletContextForTemplateLoading(Object p0, String p1){}
    public void setSetting(String p0, String p1){}
    public void setSharedVariable(String p0, Object p1){}
    public void setSharedVariable(String p0, TemplateModel p1){}
    public void setSharedVariables(Map<String, ? extends Object> p0){}
    public void setSharedVaribles(Map p0){}
    public void setStrictSyntaxMode(boolean p0){}
    public void setTabSize(int p0){}
    public void setTagSyntax(int p0){}
    public void setTemplateConfigurations(TemplateConfigurationFactory p0){}
    public void setTemplateExceptionHandler(TemplateExceptionHandler p0){}
    public void setTemplateLoader(TemplateLoader p0){}
    public void setTemplateLookupStrategy(TemplateLookupStrategy p0){}
    public void setTemplateNameFormat(TemplateNameFormat p0){}
    public void setTemplateUpdateDelay(int p0){}
    public void setTemplateUpdateDelayMilliseconds(long p0){}
    public void setTimeZone(TimeZone p0){}
    public void setWhitespaceStripping(boolean p0){}
    public void setWrapUncheckedExceptions(boolean p0){}
    public void unsetAttemptExceptionReporter(){}
    public void unsetCacheStorage(){}
    public void unsetDefaultEncoding(){}
    public void unsetLocale(){}
    public void unsetLogTemplateExceptions(){}
    public void unsetObjectWrapper(){}
    public void unsetOutputFormat(){}
    public void unsetRecognizeStandardFileExtensions(){}
    public void unsetTemplateExceptionHandler(){}
    public void unsetTemplateLoader(){}
    public void unsetTemplateLookupStrategy(){}
    public void unsetTemplateNameFormat(){}
    public void unsetTimeZone(){}
    public void unsetWrapUncheckedExceptions(){}
}
