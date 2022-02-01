/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249
private import semmle.python.frameworks.Stdlib
private import semmle.python.regex
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.SelfRefMixin
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */
module Django {
  /** Provides models for the `django.views` module */
  module Views {
    /**
     * Provides models for the `django.views.generic.View` class and subclasses.
     *
     * See
     *  - https://docs.djangoproject.com/en/3.1/topics/class-based-views/
     *  - https://docs.djangoproject.com/en/3.1/ref/class-based-views/
     */
    module View {
      /**
       * An `API::Node` representing the `django.views.generic.View` class or any subclass
       * that has explicitly been modeled in the CodeQL libraries.
       */
      abstract class ModeledSubclass extends API::Node {
        override string toString() { result = this.(API::Node).toString() }
      }

      /** A Django view subclass in the `django` package. */
      private class DjangoViewSubclassesInDjango extends ModeledSubclass {
        DjangoViewSubclassesInDjango() {
          exists(string moduleName, string className |
            // canonical definition
            this =
              API::moduleImport("django")
                  .getMember("views")
                  .getMember("generic")
                  .getMember(moduleName)
                  .getMember(className)
            or
            // aliases from `django.views.generic`
            this =
              API::moduleImport("django")
                  .getMember("views")
                  .getMember("generic")
                  .getMember(className)
          |
            moduleName = "base" and
            className in ["RedirectView", "TemplateView", "View"]
            or
            moduleName = "dates" and
            className in [
                "ArchiveIndexView", "DateDetailView", "DayArchiveView", "MonthArchiveView",
                "TodayArchiveView", "WeekArchiveView", "YearArchiveView"
              ]
            or
            moduleName = "detail" and
            className = "DetailView"
            or
            moduleName = "edit" and
            className in ["CreateView", "DeleteView", "FormView", "UpdateView"]
            or
            moduleName = "list" and
            className = "ListView"
          )
          or
          // `django.views.View` alias
          this = API::moduleImport("django").getMember("views").getMember("View")
        }
      }

      /** Gets a reference to the `django.views.generic.View` class or any subclass. */
      API::Node subclassRef() { result = any(ModeledSubclass subclass).getASubclass*() }
    }
  }

  /** Provides models for django forms (defined in the `django.forms` module) */
  module Forms {
    /**
     * Provides models for the `django.forms.forms.BaseForm` class and subclasses. This
     * is usually used by the `django.forms.forms.Form` class, which is also available
     * under the more commonly used alias `django.forms.Form`.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/forms/api/
     */
    module Form {
      /**
       * An `API::Node` representing the `django.forms.forms.BaseForm` class or any subclass
       * that has explicitly been modeled in the CodeQL libraries.
       */
      abstract class ModeledSubclass extends API::Node {
        override string toString() { result = this.(API::Node).toString() }
      }

      /** A Django form subclass in the `django` package. */
      private class DjangoFormSubclassesInDjango extends ModeledSubclass {
        DjangoFormSubclassesInDjango() {
          // canonical definition
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("forms")
                .getMember(["BaseForm", "Form"])
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("models")
                .getMember(["BaseModelForm", "ModelForm"])
          or
          // aliases from `django.forms`
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember(["BaseForm", "Form", "BaseModelForm", "ModelForm"])
          or
          // other Form subclasses defined in Django
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("admin")
                .getMember("forms")
                .getMember(["AdminAuthenticationForm", "AdminPasswordChangeForm"])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("admin")
                .getMember("helpers")
                .getMember("ActionForm")
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("admin")
                .getMember("views")
                .getMember("main")
                .getMember("ChangeListSearchForm")
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("auth")
                .getMember("forms")
                .getMember([
                    "PasswordResetForm", "UserChangeForm", "SetPasswordForm",
                    "AdminPasswordChangeForm", "PasswordChangeForm", "AuthenticationForm",
                    "UserCreationForm"
                  ])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("flatpages")
                .getMember("forms")
                .getMember("FlatpageForm")
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("formsets")
                .getMember("ManagementForm")
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("models")
                .getMember(["ModelForm", "BaseModelForm"])
        }
      }

      /** Gets a reference to the `django.forms.forms.BaseForm` class or any subclass. */
      API::Node subclassRef() { result = any(ModeledSubclass subclass).getASubclass*() }
    }

    /**
     * Provides models for the `django.forms.fields.Field` class and subclasses. This is
     * also available under the more commonly used alias `django.forms.Field`.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/forms/fields/
     */
    module Field {
      /**
       * An `API::Node` representing the `django.forms.fields.Field` class or any subclass
       * that has explicitly been modeled in the CodeQL libraries.
       */
      abstract class ModeledSubclass extends API::Node {
        override string toString() { result = this.(API::Node).toString() }
      }

      /** A Django field subclass in the `django` package. */
      private class DjangoFieldSubclassesInDjango extends ModeledSubclass {
        DjangoFieldSubclassesInDjango() {
          exists(string moduleName, string className |
            // canonical definition
            this =
              API::moduleImport("django")
                  .getMember("forms")
                  .getMember(moduleName)
                  .getMember(className)
            or
            // aliases from `django.forms`
            this = API::moduleImport("django").getMember("forms").getMember(className)
          |
            moduleName = "fields" and
            className in [
                "Field",
                // Known subclasses
                "BooleanField", "IntegerField", "CharField", "SlugField", "DateTimeField",
                "EmailField", "DateField", "TimeField", "DurationField", "DecimalField",
                "FloatField", "GenericIPAddressField", "UUIDField", "JSONField", "FilePathField",
                "NullBooleanField", "URLField", "TypedChoiceField", "FileField", "ImageField",
                "RegexField", "ChoiceField", "MultipleChoiceField", "ComboField", "MultiValueField",
                "SplitDateTimeField", "TypedMultipleChoiceField", "BaseTemporalField"
              ]
            or
            // Known subclasses from `django.forms.models`
            moduleName = "models" and
            className in ["ModelChoiceField", "ModelMultipleChoiceField", "InlineForeignKeyField"]
          )
          or
          // other Field subclasses defined in Django
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("auth")
                .getMember("forms")
                .getMember(["ReadOnlyPasswordHashField", "UsernameField"])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("gis")
                .getMember("forms")
                .getMember("fields")
                .getMember([
                    "GeometryCollectionField", "GeometryField", "LineStringField",
                    "MultiLineStringField", "MultiPointField", "MultiPolygonField", "PointField",
                    "PolygonField"
                  ])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("postgres")
                .getMember("forms")
                .getMember("array")
                .getMember(["SimpleArrayField", "SplitArrayField"])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("postgres")
                .getMember("forms")
                .getMember("hstore")
                .getMember("HStoreField")
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("postgres")
                .getMember("forms")
                .getMember("ranges")
                .getMember([
                    "BaseRangeField", "DateRangeField", "DateTimeRangeField", "DecimalRangeField",
                    "IntegerRangeField"
                  ])
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("models")
                .getMember(["InlineForeignKeyField", "ModelChoiceField", "ModelMultipleChoiceField"])
        }
      }

