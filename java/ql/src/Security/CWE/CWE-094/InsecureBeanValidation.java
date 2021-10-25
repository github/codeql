import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import org.hibernate.validator.constraintvalidation.HibernateConstraintValidatorContext;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TestValidator implements ConstraintValidator<Object, String> {

    public static class InterpolationHelper {

        public static final char BEGIN_TERM = '{';
        public static final char END_TERM = '}';
        public static final char EL_DESIGNATOR = '$';
        public static final char ESCAPE_CHARACTER = '\\';

        private static final Pattern ESCAPE_MESSAGE_PARAMETER_PATTERN = Pattern.compile( "([\\" + ESCAPE_CHARACTER + BEGIN_TERM + END_TERM + EL_DESIGNATOR + "])" );

        private InterpolationHelper() {
        }

        public static String escapeMessageParameter(String messageParameter) {
            if ( messageParameter == null ) {
                return null;
            }
            return ESCAPE_MESSAGE_PARAMETER_PATTERN.matcher( messageParameter ).replaceAll( Matcher.quoteReplacement( String.valueOf( ESCAPE_CHARACTER ) ) + "$1" );
        }

    }

    @Override
    public boolean isValid(String object, ConstraintValidatorContext constraintContext) {
        String value = object + " is invalid";

        // Bad: Bean properties (normally user-controlled) are passed directly to `buildConstraintViolationWithTemplate`
        constraintContext.buildConstraintViolationWithTemplate(value).addConstraintViolation().disableDefaultConstraintViolation();

        // Good: Bean properties (normally user-controlled) are escaped 
        String escaped = InterpolationHelper.escapeMessageParameter(value);
        constraintContext.buildConstraintViolationWithTemplate(escaped).addConstraintViolation().disableDefaultConstraintViolation();

        // Good: Bean properties (normally user-controlled) are parameterized
        HibernateConstraintValidatorContext context = constraintContext.unwrap( HibernateConstraintValidatorContext.class );
        context.addMessageParameter( "prop", object );
        context.buildConstraintViolationWithTemplate( "{prop} is invalid").addConstraintViolation();
        return false;
    }

}
