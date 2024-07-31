Go framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total)
   `Couchbase official client(gocb) <https://github.com/couchbase/gocb>`_,"``github.com/couchbase/gocb*``, ``gopkg.in/couchbase/gocb*``",,36,
   `Couchbase unofficial client <http://www.github.com/couchbase/go-couchbase>`_,``github.com/couchbaselabs/gocb*``,,18,
   `Echo <https://echo.labstack.com/>`_,``github.com/labstack/echo*``,12,2,
   `Fosite <https://github.com/ory/fosite>`_,``github.com/ory/fosite*``,,,2
   `Gin <https://github.com/gin-gonic/gin>`_,``github.com/gin-gonic/gin*``,46,2,
   `Go JOSE <https://github.com/go-jose/go-jose>`_,"``github.com/go-jose/go-jose*``, ``github.com/square/go-jose*``, ``gopkg.in/square/go-jose*``",,12,9
   `Go kit <https://gokit.io/>`_,``github.com/go-kit/kit*``,,,1
   `Iris <https://www.iris-go.com/>`_,``github.com/kataras/iris*``,,,2
   `Kubernetes <https://kubernetes.io/>`_,"``k8s.io/api*``, ``k8s.io/apimachinery*``",,57,
   `Macaron <https://gopkg.in/macaron.v1>`_,``gopkg.in/macaron*``,12,1,
   `Revel <http://revel.github.io/>`_,"``github.com/revel/revel*``, ``github.com/robfig/revel*``",46,20,
   `SendGrid <https://github.com/sendgrid/sendgrid-go>`_,``github.com/sendgrid/sendgrid-go*``,,1,
   `Standard library <https://pkg.go.dev/std>`_,"````, ``archive/*``, ``bufio``, ``bytes``, ``cmp``, ``compress/*``, ``container/*``, ``context``, ``crypto``, ``crypto/*``, ``database/*``, ``debug/*``, ``embed``, ``encoding``, ``encoding/*``, ``errors``, ``expvar``, ``flag``, ``fmt``, ``go/*``, ``hash``, ``hash/*``, ``html``, ``html/*``, ``image``, ``image/*``, ``index/*``, ``io``, ``io/*``, ``log``, ``log/*``, ``maps``, ``math``, ``math/*``, ``mime``, ``mime/*``, ``net``, ``net/*``, ``os``, ``os/*``, ``path``, ``path/*``, ``plugin``, ``reflect``, ``reflect/*``, ``regexp``, ``regexp/*``, ``slices``, ``sort``, ``strconv``, ``strings``, ``sync``, ``sync/*``, ``syscall``, ``syscall/*``, ``testing``, ``testing/*``, ``text/*``, ``time``, ``time/*``, ``unicode``, ``unicode/*``, ``unsafe``",16,584,
   `beego <https://beego.me/>`_,"``github.com/astaxie/beego*``, ``github.com/beego/beego*``",63,63,
   `chi <https://go-chi.io/>`_,``github.com/go-chi/chi*``,3,,
   `cristalhq/jwt <https://github.com/cristalhq/jwt>`_,``github.com/cristalhq/jwt*``,,,1
   `fasthttp <https://github.com/valyala/fasthttp>`_,``github.com/valyala/fasthttp*``,50,5,25
   `go-pg <https://pg.uptrace.dev/>`_,``github.com/go-pg/pg*``,,6,
   `go-restful <https://github.com/emicklei/go-restful>`_,``github.com/emicklei/go-restful*``,7,,
   `golang.org/x/net <https://pkg.go.dev/golang.org/x/net>`_,``golang.org/x/net*``,2,21,
   `goproxy <https://github.com/elazarl/goproxy>`_,``github.com/elazarl/goproxy*``,2,2,
   `gorilla/mux <https://github.com/gorilla/mux>`_,``github.com/gorilla/mux*``,1,,
   `json-iterator <https://github.com/json-iterator/go>`_,``github.com/json-iterator/go*``,,4,
   `jsonpatch <https://github.com/evanphx/json-patch>`_,``github.com/evanphx/json-patch*``,,12,
   `jwt-go <https://golang-jwt.github.io/jwt/>`_,"``github.com/golang-jwt/jwt*``, ``github.com/form3tech-oss/jwt-go*``, ``github.com/dgrijalva/jwt-go*``",,20,8
   `jwtauth <https://github.com/go-chi/jwtauth>`_,``github.com/go-chi/jwtauth*``,,,1
   `kataras/jwt <https://github.com/kataras/jwt>`_,``github.com/kataras/jwt*``,,,5
   `lestrrat-go/jwx <https://github.com/lestrrat-go/jwx>`_,"``github.com/lestrrat-go/jwx*``, ``github.com/lestrrat/go-jwx*``",,,3
   `protobuf <https://pkg.go.dev/google.golang.org/protobuf>`_,"``github.com/golang/protobuf*``, ``google.golang.org/protobuf*``",,16,
   `yaml <https://gopkg.in/yaml.v3>`_,``gopkg.in/yaml*``,,9,
   `zap <https://go.uber.org/zap>`_,``go.uber.org/zap*``,,11,
   Others,"``github.com/ChrisTrenkamp/goxpath``, ``github.com/antchfx/htmlquery``, ``github.com/antchfx/jsonquery``, ``github.com/antchfx/xmlquery``, ``github.com/antchfx/xpath``, ``github.com/appleboy/gin-jwt``, ``github.com/go-xmlpath/xmlpath``, ``github.com/gobwas/ws``, ``github.com/gogf/gf-jwt``, ``github.com/gorilla/websocket``, ``github.com/jbowtie/gokogiri/xml``, ``github.com/jbowtie/gokogiri/xpath``, ``github.com/lestrrat-go/libxml2/parser``, ``github.com/santhosh-tekuri/xpathparser``, ``nhooyr.io/websocket``",7,,37
   Totals,,267,902,94