      /** Gets a reference to the `django.forms.fields.Field` class or any subclass. */
      API::Node subclassRef() { result = any(ModeledSubclass subclass).getASubclass*() }
    }
  }

  /**
   * Provides models for the `django.utils.datastructures.MultiValueDict` class
   *
   * See
   * - https://docs.djangoproject.com/en/3.0/ref/request-response/#django.http.QueryDict (subclass that has proper docs)
   * - https://www.kite.com/python/docs/django.utils.datastructures.MultiValueDict
   */
  module MultiValueDict {
    /** Gets a reference to the `django.utils.datastructures.MultiValueDict` class. */
    private API::Node classRef() {
      result =
        API::moduleImport("django")
            .getMember("utils")
            .getMember("datastructures")
            .getMember("MultiValueDict")
    }

    /**
     * A source of instances of `django.utils.datastructures.MultiValueDict`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `MultiValueDict::instance()` to get references to instances of `django.utils.datastructures.MultiValueDict`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `django.utils.datastructures.MultiValueDict`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `django.utils.datastructures.MultiValueDict`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.utils.datastructures.MultiValueDict`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.utils.datastructures.MultiValueDict`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.utils.datastructures.MultiValueDict" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() {
        result in ["getlist", "lists", "popitem", "dict", "urlencode"]
      }

      override string getAsyncMethodName() { none() }
    }

    /**
     * Extra taint propagation for `django.utils.datastructures.MultiValueDict`, not covered by `InstanceTaintSteps`.
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // class instantiation
        exists(ClassInstantiation call |
          nodeFrom = call.getArg(0) and
          nodeTo = call
        )
      }
    }
  }

  /**
   * Provides models for the `django.contrib.auth.models.User` class
   *
   * See https://docs.djangoproject.com/en/3.2/ref/contrib/auth/#user-model.
   */
  module User {
    /**
     * A source of instances of `django.contrib.auth.models.User`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `User::instance()` to get references to instances of `django.contrib.auth.models.User`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `django.contrib.auth.models.User`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.contrib.auth.models.User`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.contrib.auth.models.User`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.contrib.auth.models.User" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in ["username", "first_name", "last_name", "email"]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }
  }

  /**
   * Provides models for the `django.core.files.uploadedfile.UploadedFile` class
   *
   * See https://docs.djangoproject.com/en/3.0/ref/files/uploads/#django.core.files.uploadedfile.UploadedFile.
   */
  module UploadedFile {
    /**
     * A source of instances of `django.core.files.uploadedfile.UploadedFile`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `UploadedFile::instance()` to get references to instances of `django.core.files.uploadedfile.UploadedFile`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `django.core.files.uploadedfile.UploadedFile`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.core.files.uploadedfile.UploadedFile`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.core.files.uploadedfile.UploadedFile`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.core.files.uploadedfile.UploadedFile" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "content_type", "content_type_extra", "content_type_extra", "charset", "name", "file"
          ]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }

    /** A file-like object instance that originates from a `UploadedFile`. */
    class UploadedFileFileLikeInstances extends Stdlib::FileLikeObject::InstanceSource {
      UploadedFileFileLikeInstances() { this.(DataFlow::AttrRead).accesses(instance(), "file") }
    }
  }

  /**
   * Provides models for the `django.urls.ResolverMatch` class
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urlresolvers/#django.urls.ResolverMatch.
   */
  module ResolverMatch {
    /**
     * A source of instances of `django.urls.ResolverMatch`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `ResolverMatch::instance()` to get references to instances of `django.urls.ResolverMatch`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `django.urls.ResolverMatch`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.urls.ResolverMatch`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.urls.ResolverMatch`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.urls.ResolverMatch" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { result in ["args", "kwargs"] }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `django` PyPI package (that we are not quite ready to publicly expose yet).
 * See https://www.djangoproject.com/.
 */
module PrivateDjango {
  // ---------------------------------------------------------------------------
  // django
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `django` module. */
  API::Node django() { result = API::moduleImport("django") }

