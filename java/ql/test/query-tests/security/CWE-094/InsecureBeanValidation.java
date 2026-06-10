import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class InsecureBeanValidation implements ConstraintValidator<Override, String> {

    @Override
    public boolean isValid(String object, ConstraintValidatorContext constraintContext) { // $ Source
        String value = object + " is invalid";

        // Bad: Bean properties (normally user-controlled) are passed directly to `buildConstraintViolationWithTemplate`
        constraintContext.buildConstraintViolationWithTemplate(value).addConstraintViolation().disableDefaultConstraintViolation(); // $ Alert

        // Good: Using message parameters
        constraintContext.buildConstraintViolationWithTemplate("literal {message_parameter}").addConstraintViolation().disableDefaultConstraintViolation();
        
        return true;
    }
}
