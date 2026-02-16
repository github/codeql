/*
 * Bean Validation API
 *
 * License: Apache License, Version 2.0
 * See the license.txt file in the root directory or <http://www.apache.org/licenses/LICENSE-2.0>.
 */
package javax.validation.constraints;

import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.CONSTRUCTOR;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.PARAMETER;
import static java.lang.annotation.ElementType.TYPE_USE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Documented;
import java.lang.annotation.Repeatable;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.constraints.Pattern.List;

/**
 * The annotated {@code CharSequence} must match the specified regular expression.
 * The regular expression follows the Java regular expression conventions
 * see {@link java.util.regex.Pattern}.
 * <p>
 * Accepts {@code CharSequence}. {@code null} elements are considered valid.
 *
 * @author Emmanuel Bernard
 */
@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
@Retention(RUNTIME)
@Repeatable(List.class)
@Documented
@Constraint(validatedBy = { })
public @interface Pattern {

	/**
	 * @return the regular expression to match
	 */
	String regexp();

	/**
	 * @return array of {@code Flag}s considered when resolving the regular expression
	 */
	Flag[] flags() default { };

	/**
	 * @return the error message template
	 */
	String message() default "{javax.validation.constraints.Pattern.message}";

	/**
	 * @return the groups the constraint belongs to
	 */
	Class<?>[] groups() default { };

	/**
	 * @return the payload associated to the constraint
	 */
	Class<? extends Payload>[] payload() default { };

	/**
	 * Possible Regexp flags.
	 */
	public static enum Flag {

		/**
		 * Enables Unix lines mode.
		 *
		 * @see java.util.regex.Pattern#UNIX_LINES
		 */
		UNIX_LINES( java.util.regex.Pattern.UNIX_LINES ),

		/**
		 * Enables case-insensitive matching.
		 *
		 * @see java.util.regex.Pattern#CASE_INSENSITIVE
		 */
		CASE_INSENSITIVE( java.util.regex.Pattern.CASE_INSENSITIVE ),

		/**
		 * Permits whitespace and comments in pattern.
		 *
		 * @see java.util.regex.Pattern#COMMENTS
		 */
		COMMENTS( java.util.regex.Pattern.COMMENTS ),

		/**
		 * Enables multiline mode.
		 *
		 * @see java.util.regex.Pattern#MULTILINE
		 */
		MULTILINE( java.util.regex.Pattern.MULTILINE ),

		/**
		 * Enables dotall mode.
		 *
		 * @see java.util.regex.Pattern#DOTALL
		 */
		DOTALL( java.util.regex.Pattern.DOTALL ),

		/**
		 * Enables Unicode-aware case folding.
		 *
		 * @see java.util.regex.Pattern#UNICODE_CASE
		 */
		UNICODE_CASE( java.util.regex.Pattern.UNICODE_CASE ),

		/**
		 * Enables canonical equivalence.
		 *
		 * @see java.util.regex.Pattern#CANON_EQ
		 */
		CANON_EQ( java.util.regex.Pattern.CANON_EQ );

		//JDK flag value
		private final int value;

		private Flag(int value) {
			this.value = value;
		}

		/**
		 * @return flag value as defined in {@link java.util.regex.Pattern}
		 */
		public int getValue() {
			return value;
		}
	}

	/**
	 * Defines several {@link Pattern} annotations on the same element.
	 *
	 * @see Pattern
	 */
	@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
	@Retention(RUNTIME)
	@Documented
	@interface List {

		Pattern[] value();
	}
}