  /** Provides models for the `django` module. */
  module django {
    // -------------------------------------------------------------------------
    // django.db
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.db` module. */
    API::Node db() { result = django().getMember("db") }

    /**
     * `django.db` implements PEP249, providing ways to execute SQL statements against a database.
     */
    private class DjangoDb extends PEP249::PEP249ModuleApiNode {
      DjangoDb() { this = API::moduleImport("django").getMember("db") }
    }

    /** Provides models for the `django.db` module. */
    module db {
      /** Gets a reference to the `django.db.connection` object. */
      API::Node connection() { result = db().getMember("connection") }

      /** A `django.db.connection` is a PEP249 compliant DB connection. */
      class DjangoDbConnection extends PEP249::Connection::InstanceSource {
        DjangoDbConnection() { this = connection().getAUse() }
      }

      // -------------------------------------------------------------------------
      // django.db.models
      // -------------------------------------------------------------------------
      /** Gets a reference to the `django.db.models` module. */
      API::Node models() { result = db().getMember("models") }

      /** Provides models for the `django.db.models` module. */
      module models {
        /**
         * Provides models for the `django.db.models.Model` class and subclasses.
         *
         * See https://docs.djangoproject.com/en/3.1/topics/db/models/.
         */
        module Model {
          /** Gets a reference to the `flask.views.View` class or any subclass. */
          API::Node subclassRef() {
            result =
              API::moduleImport("django")
                  .getMember("db")
                  .getMember("models")
                  .getMember("Model")
                  .getASubclass*()
          }
        }

        /**
         * Gets a reference to the Manager (django.db.models.Manager) for a django Model,
         * accessed by `<ModelName>.objects`.
         */
        API::Node manager() { result = Model::subclassRef().getMember("objects") }

        /**
         * Gets a method with `name` that returns a QuerySet.
         * This method can originate on a QuerySet or a Manager.
         *
         * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/
         */
        API::Node querySetReturningMethod(string name) {
          name in [
              "none", "all", "filter", "exclude", "complex_filter", "union", "intersection",
              "difference", "select_for_update", "select_related", "prefetch_related", "order_by",
              "distinct", "reverse", "defer", "only", "using", "annotate", "extra", "raw",
              "datetimes", "dates", "values", "values_list", "alias"
            ] and
          result = [manager(), querySet()].getMember(name)
        }

        /**
         * Gets a reference to a QuerySet (django.db.models.query.QuerySet).
         *
         * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/
         */
        API::Node querySet() { result = querySetReturningMethod(_).getReturn() }

        /** Gets a reference to the `django.db.models.expressions` module. */
        API::Node expressions() { result = models().getMember("expressions") }

        /** Provides models for the `django.db.models.expressions` module. */
        module expressions {
          /** Provides models for the `django.db.models.expressions.RawSQL` class. */
          module RawSQL {
            /**
             * Gets an reference to the `django.db.models.expressions.RawSQL` class.
             */
            API::Node classRef() {
              result = expressions().getMember("RawSQL")
              or
              // Commonly used alias
              result = models().getMember("RawSQL")
            }

            /**
             * Gets an instance of the `django.db.models.expressions.RawSQL` class,
             * that was initiated with the SQL represented by `sql`.
             */
            private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t, DataFlow::Node sql) {
              t.start() and
              exists(DataFlow::CallCfgNode c | result = c |
                c = classRef().getACall() and
                c.getArg(0) = sql
              )
              or
              exists(DataFlow::TypeTracker t2 | result = instance(t2, sql).track(t2, t))
            }

            /**
             * Gets an instance of the `django.db.models.expressions.RawSQL` class,
             * that was initiated with the SQL represented by `sql`.
             */
            DataFlow::Node instance(DataFlow::Node sql) {
              instance(DataFlow::TypeTracker::end(), sql).flowsTo(result)
            }
          }
        }
      }
    }

    /**
     * A call to the `annotate` function on a model using a `RawSQL` argument.
     *
     * TODO: Consider reworking this to use taint tracking.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/#annotate
     */
    private class ObjectsAnnotate extends SqlExecution::Range, DataFlow::CallCfgNode {
      DataFlow::Node sql;

      ObjectsAnnotate() {
        this = django::db::models::querySetReturningMethod("annotate").getACall() and
        django::db::models::expressions::RawSQL::instance(sql) in [
            this.getArg(_), this.getArgByName(_)
          ]
      }

      override DataFlow::Node getSql() { result = sql }
    }

    /**
     * A call to the `alias` function on a model using a `RawSQL` argument.
     *
     * See https://docs.djangoproject.com/en/3.2/ref/models/querysets/#alias
     */
    private class ObjectsAlias extends SqlExecution::Range, DataFlow::CallCfgNode {
      DataFlow::Node sql;

      ObjectsAlias() {
        this = django::db::models::querySetReturningMethod("alias").getACall() and
        django::db::models::expressions::RawSQL::instance(sql) in [
            this.getArg(_), this.getArgByName(_)
          ]
      }

      override DataFlow::Node getSql() { result = sql }
    }

    /**
     * A call to the `raw` function on a model.
     *
     * See
     * - https://docs.djangoproject.com/en/3.1/topics/db/sql/#django.db.models.Manager.raw
     * - https://docs.djangoproject.com/en/3.1/ref/models/querysets/#raw
     */
    private class ObjectsRaw extends SqlExecution::Range, DataFlow::CallCfgNode {
      ObjectsRaw() { this = django::db::models::querySetReturningMethod("raw").getACall() }

      override DataFlow::Node getSql() { result = this.getArg(0) }
    }

    /**
     * A call to the `extra` function on a model.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/#extra
     */
    private class ObjectsExtra extends SqlExecution::Range, DataFlow::CallCfgNode {
      ObjectsExtra() { this = django::db::models::querySetReturningMethod("extra").getACall() }

      override DataFlow::Node getSql() {
        result in [
            this.getArg([0, 1, 3, 4]), this.getArgByName(["select", "where", "tables", "order_by"])
          ]
      }
    }

    // -------------------------------------------------------------------------
    // django.urls
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.urls` module. */
    API::Node urls() { result = django().getMember("urls") }

    /** Provides models for the `django.urls` module */
    module urls {
      /**
       * Gets a reference to the `django.urls.path` function.
       * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
       */
      API::Node path() { result = urls().getMember("path") }

      /**
       * Gets a reference to the `django.urls.re_path` function.
       * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
       */
      API::Node re_path() { result = urls().getMember("re_path") }
    }

    // -------------------------------------------------------------------------
    // django.conf
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.conf` module. */
    API::Node conf() { result = django().getMember("conf") }

    /** Provides models for the `django.conf` module */
    module conf {
      /** Provides models for the `django.conf.urls` module */
      module conf_urls {
        // -------------------------------------------------------------------------
        // django.conf.urls
        // -------------------------------------------------------------------------
        // NOTE: had to rename due to shadowing rules in QL
        /** Gets a reference to the `django.conf.urls` module. */
        API::Node conf_urls() { result = conf().getMember("urls") }

        /**
         * Gets a reference to the `django.conf.urls.url` function.
         *
         * See https://docs.djangoproject.com/en/1.11/ref/urls/#django.conf.urls.url
         */
        API::Node url() { result = conf_urls().getMember("url") }
      }
    }

    // -------------------------------------------------------------------------
    // django.http
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.http` module. */
    API::Node http() { result = django().getMember("http") }

    /** Provides models for the `django.http` module */
    module http {
      // ---------------------------------------------------------------------------
      // django.http.request
      // ---------------------------------------------------------------------------
      /** Gets a reference to the `django.http.request` module. */
      API::Node request() { result = http().getMember("request") }

      /** Provides models for the `django.http.request` module. */
      module request {
        /**
         * Provides models for the `django.http.request.HttpRequest` class
         *
         * See https://docs.djangoproject.com/en/3.0/ref/request-response/#httprequest-objects
         */
        module HttpRequest {
          /** Gets a reference to the `django.http.request.HttpRequest` class. */
          API::Node classRef() {
            result = request().getMember("HttpRequest")
            or
            // handle django.http.HttpRequest alias
            result = http().getMember("HttpRequest")
          }

          /**
           * A source of instances of `django.http.request.HttpRequest`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use `django::http::request::HttpRequest::instance()` predicate to get
           * references to instances of `django.http.request.HttpRequest`.
           */
          abstract class InstanceSource extends DataFlow::Node { }

          /** Gets a reference to an instance of `django.http.request.HttpRequest`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.request.HttpRequest`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

          /**
           * Taint propagation for `django.http.request.HttpRequest`.
           */
          private class InstanceTaintSteps extends InstanceTaintStepsHelper {
            InstanceTaintSteps() { this = "django.http.request.HttpRequest" }

            override DataFlow::Node getInstance() { result = instance() }

            override string getAttributeName() {
              result in [
                  // str / bytes
                  "body", "path", "path_info", "method", "encoding", "content_type",
                  // django.http.QueryDict
                  "GET", "POST",
                  // dict[str, str]
                  "content_params", "COOKIES",
                  // dict[str, Any]
                  "META",
                  // HttpHeaders (case insensitive dict-like)
                  "headers",
                  // MultiValueDict[str, UploadedFile]
                  "FILES",
                  // django.urls.ResolverMatch
                  "resolver_match"
                ]
              // TODO: Handle that a HttpRequest is iterable
            }

            override string getMethodName() {
              result in ["get_full_path", "get_full_path_info", "read", "readline", "readlines"]
            }

