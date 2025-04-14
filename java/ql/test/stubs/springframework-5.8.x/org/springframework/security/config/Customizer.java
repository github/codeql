package org.springframework.security.config;

@FunctionalInterface
public interface Customizer<T> {
  void customize(T t);
}
