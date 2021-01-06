package javax.validation;

import java.time.Clock;

public interface ConstraintValidatorContext {

	
	void disableDefaultConstraintViolation();

	
	String getDefaultConstraintMessageTemplate();

	
	ClockProvider getClockProvider();

	
	ConstraintViolationBuilder buildConstraintViolationWithTemplate(String messageTemplate);

	
	<T> T unwrap(Class<T> type);

	
	interface ConstraintViolationBuilder {

		
		NodeBuilderDefinedContext addNode(String name);

		
		NodeBuilderCustomizableContext addPropertyNode(String name);

		
		LeafNodeBuilderCustomizableContext addBeanNode();

		
		ContainerElementNodeBuilderCustomizableContext addContainerElementNode(String name,
				Class<?> containerType, Integer typeArgumentIndex);

		
		NodeBuilderDefinedContext addParameterNode(int index);

		
		ConstraintValidatorContext addConstraintViolation();

		
		interface LeafNodeBuilderDefinedContext {

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface LeafNodeBuilderCustomizableContext {

			
			LeafNodeContextBuilder inIterable();

			
			LeafNodeBuilderCustomizableContext inContainer(Class<?> containerClass,
														   Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface LeafNodeContextBuilder {

			
			LeafNodeBuilderDefinedContext atKey(Object key);

			
			LeafNodeBuilderDefinedContext atIndex(Integer index);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface NodeBuilderDefinedContext {

			
			NodeBuilderCustomizableContext addNode(String name);

			
			NodeBuilderCustomizableContext addPropertyNode(String name);

			
			LeafNodeBuilderCustomizableContext addBeanNode();

			
			ContainerElementNodeBuilderCustomizableContext addContainerElementNode(
					String name, Class<?> containerType, Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface NodeBuilderCustomizableContext {

			
			NodeContextBuilder inIterable();

			
			NodeBuilderCustomizableContext inContainer(Class<?> containerClass,
													   Integer typeArgumentIndex);

			
			NodeBuilderCustomizableContext addNode(String name);

			
			NodeBuilderCustomizableContext addPropertyNode(String name);

			
			LeafNodeBuilderCustomizableContext addBeanNode();

			
			ContainerElementNodeBuilderCustomizableContext addContainerElementNode(
					String name, Class<?> containerType, Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface NodeContextBuilder {

			
			NodeBuilderDefinedContext atKey(Object key);

			
			NodeBuilderDefinedContext atIndex(Integer index);

			
			NodeBuilderCustomizableContext addNode(String name);

			
			NodeBuilderCustomizableContext addPropertyNode(String name);

			
			LeafNodeBuilderCustomizableContext addBeanNode();

			
			ContainerElementNodeBuilderCustomizableContext addContainerElementNode(
					String name, Class<?> containerType, Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface ContainerElementNodeBuilderDefinedContext {

			
			NodeBuilderCustomizableContext addPropertyNode(String name);

			
			LeafNodeBuilderCustomizableContext addBeanNode();

			
			ContainerElementNodeBuilderCustomizableContext addContainerElementNode(
					String name, Class<?> containerType, Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface ContainerElementNodeBuilderCustomizableContext {

			
			ContainerElementNodeContextBuilder inIterable();

			
			NodeBuilderCustomizableContext addPropertyNode(String name);

			
			LeafNodeBuilderCustomizableContext addBeanNode();

			
			ContainerElementNodeBuilderCustomizableContext addContainerElementNode(
					String name, Class<?> containerType, Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}

		
		interface ContainerElementNodeContextBuilder {

			
			ContainerElementNodeBuilderDefinedContext atKey(Object key);

			
			ContainerElementNodeBuilderDefinedContext atIndex(Integer index);

			
			NodeBuilderCustomizableContext addPropertyNode(String name);

			
			LeafNodeBuilderCustomizableContext addBeanNode();

			
			ContainerElementNodeBuilderCustomizableContext addContainerElementNode(
					String name, Class<?> containerType, Integer typeArgumentIndex);

			
			ConstraintValidatorContext addConstraintViolation();
		}
	}
}