            override string getAsyncMethodName() { none() }
          }

          /**
           * Extra taint propagation for `django.http.request.HttpRequest`, not covered by `InstanceTaintSteps`.
           */
          private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
            override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
              // special handling of the `build_absolute_uri` method, see
              // https://docs.djangoproject.com/en/3.0/ref/request-response/#django.http.HttpRequest.build_absolute_uri
              exists(DataFlow::AttrRead attr, DataFlow::CallCfgNode call, DataFlow::Node instance |
                instance = django::http::request::HttpRequest::instance() and
                attr.getObject() = instance
              |
                attr.getAttributeName() = "build_absolute_uri" and
                nodeTo.(DataFlow::CallCfgNode).getFunction() = attr and
                call = nodeTo and
                (
                  not exists(call.getArg(_)) and
                  not exists(call.getArgByName(_)) and
                  nodeFrom = instance
                  or
                  nodeFrom = call.getArg(0)
                  or
                  nodeFrom = call.getArgByName("location")
                )
              )
            }
          }

          /** An attribute read on an django request that is a `MultiValueDict` instance. */
          private class DjangoHttpRequestMultiValueDictInstances extends Django::MultiValueDict::InstanceSource {
            DjangoHttpRequestMultiValueDictInstances() {
              this.(DataFlow::AttrRead).getObject() = instance() and
              this.(DataFlow::AttrRead).getAttributeName() in ["GET", "POST", "FILES"]
            }
          }

          /** An attribute read on an django request that is a `ResolverMatch` instance. */
          private class DjangoHttpRequestResolverMatchInstances extends Django::ResolverMatch::InstanceSource {
            DjangoHttpRequestResolverMatchInstances() {
              this.(DataFlow::AttrRead).getObject() = instance() and
              this.(DataFlow::AttrRead).getAttributeName() = "resolver_match"
            }
          }

          /** An `UploadedFile` instance that originates from a django request. */
          private class DjangoHttpRequestUploadedFileInstances extends Django::UploadedFile::InstanceSource {
            DjangoHttpRequestUploadedFileInstances() {
              // TODO: this currently only works in local-scope, since writing type-trackers for
              // this is a little too much effort. Once API-graphs are available for more
              // things, we can rewrite this.
              //
              // TODO: This approach for identifying member-access is very adhoc, and we should
              // be able to do something more structured for providing modeling of the members
              // of a container-object.
              //
              // dicts
              exists(DataFlow::AttrRead files, DataFlow::Node dict |
                files.accesses(instance(), "FILES") and
                (
                  dict = files
                  or
                  dict.(DataFlow::MethodCallNode).calls(files, "dict")
                )
              |
                this.asCfgNode().(SubscriptNode).getObject() = dict.asCfgNode()
                or
                this.(DataFlow::MethodCallNode).calls(dict, "get")
              )
              or
              // getlist
              exists(DataFlow::AttrRead files, DataFlow::MethodCallNode getlistCall |
                files.accesses(instance(), "FILES") and
                getlistCall.calls(files, "getlist") and
                this.asCfgNode().(SubscriptNode).getObject() = getlistCall.asCfgNode()
              )
            }
          }
        }
      }

      // -------------------------------------------------------------------------
      // django.http.response
      // -------------------------------------------------------------------------
      /** Gets a reference to the `django.http.response` module. */
      API::Node response() { result = http().getMember("response") }

      /** Provides models for the `django.http.response` module */
      module response {
        /**
         * Provides models for the `django.http.response.HttpResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponse.
         */
        module HttpResponse {
          /** Gets a reference to the `django.http.response.HttpResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponse")
            or
            // Handle `django.http.HttpResponse` alias
            result = http().getMember("HttpResponse")
          }

          /** Gets a reference to the `django.http.response.HttpResponse` class or any subclass. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponse::instance()` to get references to instances of `django.http.response.HttpResponse`.
           */
          abstract class InstanceSource extends HTTP::Server::HttpResponse::Range, DataFlow::Node {
          }

