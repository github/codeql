import java

query predicate genericType(TypeVariable tv, RefType rt) { tv.getGenericType() = rt }

query predicate genericFunction(TypeVariable tv, GenericCallable c) { tv.getGenericCallable() = c }
