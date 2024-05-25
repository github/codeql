/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import semmle.python.frameworks.Django
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources

private module ExperimentalPrivateDjango {
  private module DjangoMod {
    API::Node http() { result = API::moduleImport("django").getMember("http") }

    module DjangoHttp {
      API::Node response() { result = http().getMember("response") }

      API::Node request() { result = http().getMember("request") }

      module Request {
        module HttpRequest {
          class DjangoGetParameter extends DataFlow::Node, RemoteFlowSource::Range {
            DjangoGetParameter() { this = request().getMember("GET").getMember("get").getACall() }

            override string getSourceType() { result = "django.http.request.GET.get" }
          }
        }
      }

      module Response {
        module HttpResponse {
          API::Node baseClassRef() {
            result = response().getMember("HttpResponse")
            or
            // Handle `django.http.HttpResponse` alias
            result = http().getMember("HttpResponse")
          }

          /** Gets a reference to the `django.http.response.HttpResponse` class. */
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
          abstract class InstanceSource extends Http::Server::HttpResponse::Range, DataFlow::Node {
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

          /** Gets a reference to a header instance. */
          API::Node headerInstance() {
            result = baseClassRef().getReturn().getASubscript()
            or
            result = baseClassRef().getReturn().getAMember()
          }

          /**
           * Gets a call to `set_cookie()`.
           *
           * Given the following example:
           *
           * ```py
           * def django_response(request):
           *    resp = django.http.HttpResponse()
           *    resp.set_cookie("name", "value", secure=True, httponly=True, samesite='Lax')
           *    return resp
           * ```
           *
           * * `this` would be `resp.set_cookie("name", "value", secure=False, httponly=False, samesite='None')`.
           * * `getName()`'s result would be `"name"`.
           * * `getValue()`'s result would be `"value"`.
           * * `isSecure()` predicate would succeed.
           * * `isHttpOnly()` predicate would succeed.
           * * `isSameSite()` predicate would succeed.
           */
          class DjangoResponseSetCookieCall extends DataFlow::MethodCallNode, Cookie::Range {
            DjangoResponseSetCookieCall() {
              this.calls(PrivateDjango::DjangoImpl::DjangoHttp::Response::HttpResponse::instance(),
                "set_cookie")
            }

            override DataFlow::Node getNameArg() {
              result in [this.getArg(0), this.getArgByName("key")]
            }

            override DataFlow::Node getValueArg() {
              result in [this.getArg(1), this.getArgByName("value")]
            }

            override predicate isSecure() {
              DataFlow::exprNode(any(True t))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("secure"))
            }

            override predicate isHttpOnly() {
              DataFlow::exprNode(any(True t))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("httponly"))
            }

            override predicate isSameSite() {
              exists(StringLiteral str |
                str.getText() in ["Strict", "Lax"] and
                DataFlow::exprNode(str)
                    .(DataFlow::LocalSourceNode)
                    .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("samesite"))
              )
            }

            override DataFlow::Node getHeaderArg() { none() }
          }
        }
      }
    }

    module Email {
      /** https://docs.djangoproject.com/en/3.2/topics/email/ */
      private API::Node djangoMail() {
        result = API::moduleImport("django").getMember("core").getMember("mail")
      }

      /**
       * Gets a call to `django.core.mail.send_mail()`.
       *
       * Given the following example:
       *
       * ```py
       * send_mail("Subject", "plain-text body", "from@example.com", ["to@example.com"], html_message=django.http.request.GET.get("html"))
       * ```
       *
       * * `this` would be `send_mail("Subject", "plain-text body", "from@example.com", ["to@example.com"], html_message=django.http.request.GET.get("html"))`.
       * * `getPlainTextBody()`'s result would be `"plain-text body"`.
       * * `getHtmlBody()`'s result would be `django.http.request.GET.get("html")`.
       * * `getTo()`'s result would be `["to@example.com"]`.
       * * `getFrom()`'s result would be `"from@example.com"`.
       * * `getSubject()`'s result would be `"Subject"`.
       */
      private class DjangoSendMail extends DataFlow::CallCfgNode, EmailSender::Range {
        DjangoSendMail() { this = djangoMail().getMember("send_mail").getACall() }

        override DataFlow::Node getPlainTextBody() {
          result in [this.getArg(1), this.getArgByName("message")]
        }

        override DataFlow::Node getHtmlBody() {
          result in [this.getArg(8), this.getArgByName("html_message")]
        }

        override DataFlow::Node getTo() {
          result in [this.getArg(3), this.getArgByName("recipient_list")]
        }

        override DataFlow::Node getFrom() {
          result in [this.getArg(2), this.getArgByName("from_email")]
        }

        override DataFlow::Node getSubject() {
          result in [this.getArg(0), this.getArgByName("subject")]
        }
      }

      /**
       * Gets a call to `django.core.mail.mail_admins()` or `django.core.mail.mail_managers()`.
       *
       * Given the following example:
       *
       * ```py
       * mail_admins("Subject", "plain-text body", html_message=django.http.request.GET.get("html"))
       * ```
       *
       * * `this` would be `mail_admins("Subject", "plain-text body", html_message=django.http.request.GET.get("html"))`.
       * * `getPlainTextBody()`'s result would be `"plain-text body"`.
       * * `getHtmlBody()`'s result would be `django.http.request.GET.get("html")`.
       * * `getTo()`'s result would be `none`.
       * * `getFrom()`'s result would be `none`.
       * * `getSubject()`'s result would be `"Subject"`.
       */
      private class DjangoMailInternal extends DataFlow::CallCfgNode, EmailSender::Range {
        DjangoMailInternal() {
          this = djangoMail().getMember(["mail_admins", "mail_managers"]).getACall()
        }

        override DataFlow::Node getPlainTextBody() {
          result in [this.getArg(1), this.getArgByName("message")]
        }

        override DataFlow::Node getHtmlBody() {
          result in [this.getArg(4), this.getArgByName("html_message")]
        }

        override DataFlow::Node getTo() { none() }

        override DataFlow::Node getFrom() { none() }

        override DataFlow::Node getSubject() {
          result in [this.getArg(0), this.getArgByName("subject")]
        }
      }
    }
  }
}
