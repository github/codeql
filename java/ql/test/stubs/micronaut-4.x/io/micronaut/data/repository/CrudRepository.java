package io.micronaut.data.repository;

import java.util.Optional;

public interface CrudRepository<E, ID> extends GenericRepository<E, ID> {
    <S extends E> S save(S entity);
    <S extends E> Iterable<S> saveAll(Iterable<S> entities);
    Optional<E> findById(ID id);
    boolean existsById(ID id);
    Iterable<E> findAll();
    long count();
    void deleteById(ID id);
    void delete(E entity);
    void deleteAll();
}
