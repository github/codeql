/*
 * Bean Validation API
 *
 * License: Apache License, Version 2.0
 * See the license.txt file in the root directory or <http://www.apache.org/licenses/LICENSE-2.0>.
 */
package javax.validation;

/**
 * Payload type that can be attached to a given
 * constraint declaration.
 * <p>
 * Payloads are typically used to carry on metadata information
 * consumed by a validation client.
 * </p>
 * With the exception of the {@link Unwrapping} payload types, the use of payloads is not
 * considered portable.
 *
 * @author Emmanuel Bernard
 * @author Gerhard Petracek
 */
public interface Payload {
}
