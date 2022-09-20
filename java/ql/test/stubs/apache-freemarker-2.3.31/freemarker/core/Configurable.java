// Generated automatically from freemarker.core.Configurable for testing purposes

package freemarker.core;

import freemarker.core.ArithmeticEngine;
import freemarker.core.Environment;
import freemarker.core.TemplateClassResolver;
import freemarker.core.TemplateDateFormatFactory;
import freemarker.core.TemplateNumberFormatFactory;
import freemarker.core.TruncateBuiltinAlgorithm;
import freemarker.template.AttemptExceptionReporter;
import freemarker.template.ObjectWrapper;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.Version;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;

public class Configurable
{
    protected ArrayList parseAsList(String p0){ return null; }
    protected ArrayList parseAsSegmentedList(String p0){ return null; }
    protected Configurable(Version p0){}
    protected Environment getEnvironment(){ return null; }
    protected HashMap parseAsImportList(String p0){ return null; }
    protected Object clone(){ return null; }
    protected String getCorrectedNameForUnknownSetting(String p0){ return null; }
    protected TemplateException invalidSettingValueException(String p0, String p1){ return null; }
    protected TemplateException settingValueAssignmentException(String p0, String p1, Throwable p2){ return null; }
    protected TemplateException unknownSettingException(String p0){ return null; }
    protected void doAutoImportsAndIncludes(Environment p0){}
    public ArithmeticEngine getArithmeticEngine(){ return null; }
    public AttemptExceptionReporter getAttemptExceptionReporter(){ return null; }
    public Boolean getLazyAutoImports(){ return null; }
    public Configurable(){}
    public Configurable(Configurable p0){}
    public List<String> getAutoIncludes(){ return null; }
    public List<String> getAutoIncludesWithoutFallback(){ return null; }
    public Locale getLocale(){ return null; }
    public Map getSettings(){ return null; }
    public Map<String, ? extends TemplateDateFormatFactory> getCustomDateFormats(){ return null; }
    public Map<String, ? extends TemplateDateFormatFactory> getCustomDateFormatsWithoutFallback(){ return null; }
    public Map<String, ? extends TemplateNumberFormatFactory> getCustomNumberFormats(){ return null; }
    public Map<String, ? extends TemplateNumberFormatFactory> getCustomNumberFormatsWithoutFallback(){ return null; }
    public Map<String, String> getAutoImports(){ return null; }
    public Map<String, String> getAutoImportsWithoutFallback(){ return null; }
    public Object getCustomAttribute(String p0){ return null; }
    public ObjectWrapper getObjectWrapper(){ return null; }
    public Set<String> getSettingNames(boolean p0){ return null; }
    public String getBooleanFormat(){ return null; }
    public String getDateFormat(){ return null; }
    public String getDateTimeFormat(){ return null; }
    public String getNumberFormat(){ return null; }
    public String getOutputEncoding(){ return null; }
    public String getSetting(String p0){ return null; }
    public String getTimeFormat(){ return null; }
    public String getURLEscapingCharset(){ return null; }
    public String[] getCustomAttributeNames(){ return null; }
    public TemplateClassResolver getNewBuiltinClassResolver(){ return null; }
    public TemplateDateFormatFactory getCustomDateFormat(String p0){ return null; }
    public TemplateExceptionHandler getTemplateExceptionHandler(){ return null; }
    public TemplateNumberFormatFactory getCustomNumberFormat(String p0){ return null; }
    public TimeZone getSQLDateAndTimeTimeZone(){ return null; }
    public TimeZone getTimeZone(){ return null; }
    public TruncateBuiltinAlgorithm getTruncateBuiltinAlgorithm(){ return null; }
    public boolean getAutoFlush(){ return false; }
    public boolean getLazyImports(){ return false; }
    public boolean getLogTemplateExceptions(){ return false; }
    public boolean getShowErrorTips(){ return false; }
    public boolean getWrapUncheckedExceptions(){ return false; }
    public boolean hasCustomFormats(){ return false; }
    public boolean isAPIBuiltinEnabled(){ return false; }
    public boolean isAPIBuiltinEnabledSet(){ return false; }
    public boolean isArithmeticEngineSet(){ return false; }
    public boolean isAttemptExceptionReporterSet(){ return false; }
    public boolean isAutoFlushSet(){ return false; }
    public boolean isAutoImportsSet(){ return false; }
    public boolean isAutoIncludesSet(){ return false; }
    public boolean isBooleanFormatSet(){ return false; }
    public boolean isClassicCompatible(){ return false; }
    public boolean isClassicCompatibleSet(){ return false; }
    public boolean isCustomDateFormatsSet(){ return false; }
    public boolean isCustomNumberFormatsSet(){ return false; }
    public boolean isDateFormatSet(){ return false; }
    public boolean isDateTimeFormatSet(){ return false; }
    public boolean isLazyAutoImportsSet(){ return false; }
    public boolean isLazyImportsSet(){ return false; }
    public boolean isLocaleSet(){ return false; }
    public boolean isLogTemplateExceptionsSet(){ return false; }
    public boolean isNewBuiltinClassResolverSet(){ return false; }
    public boolean isNumberFormatSet(){ return false; }
    public boolean isObjectWrapperSet(){ return false; }
    public boolean isOutputEncodingSet(){ return false; }
    public boolean isSQLDateAndTimeTimeZoneSet(){ return false; }
    public boolean isShowErrorTipsSet(){ return false; }
    public boolean isTemplateExceptionHandlerSet(){ return false; }
    public boolean isTimeFormatSet(){ return false; }
    public boolean isTimeZoneSet(){ return false; }
    public boolean isTruncateBuiltinAlgorithmSet(){ return false; }
    public boolean isURLEscapingCharsetSet(){ return false; }
    public boolean isWrapUncheckedExceptionsSet(){ return false; }
    public final Configurable getParent(){ return null; }
    public int getClassicCompatibleAsInt(){ return 0; }
    public static String API_BUILTIN_ENABLED_KEY = null;
    public static String API_BUILTIN_ENABLED_KEY_CAMEL_CASE = null;
    public static String API_BUILTIN_ENABLED_KEY_SNAKE_CASE = null;
    public static String ARITHMETIC_ENGINE_KEY = null;
    public static String ARITHMETIC_ENGINE_KEY_CAMEL_CASE = null;
    public static String ARITHMETIC_ENGINE_KEY_SNAKE_CASE = null;
    public static String ATTEMPT_EXCEPTION_REPORTER_KEY = null;
    public static String ATTEMPT_EXCEPTION_REPORTER_KEY_CAMEL_CASE = null;
    public static String ATTEMPT_EXCEPTION_REPORTER_KEY_SNAKE_CASE = null;
    public static String AUTO_FLUSH_KEY = null;
    public static String AUTO_FLUSH_KEY_CAMEL_CASE = null;
    public static String AUTO_FLUSH_KEY_SNAKE_CASE = null;
    public static String AUTO_IMPORT_KEY = null;
    public static String AUTO_IMPORT_KEY_CAMEL_CASE = null;
    public static String AUTO_IMPORT_KEY_SNAKE_CASE = null;
    public static String AUTO_INCLUDE_KEY = null;
    public static String AUTO_INCLUDE_KEY_CAMEL_CASE = null;
    public static String AUTO_INCLUDE_KEY_SNAKE_CASE = null;
    public static String BOOLEAN_FORMAT_KEY = null;
    public static String BOOLEAN_FORMAT_KEY_CAMEL_CASE = null;
    public static String BOOLEAN_FORMAT_KEY_SNAKE_CASE = null;
    public static String CLASSIC_COMPATIBLE_KEY = null;
    public static String CLASSIC_COMPATIBLE_KEY_CAMEL_CASE = null;
    public static String CLASSIC_COMPATIBLE_KEY_SNAKE_CASE = null;
    public static String CUSTOM_DATE_FORMATS_KEY = null;
    public static String CUSTOM_DATE_FORMATS_KEY_CAMEL_CASE = null;
    public static String CUSTOM_DATE_FORMATS_KEY_SNAKE_CASE = null;
    public static String CUSTOM_NUMBER_FORMATS_KEY = null;
    public static String CUSTOM_NUMBER_FORMATS_KEY_CAMEL_CASE = null;
    public static String CUSTOM_NUMBER_FORMATS_KEY_SNAKE_CASE = null;
    public static String DATETIME_FORMAT_KEY = null;
    public static String DATETIME_FORMAT_KEY_CAMEL_CASE = null;
    public static String DATETIME_FORMAT_KEY_SNAKE_CASE = null;
    public static String DATE_FORMAT_KEY = null;
    public static String DATE_FORMAT_KEY_CAMEL_CASE = null;
    public static String DATE_FORMAT_KEY_SNAKE_CASE = null;
    public static String LAZY_AUTO_IMPORTS_KEY = null;
    public static String LAZY_AUTO_IMPORTS_KEY_CAMEL_CASE = null;
    public static String LAZY_AUTO_IMPORTS_KEY_SNAKE_CASE = null;
    public static String LAZY_IMPORTS_KEY = null;
    public static String LAZY_IMPORTS_KEY_CAMEL_CASE = null;
    public static String LAZY_IMPORTS_KEY_SNAKE_CASE = null;
    public static String LOCALE_KEY = null;
    public static String LOCALE_KEY_CAMEL_CASE = null;
    public static String LOCALE_KEY_SNAKE_CASE = null;
    public static String LOG_TEMPLATE_EXCEPTIONS_KEY = null;
    public static String LOG_TEMPLATE_EXCEPTIONS_KEY_CAMEL_CASE = null;
    public static String LOG_TEMPLATE_EXCEPTIONS_KEY_SNAKE_CASE = null;
    public static String NEW_BUILTIN_CLASS_RESOLVER_KEY = null;
    public static String NEW_BUILTIN_CLASS_RESOLVER_KEY_CAMEL_CASE = null;
    public static String NEW_BUILTIN_CLASS_RESOLVER_KEY_SNAKE_CASE = null;
    public static String NUMBER_FORMAT_KEY = null;
    public static String NUMBER_FORMAT_KEY_CAMEL_CASE = null;
    public static String NUMBER_FORMAT_KEY_SNAKE_CASE = null;
    public static String OBJECT_WRAPPER_KEY = null;
    public static String OBJECT_WRAPPER_KEY_CAMEL_CASE = null;
    public static String OBJECT_WRAPPER_KEY_SNAKE_CASE = null;
    public static String OUTPUT_ENCODING_KEY = null;
    public static String OUTPUT_ENCODING_KEY_CAMEL_CASE = null;
    public static String OUTPUT_ENCODING_KEY_SNAKE_CASE = null;
    public static String SHOW_ERROR_TIPS_KEY = null;
    public static String SHOW_ERROR_TIPS_KEY_CAMEL_CASE = null;
    public static String SHOW_ERROR_TIPS_KEY_SNAKE_CASE = null;
    public static String SQL_DATE_AND_TIME_TIME_ZONE_KEY = null;
    public static String SQL_DATE_AND_TIME_TIME_ZONE_KEY_CAMEL_CASE = null;
    public static String SQL_DATE_AND_TIME_TIME_ZONE_KEY_SNAKE_CASE = null;
    public static String STRICT_BEAN_MODELS = null;
    public static String STRICT_BEAN_MODELS_KEY = null;
    public static String STRICT_BEAN_MODELS_KEY_CAMEL_CASE = null;
    public static String STRICT_BEAN_MODELS_KEY_SNAKE_CASE = null;
    public static String TEMPLATE_EXCEPTION_HANDLER_KEY = null;
    public static String TEMPLATE_EXCEPTION_HANDLER_KEY_CAMEL_CASE = null;
    public static String TEMPLATE_EXCEPTION_HANDLER_KEY_SNAKE_CASE = null;
    public static String TIME_FORMAT_KEY = null;
    public static String TIME_FORMAT_KEY_CAMEL_CASE = null;
    public static String TIME_FORMAT_KEY_SNAKE_CASE = null;
    public static String TIME_ZONE_KEY = null;
    public static String TIME_ZONE_KEY_CAMEL_CASE = null;
    public static String TIME_ZONE_KEY_SNAKE_CASE = null;
    public static String TRUNCATE_BUILTIN_ALGORITHM_KEY = null;
    public static String TRUNCATE_BUILTIN_ALGORITHM_KEY_CAMEL_CASE = null;
    public static String TRUNCATE_BUILTIN_ALGORITHM_KEY_SNAKE_CASE = null;
    public static String URL_ESCAPING_CHARSET_KEY = null;
    public static String URL_ESCAPING_CHARSET_KEY_CAMEL_CASE = null;
    public static String URL_ESCAPING_CHARSET_KEY_SNAKE_CASE = null;
    public static String WRAP_UNCHECKED_EXCEPTIONS_KEY = null;
    public static String WRAP_UNCHECKED_EXCEPTIONS_KEY_CAMEL_CASE = null;
    public static String WRAP_UNCHECKED_EXCEPTIONS_KEY_SNAKE_CASE = null;
    public void addAutoImport(String p0, String p1){}
    public void addAutoInclude(String p0){}
    public void removeAutoImport(String p0){}
    public void removeAutoInclude(String p0){}
    public void removeCustomAttribute(String p0){}
    public void setAPIBuiltinEnabled(boolean p0){}
    public void setArithmeticEngine(ArithmeticEngine p0){}
    public void setAttemptExceptionReporter(AttemptExceptionReporter p0){}
    public void setAutoFlush(boolean p0){}
    public void setAutoImports(Map p0){}
    public void setAutoIncludes(List p0){}
    public void setBooleanFormat(String p0){}
    public void setClassicCompatible(boolean p0){}
    public void setClassicCompatibleAsInt(int p0){}
    public void setCustomAttribute(String p0, Object p1){}
    public void setCustomDateFormats(Map<String, ? extends TemplateDateFormatFactory> p0){}
    public void setCustomNumberFormats(Map<String, ? extends TemplateNumberFormatFactory> p0){}
    public void setDateFormat(String p0){}
    public void setDateTimeFormat(String p0){}
    public void setLazyAutoImports(Boolean p0){}
    public void setLazyImports(boolean p0){}
    public void setLocale(Locale p0){}
    public void setLogTemplateExceptions(boolean p0){}
    public void setNewBuiltinClassResolver(TemplateClassResolver p0){}
    public void setNumberFormat(String p0){}
    public void setObjectWrapper(ObjectWrapper p0){}
    public void setOutputEncoding(String p0){}
    public void setSQLDateAndTimeTimeZone(TimeZone p0){}
    public void setSetting(String p0, String p1){}
    public void setSettings(InputStream p0){}
    public void setSettings(Properties p0){}
    public void setShowErrorTips(boolean p0){}
    public void setStrictBeanModels(boolean p0){}
    public void setTemplateExceptionHandler(TemplateExceptionHandler p0){}
    public void setTimeFormat(String p0){}
    public void setTimeZone(TimeZone p0){}
    public void setTruncateBuiltinAlgorithm(TruncateBuiltinAlgorithm p0){}
    public void setURLEscapingCharset(String p0){}
    public void setWrapUncheckedExceptions(boolean p0){}
}
