package org.owasp.esapi;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.owasp.esapi.errors.IntrusionException;
import org.owasp.esapi.errors.ValidationException;

public interface Validator {

    boolean isValidInput(String context, String input, String type, int maxLength, boolean allowNull)
            throws IntrusionException;

    boolean isValidInput(String context, String input, String type, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidInput(String context, String input, String type, int maxLength, boolean allowNull,
            boolean canonicalize) throws IntrusionException;

    boolean isValidInput(String context, String input, String type, int maxLength, boolean allowNull,
            boolean canonicalize, ValidationErrorList errorList) throws IntrusionException;

    String getValidInput(String context, String input, String type, int maxLength, boolean allowNull)
            throws ValidationException, IntrusionException;

    String getValidInput(String context, String input, String type, int maxLength, boolean allowNull,
            boolean canonicalize) throws ValidationException, IntrusionException;

    String getValidInput(String context, String input, String type, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    String getValidInput(String context, String input, String type, int maxLength, boolean allowNull,
            boolean canonicalize, ValidationErrorList errorList) throws IntrusionException;

    boolean isValidDate(String context, String input, DateFormat format, boolean allowNull) throws IntrusionException;

    boolean isValidDate(String context, String input, DateFormat format, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    Date getValidDate(String context, String input, DateFormat format, boolean allowNull)
            throws ValidationException, IntrusionException;

    Date getValidDate(String context, String input, DateFormat format, boolean allowNull, ValidationErrorList errorList)
            throws IntrusionException;

    boolean isValidSafeHTML(String context, String input, int maxLength, boolean allowNull) throws IntrusionException;

    boolean isValidSafeHTML(String context, String input, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    String getValidSafeHTML(String context, String input, int maxLength, boolean allowNull)
            throws ValidationException, IntrusionException;

    String getValidSafeHTML(String context, String input, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidCreditCard(String context, String input, boolean allowNull) throws IntrusionException;

    boolean isValidCreditCard(String context, String input, boolean allowNull, ValidationErrorList errorList)
            throws IntrusionException;

    String getValidCreditCard(String context, String input, boolean allowNull)
            throws ValidationException, IntrusionException;

    String getValidCreditCard(String context, String input, boolean allowNull, ValidationErrorList errorList)
            throws IntrusionException;

    boolean isValidDirectoryPath(String context, String input, File parent, boolean allowNull)
            throws IntrusionException;

    boolean isValidDirectoryPath(String context, String input, File parent, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    String getValidDirectoryPath(String context, String input, File parent, boolean allowNull)
            throws ValidationException, IntrusionException;

    String getValidDirectoryPath(String context, String input, File parent, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidFileName(String context, String input, boolean allowNull) throws IntrusionException;

    boolean isValidFileName(String context, String input, boolean allowNull, ValidationErrorList errorList)
            throws IntrusionException;

    boolean isValidFileName(String context, String input, List<String> allowedExtensions, boolean allowNull)
            throws IntrusionException;

    boolean isValidFileName(String context, String input, List<String> allowedExtensions, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    String getValidFileName(String context, String input, List<String> allowedExtensions, boolean allowNull)
            throws ValidationException, IntrusionException;

    String getValidFileName(String context, String input, List<String> allowedExtensions, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidNumber(String context, String input, long minValue, long maxValue, boolean allowNull)
            throws IntrusionException;

    boolean isValidNumber(String context, String input, long minValue, long maxValue, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    Double getValidNumber(String context, String input, long minValue, long maxValue, boolean allowNull)
            throws ValidationException, IntrusionException;

    Double getValidNumber(String context, String input, long minValue, long maxValue, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidInteger(String context, String input, int minValue, int maxValue, boolean allowNull)
            throws IntrusionException;

    boolean isValidInteger(String context, String input, int minValue, int maxValue, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    Integer getValidInteger(String context, String input, int minValue, int maxValue, boolean allowNull)
            throws ValidationException, IntrusionException;

    Integer getValidInteger(String context, String input, int minValue, int maxValue, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidDouble(String context, String input, double minValue, double maxValue, boolean allowNull)
            throws IntrusionException;

    boolean isValidDouble(String context, String input, double minValue, double maxValue, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    Double getValidDouble(String context, String input, double minValue, double maxValue, boolean allowNull)
            throws ValidationException, IntrusionException;

    Double getValidDouble(String context, String input, double minValue, double maxValue, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidFileContent(String context, byte[] input, int maxBytes, boolean allowNull) throws IntrusionException;

    boolean isValidFileContent(String context, byte[] input, int maxBytes, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    byte[] getValidFileContent(String context, byte[] input, int maxBytes, boolean allowNull)
            throws ValidationException, IntrusionException;

    byte[] getValidFileContent(String context, byte[] input, int maxBytes, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidFileUpload(String context, String filepath, String filename, File parent, byte[] content,
            int maxBytes, boolean allowNull) throws IntrusionException;

    boolean isValidFileUpload(String context, String filepath, String filename, File parent, byte[] content,
            int maxBytes, boolean allowNull, ValidationErrorList errorList) throws IntrusionException;

    void assertValidFileUpload(String context, String filepath, String filename, File parent, byte[] content,
            int maxBytes, List<String> allowedExtensions, boolean allowNull)
            throws ValidationException, IntrusionException;

    void assertValidFileUpload(String context, String filepath, String filename, File parent, byte[] content,
            int maxBytes, List<String> allowedExtensions, boolean allowNull, ValidationErrorList errorList)
            throws IntrusionException;

    boolean isValidListItem(String context, String input, List<String> list) throws IntrusionException;

    boolean isValidListItem(String context, String input, List<String> list, ValidationErrorList errorList)
            throws IntrusionException;

    String getValidListItem(String context, String input, List<String> list)
            throws ValidationException, IntrusionException;

    String getValidListItem(String context, String input, List<String> list, ValidationErrorList errorList)
            throws IntrusionException;

    boolean isValidHTTPRequestParameterSet(String context, HttpServletRequest request, Set<String> required,
            Set<String> optional) throws IntrusionException;

    boolean isValidHTTPRequestParameterSet(String context, HttpServletRequest request, Set<String> required,
            Set<String> optional, ValidationErrorList errorList) throws IntrusionException;

    void assertValidHTTPRequestParameterSet(String context, HttpServletRequest request, Set<String> required,
            Set<String> optional) throws ValidationException, IntrusionException;

    void assertValidHTTPRequestParameterSet(String context, HttpServletRequest request, Set<String> required,
            Set<String> optional, ValidationErrorList errorList) throws IntrusionException;

    boolean isValidPrintable(String context, char[] input, int maxLength, boolean allowNull) throws IntrusionException;

    boolean isValidPrintable(String context, char[] input, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    char[] getValidPrintable(String context, char[] input, int maxLength, boolean allowNull) throws ValidationException;

    char[] getValidPrintable(String context, char[] input, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidPrintable(String context, String input, int maxLength, boolean allowNull) throws IntrusionException;

    boolean isValidPrintable(String context, String input, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    String getValidPrintable(String context, String input, int maxLength, boolean allowNull) throws ValidationException;

    String getValidPrintable(String context, String input, int maxLength, boolean allowNull,
            ValidationErrorList errorList) throws IntrusionException;

    boolean isValidRedirectLocation(String context, String input, boolean allowNull);

    boolean isValidRedirectLocation(String context, String input, boolean allowNull, ValidationErrorList errorList);

    String getValidRedirectLocation(String context, String input, boolean allowNull)
            throws ValidationException, IntrusionException;

    String getValidRedirectLocation(String context, String input, boolean allowNull, ValidationErrorList errorList)
            throws IntrusionException;

    String safeReadLine(InputStream inputStream, int maxLength) throws ValidationException;

    boolean isValidURI(String context, String input, boolean allowNull);

    URI getRfcCompliantURI(String input);

}