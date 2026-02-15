/*
 * Bean Validation API
 *
 * License: Apache License, Version 2.0
 * See the license.txt file in the root directory or <http://www.apache.org/licenses/LICENSE-2.0>.
 */
package javax.validation;

import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * Marks an annotation as being a Bean Validation constraint.
 * <p>
 * A given constraint annotation must be annotated by a {@code @Constraint}
 * annotation which refers to its list of constraint validation implementations.
 * <p>
 * Each constraint annotation must host the following attributes:
 * <ul>
 *     <li>{@code String message() default [...];} which should default to an error
 *     message key made of the fully-qualified class name of the constraint followed by
 *     {@code .message}. For example {@code "{com.acme.constraints.NotSafe.message}"}</li>
 *     <li>{@code Class<?>[] groups() default {};} for user to customize the targeted
 *     groups</li>
 *     <li>{@code Class<? extends Payload>[] payload() default {};} for
 *     extensibility purposes</li>
 * </ul>
 * <p>
 * When building a constraint that is both generic and cross-parameter, the constraint
 * annotation must host the {@code validationAppliesTo()} property.
 * A constraint is generic if it targets the annotated element and is cross-parameter if
 * it targets the array of parameters of a method or constructor.
 * <pre>
 *     ConstraintTarget validationAppliesTo() default ConstraintTarget.IMPLICIT;
 * </pre>
 * This property allows the constraint user to choose whether the constraint
 * targets the return type of the executable or its array of parameters.
 *
 * A constraint is both generic and cross-parameter if
 * <ul>
 *     <li>two kinds of {@code ConstraintValidator}s are attached to the
 *     constraint, one targeting {@link ValidationTarget#ANNOTATED_ELEMENT}
 *     and one targeting {@link ValidationTarget#PARAMETERS},</li>
 *     <li>or if a {@code ConstraintValidator} targets both
 *     {@code ANNOTATED_ELEMENT} and {@code PARAMETERS}.</li>
 * </ul>
 *
 * Such dual constraints are rare. See {@link SupportedValidationTarget} for more info.
 * <p>
 * Here is an example of constraint definition:
 * <pre>
 * &#64;Documented
 * &#64;Constraint(validatedBy = OrderNumberValidator.class)
 * &#64;Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
 * &#64;Retention(RUNTIME)
 * public &#64;interface OrderNumber {
 *     String message() default "{com.acme.constraint.OrderNumber.message}";
 *     Class&lt;?&gt;[] groups() default {};
 *     Class&lt;? extends Payload&gt;[] payload() default {};
 * }
 * </pre>
 *
 * @author Emmanuel Bernard
 * @author Gavin King
 * @author Hardy Ferentschik
 */
@Documented
@Target({ ANNOTATION_TYPE })
@Retention(RUNTIME)
public @interface Constraint {

	/**
	 * {@link ConstraintValidator} classes implementing the constraint. The given classes
	 * must reference distinct target types for a given {@link ValidationTarget}. If two
	 * {@code ConstraintValidator}s refer to the same type, an exception will occur.
	 * <p>
	 * At most one {@code ConstraintValidator} targeting the array of parameters of
	 * methods or constructors (aka cross-parameter) is accepted. If two or more
	 * are present, an exception will occur.
	 *
	 * @return array of {@code ConstraintValidator} classes implementing the constraint
	 */
	Class<?>[] validatedBy();
}