          /** A direct instantiation of `django.http.response.HttpResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() {
              result in [this.getArg(1), this.getArgByName("content_type")]
            }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        // ---------------------------------------------------------------------------
        // HttpResponse subclasses
        // see https://docs.djangoproject.com/en/3.1/ref/request-response/#httpresponse-subclasses
        // ---------------------------------------------------------------------------
        /**
         * Provides models for the `django.http.response.HttpResponseRedirect` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseRedirect.
         */
        module HttpResponseRedirect {
          /** Gets a reference to the `django.http.response.HttpResponseRedirect` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseRedirect")
            or
            // Handle `django.http.HttpResponseRedirect` alias
            result = http().getMember("HttpResponseRedirect")
          }

          /** Gets a reference to a subclass of the `django.http.response.HttpResponseRedirect` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseRedirect`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseRedirect::instance()` to get references to instances of `django.http.response.HttpResponseRedirect`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource,
            HTTP::Server::HttpRedirectResponse::Range, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseRedirect`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              // note that even though browsers like Chrome usually doesn't fetch the
              // content of a redirect, it is possible to observe the body (for example,
              // with cURL).
              result in [this.getArg(1), this.getArgByName("content")]
            }

            override DataFlow::Node getRedirectLocation() {
              result in [this.getArg(0), this.getArgByName("redirect_to")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseRedirect`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseRedirect`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponsePermanentRedirect` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponsePermanentRedirect.
         */
        module HttpResponsePermanentRedirect {
          /** Gets a reference to the `django.http.response.HttpResponsePermanentRedirect` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponsePermanentRedirect")
            or
            // Handle `django.http.HttpResponsePermanentRedirect` alias
            result = http().getMember("HttpResponsePermanentRedirect")
          }

          /** Gets a reference to the `django.http.response.HttpResponsePermanentRedirect` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponsePermanentRedirect`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponsePermanentRedirect::instance()` to get references to instances of `django.http.response.HttpResponsePermanentRedirect`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource,
            HTTP::Server::HttpRedirectResponse::Range, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponsePermanentRedirect`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              // note that even though browsers like Chrome usually doesn't fetch the
              // content of a redirect, it is possible to observe the body (for example,
              // with cURL).
              result in [this.getArg(1), this.getArgByName("content")]
            }

            override DataFlow::Node getRedirectLocation() {
              result in [this.getArg(0), this.getArgByName("redirect_to")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponsePermanentRedirect`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponsePermanentRedirect`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseNotModified` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseNotModified.
         */
        module HttpResponseNotModified {
          /** Gets a reference to the `django.http.response.HttpResponseNotModified` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseNotModified")
            or
            // TODO: remove/expand this part of the template as needed
            // Handle `django.http.HttpResponseNotModified` alias
            result = http().getMember("HttpResponseNotModified")
          }

          /** Gets a reference to the `django.http.response.HttpResponseNotModified` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseNotModified`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseNotModified::instance()` to get references to instances of `django.http.response.HttpResponseNotModified`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseNotModified`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() { none() }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { none() }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotModified`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotModified`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseBadRequest` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseBadRequest.
         */
        module HttpResponseBadRequest {
          /** Gets a reference to the `django.http.response.HttpResponseBadRequest` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseBadRequest")
            or
            // Handle `django.http.HttpResponseBadRequest` alias
            result = http().getMember("HttpResponseBadRequest")
          }

          /** Gets a reference to the `django.http.response.HttpResponseBadRequest` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseBadRequest`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseBadRequest::instance()` to get references to instances of `django.http.response.HttpResponseBadRequest`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseBadRequest`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseBadRequest`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseBadRequest`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseNotFound` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseNotFound.
         */
        module HttpResponseNotFound {
          /** Gets a reference to the `django.http.response.HttpResponseNotFound` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseNotFound")
            or
            // Handle `django.http.HttpResponseNotFound` alias
            result = http().getMember("HttpResponseNotFound")
          }

          /** Gets a reference to the `django.http.response.HttpResponseNotFound` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseNotFound`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseNotFound::instance()` to get references to instances of `django.http.response.HttpResponseNotFound`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseNotFound`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotFound`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotFound`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseForbidden` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseForbidden.
         */
        module HttpResponseForbidden {
          /** Gets a reference to the `django.http.response.HttpResponseForbidden` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseForbidden")
            or
            // Handle `django.http.HttpResponseForbidden` alias
            result = http().getMember("HttpResponseForbidden")
          }

          /** Gets a reference to the `django.http.response.HttpResponseForbidden` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseForbidden`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseForbidden::instance()` to get references to instances of `django.http.response.HttpResponseForbidden`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseForbidden`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseForbidden`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseForbidden`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseNotAllowed` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseNotAllowed.
         */
        module HttpResponseNotAllowed {
          /** Gets a reference to the `django.http.response.HttpResponseNotAllowed` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseNotAllowed")
            or
            // Handle `django.http.HttpResponseNotAllowed` alias
            result = http().getMember("HttpResponseNotAllowed")
          }

          /** Gets a reference to the `django.http.response.HttpResponseNotAllowed` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseNotAllowed`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseNotAllowed::instance()` to get references to instances of `django.http.response.HttpResponseNotAllowed`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseNotAllowed`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              // First argument is permitted methods
              result in [this.getArg(1), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotAllowed`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotAllowed`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseGone` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseGone.
         */
        module HttpResponseGone {
          /** Gets a reference to the `django.http.response.HttpResponseGone` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseGone")
            or
            // Handle `django.http.HttpResponseGone` alias
            result = http().getMember("HttpResponseGone")
          }

          /** Gets a reference to the `django.http.response.HttpResponseGone` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseGone`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseGone::instance()` to get references to instances of `django.http.response.HttpResponseGone`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseGone`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseGone`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseGone`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseServerError` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseServerError.
         */
        module HttpResponseServerError {
          /** Gets a reference to the `django.http.response.HttpResponseServerError` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseServerError")
            or
            // Handle `django.http.HttpResponseServerError` alias
            result = http().getMember("HttpResponseServerError")
          }

          /** Gets a reference to the `django.http.response.HttpResponseServerError` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponseServerError`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseServerError::instance()` to get references to instances of `django.http.response.HttpResponseServerError`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseServerError`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseServerError`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseServerError`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.JsonResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#jsonresponse-objects.
         */
        module JsonResponse {
          /** Gets a reference to the `django.http.response.JsonResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("JsonResponse")
            or
            // Handle `django.http.JsonResponse` alias
            result = http().getMember("JsonResponse")
          }

          /** Gets a reference to the `django.http.response.JsonResponse` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.JsonResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `JsonResponse::instance()` to get references to instances of `django.http.response.JsonResponse`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.JsonResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("data")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "application/json" }
          }

          /** Gets a reference to an instance of `django.http.response.JsonResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.JsonResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        // ---------------------------------------------------------------------------
        // HttpResponse-like classes
        // ---------------------------------------------------------------------------
        /**
         * Provides models for the `django.http.response.StreamingHttpResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#streaminghttpresponse-objects.
         */
        module StreamingHttpResponse {
          /** Gets a reference to the `django.http.response.StreamingHttpResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("StreamingHttpResponse")
            or
            // Handle `django.http.StreamingHttpResponse` alias
            result = http().getMember("StreamingHttpResponse")
          }

          /** Gets a reference to the `django.http.response.StreamingHttpResponse` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.StreamingHttpResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `StreamingHttpResponse::instance()` to get references to instances of `django.http.response.StreamingHttpResponse`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.StreamingHttpResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("streaming_content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.StreamingHttpResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.StreamingHttpResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.FileResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#fileresponse-objects.
         */
        module FileResponse {
          /** Gets a reference to the `django.http.response.FileResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("FileResponse")
            or
            // Handle `django.http.FileResponse` alias
            result = http().getMember("FileResponse")
          }

          /** Gets a reference to the `django.http.response.FileResponse` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.FileResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `FileResponse::instance()` to get references to instances of `django.http.response.FileResponse`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.FileResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("streaming_content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() {
              // see https://github.com/django/django/blob/ebb08d19424c314c75908bc6048ff57c2f872269/django/http/response.py#L471-L479
              result = "application/octet-stream"
            }
          }

          /** Gets a reference to an instance of `django.http.response.FileResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.FileResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /** Gets a reference to the `django.http.response.HttpResponse.write` function. */
        private DataFlow::TypeTrackingNode write(
          django::http::response::HttpResponse::InstanceSource instance, DataFlow::TypeTracker t
        ) {
          t.startInAttr("write") and
          instance = django::http::response::HttpResponse::instance() and
          result = instance
          or
          exists(DataFlow::TypeTracker t2 | result = write(instance, t2).track(t2, t))
        }

        /** Gets a reference to the `django.http.response.HttpResponse.write` function. */
        DataFlow::Node write(django::http::response::HttpResponse::InstanceSource instance) {
          write(instance, DataFlow::TypeTracker::end()).flowsTo(result)
        }

        /**
         * A call to the `django.http.response.HttpResponse.write` function.
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponse.write
         */
        class HttpResponseWriteCall extends HTTP::Server::HttpResponse::Range, DataFlow::CallCfgNode {
          django::http::response::HttpResponse::InstanceSource instance;

          HttpResponseWriteCall() { this.getFunction() = write(instance) }

          override DataFlow::Node getBody() {
            result in [this.getArg(0), this.getArgByName("content")]
          }

          override DataFlow::Node getMimetypeOrContentTypeArg() {
            result = instance.getMimetypeOrContentTypeArg()
          }

