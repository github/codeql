// Generated automatically from org.springframework.data.domain.Pageable for testing purposes

package org.springframework.data.domain;

import java.util.Optional;
import org.springframework.data.domain.Sort;

public interface Pageable
{
    Pageable first();
    Pageable next();
    Pageable previousOrFirst();
    Pageable withPage(int p0);
    Sort getSort();
    boolean hasPrevious();
    default Optional<Pageable> toOptional(){ return null; }
    default Sort getSortOr(Sort p0){ return null; }
    default boolean isPaged(){ return false; }
    default boolean isUnpaged(){ return false; }
    int getPageNumber();
    int getPageSize();
    long getOffset();
    static Pageable ofSize(int p0){ return null; }
    static Pageable unpaged(){ return null; }
}
