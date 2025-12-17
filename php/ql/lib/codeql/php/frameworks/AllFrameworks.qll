/**
 * @name All PHP Frameworks
 * @description Unified model for all supported PHP frameworks
 * @kind concept
 */

import codeql.php.frameworks.Core
import codeql.php.frameworks.Laravel
import codeql.php.frameworks.Symfony
import codeql.php.frameworks.CodeIgniter
import codeql.php.frameworks.Yii
import codeql.php.frameworks.CakePHP
import codeql.php.frameworks.ZendLaminas
import codeql.php.frameworks.WordPress
import codeql.php.frameworks.Drupal
import codeql.php.frameworks.Joomla
import codeql.php.frameworks.Magento

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr

/**
 * Framework-agnostic user input source.
 * Matches any method call that retrieves user input from any supported framework.
 */
class FrameworkUserInput extends MethodCall {
  FrameworkUserInput() {
    // Core PHP superglobals are handled separately via SuperglobalVariable
    // Laravel input
    this instanceof LaravelRequestMethodCall or
    // Symfony input
    this instanceof SymfonyRequestParameterAccess or
    // CodeIgniter input
    this instanceof CodeIgniterInputMethod or
    // Yii input
    this instanceof YiiRequestInput or
    // CakePHP input
    this instanceof CakePHPRequestInput or
    // Laminas input
    this instanceof LaminasRequestInput or
    // WordPress input
    this instanceof WordPressUserInput or
    // Drupal input
    this instanceof DrupalUserInput or
    // Joomla input
    this instanceof JoomlaUserInput or
    // Magento input
    this instanceof MagentoUserInput
  }
}

/**
 * Framework-agnostic SQL injection sink.
 * Matches method calls that could lead to SQL injection.
 */
class FrameworkSqlSink extends MethodCall {
  FrameworkSqlSink() {
    // Laravel raw queries
    this instanceof LaravelRawQueryMethod or
    // CodeIgniter unsafe queries
    this instanceof CodeIgniterUnsafeQuery or
    // Yii unsafe queries
    this instanceof YiiUnsafeQuery or
    // CakePHP unsafe queries
    this instanceof CakePHPUnsafeQuery or
    // Laminas unsafe queries
    this instanceof LaminasUnsafeQuery or
    // WordPress unsafe queries
    this instanceof WordPressUnsafeQuery or
    // Drupal unsafe queries
    this instanceof DrupalUnsafeQuery or
    // Joomla unsafe queries
    this instanceof JoomlaUnsafeQuery or
    // Magento unsafe queries
    this instanceof MagentoUnsafeQuery
  }
}

/**
 * Framework-agnostic XSS output sink.
 * Matches method calls that output content that could be vulnerable to XSS.
 */
class FrameworkXssSink extends MethodCall {
  FrameworkXssSink() {
    // CodeIgniter output
    this instanceof CodeIgniterOutput or
    // Yii view render
    this instanceof YiiViewRender or
    // CakePHP view render
    this instanceof CakePHPViewRender or
    // Laminas view render
    this instanceof LaminasViewRender or
    // WordPress output
    this instanceof WordPressOutput or
    // Drupal render
    this instanceof DrupalRender or
    // Joomla output
    this instanceof JoomlaOutput or
    // Magento template output
    this instanceof MagentoTemplateOutput
  }
}

/**
 * Framework-agnostic XSS sanitizer (method calls).
 * Matches method calls that sanitize output.
 */
class FrameworkSanitizer extends MethodCall {
  FrameworkSanitizer() {
    // Core PHP sanitization is handled via SanitizationFunction
    // CodeIgniter escape
    this instanceof CodeIgniterEscape or
    // Laminas escaper
    this instanceof LaminasEscaper or
    // WordPress escape
    this instanceof WordPressEscape or
    // Drupal XSS sanitizer
    this instanceof DrupalXssSanitizer or
    // Joomla XSS sanitizer
    this instanceof JoomlaXssSanitizer or
    // Magento XSS sanitizer
    this instanceof MagentoXssSanitizer
  }
}

/**
 * Framework-agnostic XSS sanitizer (function calls).
 * Matches function calls that sanitize output.
 */
class FrameworkSanitizeFunction extends FunctionCall {
  FrameworkSanitizeFunction() {
    // CakePHP h() function
    this instanceof CakePHPSanitize
  }
}

/**
 * Framework-agnostic static sanitizer.
 * Matches static method calls that sanitize output.
 */
class FrameworkStaticSanitizer extends StaticMethodCall {
  FrameworkStaticSanitizer() {
    // Yii HTML encode
    this instanceof YiiHtmlEncode or
    // Joomla static sanitizer
    this instanceof JoomlaStaticSanitizer
  }
}

/**
 * Framework-agnostic CSRF token check.
 * Matches method calls that verify CSRF tokens.
 */
class FrameworkCsrfCheck extends MethodCall {
  FrameworkCsrfCheck() {
    // CakePHP CSRF check
    this instanceof CakePHPCsrfCheck or
    // WordPress nonce function (for method calls)
    this instanceof WordPressNonceCheck or
    // Drupal token check
    this instanceof DrupalTokenCheck or
    // Joomla token check
    this instanceof JoomlaTokenCheck or
    // Magento token check
    this instanceof MagentoTokenCheck
  }
}