          override string getMimetypeDefault() { result = instance.getMimetypeDefault() }
        }

        /**
         * A call to `set_cookie` on a HTTP Response.
         */
        class DjangoResponseSetCookieCall extends HTTP::Server::CookieWrite::Range,
          DataFlow::MethodCallNode {
          DjangoResponseSetCookieCall() {
            this.calls(django::http::response::HttpResponse::instance(), "set_cookie")
          }

          override DataFlow::Node getHeaderArg() { none() }

          override DataFlow::Node getNameArg() {
            result in [this.getArg(0), this.getArgByName("key")]
          }

          override DataFlow::Node getValueArg() {
            result in [this.getArg(1), this.getArgByName("value")]
          }
        }

        /**
         * A call to `delete_cookie` on a HTTP Response.
         */
        class DjangoResponseDeleteCookieCall extends HTTP::Server::CookieWrite::Range,
          DataFlow::MethodCallNode {
          DjangoResponseDeleteCookieCall() {
            this.calls(django::http::response::HttpResponse::instance(), "delete_cookie")
          }

          override DataFlow::Node getHeaderArg() { none() }

          override DataFlow::Node getNameArg() {
            result in [this.getArg(0), this.getArgByName("key")]
          }

          override DataFlow::Node getValueArg() { none() }
        }

        /**
         * A dict-like write to an item of the `cookies` attribute on a HTTP response, such as
         * `response.cookies[name] = value`.
         */
        class DjangoResponseCookieSubscriptWrite extends HTTP::Server::CookieWrite::Range {
          DataFlow::Node index;
          DataFlow::Node value;

          DjangoResponseCookieSubscriptWrite() {
            exists(SubscriptNode subscript, DataFlow::AttrRead cookieLookup |
              // To give `this` a value, we need to choose between either LHS or RHS,
              // and just go with the LHS
              this.asCfgNode() = subscript
            |
              cookieLookup.getAttributeName() = "cookies" and
              cookieLookup.getObject() = django::http::response::HttpResponse::instance() and
              exists(DataFlow::Node subscriptObj |
                subscriptObj.asCfgNode() = subscript.getObject()
              |
                cookieLookup.flowsTo(subscriptObj)
              ) and
              value.asCfgNode() = subscript.(DefinitionNode).getValue() and
              index.asCfgNode() = subscript.getIndex()
            )
          }

          override DataFlow::Node getHeaderArg() { none() }

          override DataFlow::Node getNameArg() { result = index }

          override DataFlow::Node getValueArg() { result = value }
        }
      }
    }

