package org.springframework.context;

@FunctionalInterface
public interface ApplicationEventPublisher {
  void publishEvent(Object event);
}
