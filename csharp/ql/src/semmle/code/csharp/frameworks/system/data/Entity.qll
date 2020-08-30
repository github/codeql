/**
 * Provides classes related to the Entity Framework namespace `System.Data.Entity`.
 */

private import csharp as csharp
private import semmle.code.csharp.frameworks.system.Data as Data

/** Definitions relating to the `System.Data.Entity` namespace. */
module SystemDataEntity {
  /** The `System.Data.Entity` namespace. */
  class Namespace extends csharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof Data::SystemDataNamespace and
      this.hasName("Entity")
    }
  }

  /** A class in the `System.Data.Entity` namespace. */
  class Class extends csharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** The `System.Data.Entity.DbSet` class. */
  class Database extends Class {
    Database() { this.hasName("Database") }

    /** Gets the `ExecuteSqlCommand` method. */
    csharp::Method getExecuteSqlCommandMethod() { result = this.getAMethod("ExecuteSqlCommand") }

    /** Gets the `ExecuteSqlCommandAsync` method. */
    csharp::Method getExecuteSqlCommandAsyncMethod() {
      result = this.getAMethod("ExecuteSqlCommandAsync")
    }

    /** Gets the `SqlQuery` method. */
    csharp::Method getSqlQueryMethod() { result = this.getAMethod("SqlQuery") }
  }

  /** The `System.Data.Entity.DbSet` class. */
  class DbSet extends Class {
    DbSet() {
      this.getSourceDeclaration().(csharp::UnboundGenericClass).getNameWithoutBrackets() = "DbSet"
    }

    /** Gets the `SqlQuery` method. */
    csharp::Method getSqlQueryMethod() { result = this.getAMethod("SqlQuery") }

    /** Gets the `DbSet` type, if any. */
    csharp::Type getDbSetType() { result = this.(csharp::ConstructedType).getTypeArgument(0) }
  }

  /** The `System.Data.Entity.DbContext` class. */
  class DbContext extends Class {
    DbContext() { this.hasName("DbContext") }
  }

  /** A user provided sub type of `DbContext`. */
  class CustomDbContext extends csharp::Class {
    CustomDbContext() {
      this.fromSource() and
      this.getABaseType+() instanceof DbContext
    }

    /** Gets a property that has the type `DbSet`. */
    csharp::Property getADbSetProperty() {
      result = this.getAProperty() and
      result.getType() instanceof DbSet
    }
  }

  /** An Entity Framework entity, as referenced from a `CustomDbContext`. */
  class Entity extends csharp::Class {
    Entity() {
      exists(CustomDbContext dbContext, csharp::Property p |
        p = dbContext.getADbSetProperty() and
        this = p.getType().(DbSet).getDbSetType()
      )
    }
  }
}

/** Definitions relating to the `System.Data.Entity.Infrastructure` namespace. */
module SystemDataEntityInfrastructure {
  /** The `System.Data.Entity.Infrastructure` namespace. */
  class Namespace extends csharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof SystemDataEntity::Namespace and
      this.hasName("Infrastructure")
    }
  }

  /** A class in the `System.Data.Entity.Infrastructure` namespace. */
  class Class extends csharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** A class that extends or is constructed from `System.Entity.Data.Infrastructure.DbRawSqlQuery`. */
  class DbRawSqlQuery extends Class {
    DbRawSqlQuery() {
      this
          .getABaseType*()
          .getSourceDeclaration()
          .(csharp::UnboundGenericClass)
          .getNameWithoutBrackets() = "DbRawSqlQuery"
    }
  }
}
