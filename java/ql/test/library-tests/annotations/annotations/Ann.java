package annotations;

import java.lang.annotation.Inherited;

@Inherited
public @interface Ann {
	String key();
	String[] unused1() default {};
	String[] unused2() default {};
}
