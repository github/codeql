/**
 * Provides classes for working with the [`Werkzeug`](https://pypi.org/project/Werkzeug/) package.
 *
 * See:
 * - repo: https://github.com/pallets/werkzeug
 * - website: https://palletsprojects.com/p/werkzeug/
 * - API docs: https://werkzeug.palletsprojects.com
 */

import python

import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.External

/**
 * Provides classes for working with the [`Werkzeug`](https://pypi.org/project/Werkzeug/) package.
 *
 * Specifically, we provide TaintKinds for many of the classes in `werkzeug.datastructures` that are
 * used in handling HTTP requests (these are used by `flask`).
 *
 * See:
 * - repo: https://github.com/pallets/werkzeug
 * - website: https://palletsprojects.com/p/werkzeug/
 * - API docs: https://werkzeug.palletsprojects.com
 */
module Werkzeug {

    /** TaintKind for instances of `werkzeug.datastructures.Accept`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Accept
    */
    class Accept extends ExternalStringSequenceKind {
        override TaintKind getTaintOfAttribute(string name) {
            result = super.getTaintOfAttribute(name)
            or
            name = "best" and result = this.getItem()
        }

        override TaintKind getTaintOfMethodResult(string name) {
            result = super.getTaintOfMethodResult(name)
            or
            name = "best_match" and result = this.getItem()
        }
    }

    /** TaintKind for instances of `werkzeug.datastructures.HeaderSet`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.HeaderSet
    */
    class HeaderSet extends ExternalStringSequenceKind {
    }

    /** TaintKind for instances of `werkzeug.datastructures.MultiDict`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict
    */
    class MultiDict extends DictKind {
        override TaintKind getTaintOfMethodResult(string name) {
            result = super.getTaintOfMethodResult(name)
            or
            name = "getlist" and result.(SequenceKind).getItem() = this.getValue()
        }
    }

    /** TaintKind for instances of `werkzeug.datastructures.RequestCacheControl`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.RequestCacheControl
    */
    class RequestCacheControl extends TaintKind {
        RequestCacheControl() { this = "Werkzeug::RequestCacheControl" }

        override TaintKind getTaintOfAttribute(string name) {
            result = super.getTaintOfAttribute(name)
            or
            name in ["max_age", "max_stale", "min_fresh"] and
            result instanceof ExternalStringKind
        }
    }

    /** TaintKind for instances of `werkzeug.datastructures.Headers`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers
    */
    class Headers extends ExternalStringDictKind {
        override TaintKind getTaintOfMethodResult(string name) {
            result = super.getTaintOfMethodResult(name)
            or
            name in ["getlist", "get_all"] and
            result.(SequenceKind).getItem() = this.getValue()
            or
            // (k, v) list
            name = "to_wsgi_list" and
            result.(SequenceKind).getItem().(SequenceKind).getItem() = this.getValue()
        }

        override TaintKind getTaintForIteration() {
            // (k, v) list
            result.(SequenceKind).getItem().(SequenceKind).getItem() = this.getValue()

        }
    }

    /** TaintKind for instances of `werkzeug.datastructures.Authorization`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Authorization
    */
    class Authorization extends ExternalStringDictKind {
        bindingset[name]
        override TaintKind getTaintOfAttribute(string name) {
            result = super.getTaintOfAttribute(name)
            or
            not exists(super.getTaintOfAttribute(name)) and
            result = this.getValue()
        }
    }

    /** TaintKind for instances of `werkzeug.datastructures.FileStorage`.
    * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage
    */
    class FileStorage extends TaintKind {
        FileStorage() {this = "Werkzeug::FileStorage"}

        override TaintKind getTaintOfAttribute(string name) {
            result = super.getTaintOfAttribute(name)
            or
            name in ["filename", "name", "content_type", "mimetype"] and
            result instanceof ExternalStringKind
            or
            name = "stream" and
            result instanceof ExternalFileObject
            or
            name = "headers" and
            result instanceof Werkzeug::Headers
            or
            name = "mimetype_params" and
            result instanceof ExternalStringDictKind
        }

        // TODO: the `save(dst)` method should be a taint-sink for path-injection
    }

}
