package reflection;

import java.lang.annotation.Annotation;

public class ReflectiveAccess {
	public static @interface TestAnnotation {
	}

	@TestAnnotation
	public static class TestClass {
	}

	public static <A extends Annotation> A getAnnotation(Class<?> classContainingAnnotation, Class<A> annotationClass) {
		return classContainingAnnotation.getAnnotation(annotationClass);
	}

	public static void main(String[] args) {
		Class<?> testClass = Class.forName("reflection.ReflectiveAccess$TestClass");

		testClass.newInstance();

		getAnnotation(TestClass.class, TestAnnotation.class);
	}
}