    // -------------------------------------------------------------------------
    // django.shortcuts
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.shortcuts` module. */
    API::Node shortcuts() { result = django().getMember("shortcuts") }

    /** Provides models for the `django.shortcuts` module */
    module shortcuts {
      /**
       * Gets a reference to the `django.shortcuts.redirect` function
       *
       * See https://docs.djangoproject.com/en/3.1/topics/http/shortcuts/#redirect
       */
      API::Node redirect() { result = shortcuts().getMember("redirect") }
    }
  }

  // ---------------------------------------------------------------------------
  // Form and form field modeling
  // ---------------------------------------------------------------------------
  /**
   * A class that is a subclass of the `django.forms.Form` class,
   * thereby handling user input.
   */
  class DjangoFormClass extends Class, SelfRefMixin {
    DjangoFormClass() { this.getABase() = Django::Forms::Form::subclassRef().getAUse().asExpr() }
  }

  /**
   * A source of cleaned_data (either the return value from `super().clean()`, or a reference to `self.cleaned_data`)
   *
   * See https://docs.djangoproject.com/en/3.1/ref/forms/validation/#form-and-field-validation
   */
  private class DjangoFormCleanedData extends RemoteFlowSource::Range, DataFlow::Node {
    DjangoFormCleanedData() {
      exists(DjangoFormClass cls, Function meth |
        cls.getAMethod() = meth and
        (
          this = API::builtin("super").getReturn().getMember("clean").getACall() and
          this.getScope() = meth
          or
          this.(DataFlow::AttrRead).getAttributeName() = "cleaned_data" and
          this.(DataFlow::AttrRead).getObject() = cls.getASelfRef()
        )
      )
    }

    override string getSourceType() {
      result = "django.forms.Field subclass, value parameter in method"
    }
  }

  /**
   * A class that is a subclass of the `django.forms.Field` class,
   * thereby handling user input.
   */
  class DjangoFormFieldClass extends Class {
    DjangoFormFieldClass() {
      this.getABase() = Django::Forms::Field::subclassRef().getAUse().asExpr()
    }
  }

  /**
   * A parameter in a method on a `DjangoFormFieldClass` that receives the user-supplied value for this field.
   *
   * See https://docs.djangoproject.com/en/3.1/ref/forms/validation/#form-and-field-validation
   */
  private class DjangoFormFieldValueParam extends RemoteFlowSource::Range, DataFlow::ParameterNode {
    DjangoFormFieldValueParam() {
      exists(DjangoFormFieldClass cls, Function meth |
        cls.getAMethod() = meth and
        meth.getName() in ["to_python", "validate", "run_validators", "clean"] and
        this.getParameter() = meth.getArg(1)
      )
    }

    override string getSourceType() {
      result = "django.forms.Field subclass, value parameter in method"
    }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
  /**
   * In order to recognize a class as being a django view class, based on the `as_view`
   * call, we need to be able to track such calls on _any_ class. This is provided by
   * the member predicates of this QL class.
   *
   * As such, a Python class being part of `DjangoViewClassHelper` doesn't signify that
   * we model it as a django view class.
   */
  class DjangoViewClassHelper extends Class {
    /** Gets a reference to this class. */
    private DataFlow::TypeTrackingNode getARef(DataFlow::TypeTracker t) {
      t.start() and
      result.asExpr().(ClassExpr) = this.getParent()
      or
      exists(DataFlow::TypeTracker t2 | result = this.getARef(t2).track(t2, t))
    }

    /** Gets a reference to this class. */
    DataFlow::Node getARef() { this.getARef(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** Gets a reference to the `as_view` classmethod of this class. */
    private DataFlow::TypeTrackingNode asViewRef(DataFlow::TypeTracker t) {
      t.startInAttr("as_view") and
      result = this.getARef()
      or
      exists(DataFlow::TypeTracker t2 | result = this.asViewRef(t2).track(t2, t))
    }

    /** Gets a reference to the `as_view` classmethod of this class. */
    DataFlow::Node asViewRef() { this.asViewRef(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** Gets a reference to the result of calling the `as_view` classmethod of this class. */
    private DataFlow::TypeTrackingNode asViewResult(DataFlow::TypeTracker t) {
      t.start() and
      result.asCfgNode().(CallNode).getFunction() = this.asViewRef().asCfgNode()
      or
      exists(DataFlow::TypeTracker t2 | result = this.asViewResult(t2).track(t2, t))
    }

    /** Gets a reference to the result of calling the `as_view` classmethod of this class. */
    DataFlow::Node asViewResult() {
      this.asViewResult(DataFlow::TypeTracker::end()).flowsTo(result)
    }
  }

  /** A class that we consider a django View class. */
  abstract class DjangoViewClass extends DjangoViewClassHelper, SelfRefMixin {
    /** Gets a function that could handle incoming requests, if any. */
    Function getARequestHandler() {
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      (
        result.getName() = HTTP::httpVerbLower()
        or
        result.getName() = "get_redirect_url"
      )
    }
  }

  /**
   * A class that is used in a route-setup, with `<class>.as_view()`, therefore being
   * considered a django View class.
   */
  class DjangoViewClassFromRouteSetup extends DjangoViewClass {
    DjangoViewClassFromRouteSetup() {
      exists(DjangoRouteSetup setup | setup.getViewArg() = this.asViewResult())
    }
  }

  /**
   * A class that has a super-type which is a django View class, therefore also
   * becoming a django View class.
   */
  class DjangoViewClassFromSuperClass extends DjangoViewClass {
    DjangoViewClassFromSuperClass() {
      this.getABase() = Django::Views::View::subclassRef().getAUse().asExpr()
    }
  }

  /**
   * A function that is a django route handler, meaning it handles incoming requests
   * with the django framework.
   *
   * Most functions take a django HttpRequest as a parameter (but not all).
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `DjangoRouteHandler::Range` instead.
   */
  class DjangoRouteHandler extends Function instanceof DjangoRouteHandler::Range {
    /**
     * Gets the index of the parameter where the first routed parameter can be passed --
     * that is, the one just after any possible `self` or HttpRequest parameters.
     */
    int getFirstPossibleRoutedParamIndex() { result = 1 + this.getRequestParamIndex() }

    /** Gets the index of the request parameter. */
    int getRequestParamIndex() {
      not this.isMethod() and
      result = 0
      or
      this.isMethod() and
      result = 1
    }

    /** Gets the request parameter. */
    Parameter getRequestParam() { result = this.getArg(this.getRequestParamIndex()) }
  }

  /** Provides a class for modeling new django route handlers. */
  module DjangoRouteHandler {
    /**
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `DjangoRouteHandler` instead.
     */
    abstract class Range extends Function { }

    /** Route handlers from normal usage of django. */
    private class StandardDjangoRouteHandlers extends Range {
      StandardDjangoRouteHandlers() {
        exists(DjangoRouteSetup route | route.getViewArg() = poorMansFunctionTracker(this))
        or
        any(DjangoViewClass vc).getARequestHandler() = this
      }
    }
  }

  /**
   * A method named `get_redirect_url` on a django view class.
   *
   * See https://docs.djangoproject.com/en/3.1/ref/class-based-views/base/#django.views.generic.base.RedirectView.get_redirect_url
   *
   * Note: this function only does something on a subclass of `RedirectView`, but since
   * classes can be considered django view classes without us knowing their super-classes,
   * we need to consider _any_ django view class. I don't expect any problems to come from this.
   */
  private class GetRedirectUrlFunction extends DjangoRouteHandler {
    GetRedirectUrlFunction() {
      this.getName() = "get_redirect_url" and
      any(DjangoViewClass vc).getARequestHandler() = this
    }

    override int getFirstPossibleRoutedParamIndex() { result = 1 }

    override int getRequestParamIndex() { none() }
  }

  /** A data-flow node that sets up a route on a server, using the django framework. */
  abstract class DjangoRouteSetup extends HTTP::Server::RouteSetup::Range, DataFlow::CfgNode {
    /** Gets the data-flow node that is used as the argument for the view handler. */
    abstract DataFlow::Node getViewArg();

    final override DjangoRouteHandler getARequestHandler() {
      poorMansFunctionTracker(result) = this.getViewArg()
      or
      exists(DjangoViewClass vc |
        this.getViewArg() = vc.asViewResult() and
        result = vc.getARequestHandler()
      )
    }

    override string getFramework() { result = "Django" }
  }

  /** A request handler defined in a django view class, that has no known route. */
  private class DjangoViewClassHandlerWithoutKnownRoute extends HTTP::Server::RequestHandler::Range,
    DjangoRouteHandler {
    DjangoViewClassHandlerWithoutKnownRoute() {
      exists(DjangoViewClass vc | vc.getARequestHandler() = this) and
      not exists(DjangoRouteSetup setup | setup.getARequestHandler() = this)
    }

    override Parameter getARoutedParameter() {
      // Since we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      result in [this.getArg(_), this.getArgByName(_)] and
      not result = any(int i | i < this.getFirstPossibleRoutedParamIndex() | this.getArg(i))
    }

    override string getFramework() { result = "Django" }
  }

  /**
   * Gets the regex that is used by django to find routed parameters when using `django.urls.path`.
   *
   * Taken from https://github.com/django/django/blob/7d1bf29977bb368d7c28e7c6eb146db3b3009ae7/django/urls/resolvers.py#L199
   */
  private string pathRoutedParameterRegex() {
    result = "<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>"
  }

  /**
   * A call to `django.urls.path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
   */
  private class DjangoUrlsPathCall extends DjangoRouteSetup, DataFlow::CallCfgNode {
    DjangoUrlsPathCall() { this = django::urls::path().getACall() }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("route")]
    }

    override DataFlow::Node getViewArg() { result in [this.getArg(1), this.getArgByName("view")] }

    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(DjangoRouteHandler routeHandler | routeHandler = this.getARequestHandler() |
        not exists(this.getUrlPattern()) and
        result in [routeHandler.getArg(_), routeHandler.getArgByName(_)] and
        not result =
          any(int i | i < routeHandler.getFirstPossibleRoutedParamIndex() | routeHandler.getArg(i))
      )
      or
      exists(string name |
        result = this.getARequestHandler().getArgByName(name) and
        exists(string match |
          match = this.getUrlPattern().regexpFind(pathRoutedParameterRegex(), _, _) and
          name = match.regexpCapture(pathRoutedParameterRegex(), 2)
        )
      )
    }
  }

  /** A Django route setup that uses a Regex to specify route (and routed parameters). */
  abstract private class DjangoRegexRouteSetup extends DjangoRouteSetup {
    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(DjangoRouteHandler routeHandler | routeHandler = this.getARequestHandler() |
        not exists(this.getUrlPattern()) and
        result in [routeHandler.getArg(_), routeHandler.getArgByName(_)] and
        not result =
          any(int i | i < routeHandler.getFirstPossibleRoutedParamIndex() | routeHandler.getArg(i))
      )
      or
      exists(DjangoRouteHandler routeHandler, DjangoRouteRegex regex |
        routeHandler = this.getARequestHandler() and
        regex.getRouteSetup() = this
      |
        // either using named capture groups (passed as keyword arguments) or using
        // unnamed capture groups (passed as positional arguments)
        not exists(regex.getGroupName(_, _)) and
        // first group will have group number 1
        result =
          routeHandler
              .getArg(routeHandler.getFirstPossibleRoutedParamIndex() - 1 +
                  regex.getGroupNumber(_, _))
        or
        result = routeHandler.getArgByName(regex.getGroupName(_, _))
      )
    }
  }

  /**
   * A regex that is used to set up a route.
   *
   * Needs this subclass to be considered a RegexString.
   */
  private class DjangoRouteRegex extends RegexString {
    DjangoRegexRouteSetup rePathCall;

    DjangoRouteRegex() {
      this instanceof StrConst and
      rePathCall.getUrlPatternArg().getALocalSource() = DataFlow::exprNode(this)
    }

    DjangoRegexRouteSetup getRouteSetup() { result = rePathCall }
  }

  /**
   * A call to `django.urls.re_path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
   */
  private class DjangoUrlsRePathCall extends DjangoRegexRouteSetup, DataFlow::CallCfgNode {
    DjangoUrlsRePathCall() {
      this = django::urls::re_path().getACall() and
      // `django.conf.urls.url` (which we support directly with
      // `DjangoConfUrlsUrlCall`), is implemented in Django 2+ as backward compatibility
      // using `django.urls.re_path`. See
      // https://github.com/django/django/blob/stable/3.2.x/django/conf/urls/__init__.py#L22
      // Since we're still installing dependencies and analyzing their source code,
      // without explicitly filtering out this call, we would be double-counting such
      // route-setups :( One practical negative side effect of double-counting it, is
      // that since we can't figure out the URL in the library code calling `django.urls.re_path`
      // (because we only consider local flow), we will for all those cases mark ANY parameter
      // as being a routed-parameter, which can lead to FPs.
      not exists(Module mod |
        mod.getName() = "django.conf.urls.__init__" and
        node.getEnclosingModule() = mod
      )
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("route")]
    }

    override DataFlow::Node getViewArg() { result in [this.getArg(1), this.getArgByName("view")] }
  }

  /**
   * A call to `django.conf.urls.url`.
   *
   * See https://docs.djangoproject.com/en/1.11/ref/urls/#django.conf.urls.url
   */
  private class DjangoConfUrlsUrlCall extends DjangoRegexRouteSetup, DataFlow::CallCfgNode {
    DjangoConfUrlsUrlCall() { this = django::conf::conf_urls::url().getACall() }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("regex")]
    }

    override DataFlow::Node getViewArg() { result in [this.getArg(1), this.getArgByName("view")] }
  }

  // ---------------------------------------------------------------------------
  // HttpRequest taint modeling
  // ---------------------------------------------------------------------------
  /** A parameter that will receive the django `HttpRequest` instance when a request handler is invoked. */
  private class DjangoRequestHandlerRequestParam extends django::http::request::HttpRequest::InstanceSource,
    RemoteFlowSource::Range, DataFlow::ParameterNode {
    DjangoRequestHandlerRequestParam() {
      this.getParameter() = any(DjangoRouteSetup setup).getARequestHandler().getRequestParam()
      or
      this.getParameter() = any(DjangoViewClassHandlerWithoutKnownRoute setup).getRequestParam()
    }

    override string getSourceType() { result = "django.http.request.HttpRequest" }
  }

  /**
   * A read of the `request` attribute on a reference to an instance of a View class,
   * which is the request being processed currently.
   *
   * See https://docs.djangoproject.com/en/3.1/topics/class-based-views/generic-display/#dynamic-filtering
   */
  private class DjangoViewClassRequestAttributeRead extends django::http::request::HttpRequest::InstanceSource,
    RemoteFlowSource::Range, DataFlow::Node {
    DjangoViewClassRequestAttributeRead() {
      exists(DataFlow::AttrRead read | this = read |
        read.getObject() = any(DjangoViewClass vc).getASelfRef() and
        read.getAttributeName() = "request"
      )
    }

    override string getSourceType() {
      result = "django HttpRequest from self.request in View class"
    }
  }

  /**
   * A read of the `args` or `kwargs` attribute on a reference to an instance of a View class,
   * which contains the routed parameters captured from the URL route.
   *
   * See https://docs.djangoproject.com/en/3.1/topics/class-based-views/generic-display/#dynamic-filtering
   */
  private class DjangoViewClassRoutedParamsAttributeRead extends RemoteFlowSource::Range,
    DataFlow::Node {
    DjangoViewClassRoutedParamsAttributeRead() {
      exists(DataFlow::AttrRead read | this = read |
        read.getObject() = any(DjangoViewClass vc).getASelfRef() and
        read.getAttributeName() in ["args", "kwargs"]
      )
    }

    override string getSourceType() {
      result = "django routed param from self.args/kwargs in View class"
    }
  }

  // ---------------------------------------------------------------------------
  // django.shortcuts.redirect
  // ---------------------------------------------------------------------------
  /**
   * A call to `django.shortcuts.redirect`.
   *
   * Note: This works differently depending on what argument is used.
   * _One_ option is to redirect to a full URL.
   *
   * See https://docs.djangoproject.com/en/3.1/topics/http/shortcuts/#redirect
   */
  private class DjangoShortcutsRedirectCall extends HTTP::Server::HttpRedirectResponse::Range,
    DataFlow::CallCfgNode {
    DjangoShortcutsRedirectCall() { this = django::shortcuts::redirect().getACall() }

    /**
     * Gets the data-flow node that specifies the location of this HTTP redirect response.
     *
     * Note: For `django.shortcuts.redirect`, the result might not be a full URL
     * (as usually expected by this method), but could be a relative URL,
     * a string identifying a view, or a Django model.
     */
    override DataFlow::Node getRedirectLocation() {
      result in [this.getArg(0), this.getArgByName("to")]
    }

    override DataFlow::Node getBody() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { none() }
  }

  // ---------------------------------------------------------------------------
  // RedirectView handling
  // ---------------------------------------------------------------------------
  /**
   * A return from a method named `get_redirect_url` on a django view class.
   *
   * Note that in reality, this only does something on a subclass of `RedirectView` --
   * but until API graphs makes this easy to model, I took a shortcut in modeling
   * preciseness.
   *
   * See https://docs.djangoproject.com/en/3.1/ref/class-based-views/base/#redirectview
   */
  private class DjangoRedirectViewGetRedirectUrlReturn extends HTTP::Server::HttpRedirectResponse::Range,
    DataFlow::CfgNode {
    DjangoRedirectViewGetRedirectUrlReturn() {
      node = any(GetRedirectUrlFunction f).getAReturnValueFlowNode()
    }

    override DataFlow::Node getRedirectLocation() { result = this }

    override DataFlow::Node getBody() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { none() }
  }
}
