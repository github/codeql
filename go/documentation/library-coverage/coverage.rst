Go framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total)
   `Afero <https://github.com/spf13/afero>`_,``github.com/spf13/afero*``,,,34
   `CleverGo <https://github.com/clevergo/clevergo>`_,"``clevergo.tech/clevergo*``, ``github.com/clevergo/clevergo*``",,,2
   `Couchbase official client(gocb) <https://github.com/couchbase/gocb>`_,"``github.com/couchbase/gocb*``, ``gopkg.in/couchbase/gocb*``",,36,16
   `Couchbase unofficial client <http://www.github.com/couchbase/go-couchbase>`_,``github.com/couchbaselabs/gocb*``,,18,8
   `Echo <https://echo.labstack.com/>`_,``github.com/labstack/echo*``,12,2,3
   `Fiber <https://github.com/gofiber/fiber>`_,``github.com/gofiber/fiber*``,,,5
   `Fosite <https://github.com/ory/fosite>`_,``github.com/ory/fosite*``,,,2
   `Gin <https://github.com/gin-gonic/gin>`_,``github.com/gin-gonic/gin*``,46,2,3
   `Glog <https://github.com/golang/glog>`_,"``github.com/golang/glog*``, ``gopkg.in/glog*``, ``k8s.io/klog*``",,,270
   `Go JOSE <https://github.com/go-jose/go-jose>`_,"``github.com/go-jose/go-jose*``, ``github.com/square/go-jose*``, ``gopkg.in/square/go-jose*``, ``gopkg.in/go-jose/go-jose*``",,16,12
   `Go kit <https://gokit.io/>`_,``github.com/go-kit/kit*``,,,1
   `Go-spew <https://github.com/davecgh/go-spew>`_,``github.com/davecgh/go-spew/spew*``,,,9
   `Gokogiri <https://github.com/moovweb/gokogiri>`_,"``github.com/jbowtie/gokogiri*``, ``github.com/moovweb/gokogiri*``",,,10
   `Iris <https://www.iris-go.com/>`_,``github.com/kataras/iris*``,,,14
   `Kubernetes <https://kubernetes.io/>`_,"``k8s.io/api*``, ``k8s.io/apimachinery*``",,57,
   `Logrus <https://github.com/sirupsen/logrus>`_,"``github.com/Sirupsen/logrus*``, ``github.com/sirupsen/logrus*``",,,290
   `Macaron <https://gopkg.in/macaron.v1>`_,``gopkg.in/macaron*``,12,1,1
   `Revel <http://revel.github.io/>`_,"``github.com/revel/revel*``, ``github.com/robfig/revel*``",46,20,4
   `SendGrid <https://github.com/sendgrid/sendgrid-go>`_,``github.com/sendgrid/sendgrid-go*``,,1,
   `Standard library <https://pkg.go.dev/std>`_,"````, ``archive/*``, ``bufio``, ``bytes``, ``cmp``, ``compress/*``, ``container/*``, ``context``, ``crypto``, ``crypto/*``, ``database/*``, ``debug/*``, ``embed``, ``encoding``, ``encoding/*``, ``errors``, ``expvar``, ``flag``, ``fmt``, ``go/*``, ``hash``, ``hash/*``, ``html``, ``html/*``, ``image``, ``image/*``, ``index/*``, ``io``, ``io/*``, ``log``, ``log/*``, ``maps``, ``math``, ``math/*``, ``mime``, ``mime/*``, ``net``, ``net/*``, ``os``, ``os/*``, ``path``, ``path/*``, ``plugin``, ``reflect``, ``reflect/*``, ``regexp``, ``regexp/*``, ``slices``, ``sort``, ``strconv``, ``strings``, ``sync``, ``sync/*``, ``syscall``, ``syscall/*``, ``testing``, ``testing/*``, ``text/*``, ``time``, ``time/*``, ``unicode``, ``unicode/*``, ``unsafe``",52,603,104
   `XPath <https://github.com/antchfx/xpath>`_,``github.com/antchfx/xpath*``,,,4
   `appleboy/gin-jwt <https://github.com/appleboy/gin-jwt>`_,``github.com/appleboy/gin-jwt*``,,,1
   `beego <https://beego.me/>`_,"``github.com/astaxie/beego*``, ``github.com/beego/beego*``",102,63,213
   `chi <https://go-chi.io/>`_,``github.com/go-chi/chi*``,3,,
   `cristalhq/jwt <https://github.com/cristalhq/jwt>`_,``github.com/cristalhq/jwt*``,,,1
   `fasthttp <https://github.com/valyala/fasthttp>`_,``github.com/valyala/fasthttp*``,50,5,35
   `gf-jwt <https://github.com/gogf/gf-jwt>`_,``github.com/gogf/gf-jwt*``,,,1
   `go-pg <https://pg.uptrace.dev/>`_,``github.com/go-pg/pg*``,,6,
   `go-restful <https://github.com/emicklei/go-restful>`_,``github.com/emicklei/go-restful*``,7,,
   `go-sh <https://github.com/codeskyblue/go-sh>`_,``github.com/codeskyblue/go-sh*``,,,4
   `golang.org/x/crypto/ssh <https://pkg.go.dev/golang.org/x/crypto/ssh>`_,``golang.org/x/crypto/ssh*``,,,4
   `golang.org/x/net <https://pkg.go.dev/golang.org/x/net>`_,``golang.org/x/net*``,2,21,
   `goproxy <https://github.com/elazarl/goproxy>`_,``github.com/elazarl/goproxy*``,2,2,2
   `gorilla/mux <https://github.com/gorilla/mux>`_,``github.com/gorilla/mux*``,1,,
   `gorilla/websocket <https://github.com/gorilla/websocket>`_,``github.com/gorilla/websocket*``,3,,
   `goxpath <https://github.com/ChrisTrenkamp/goxpath/wiki>`_,``github.com/ChrisTrenkamp/goxpath*``,,,3
   `htmlquery <https://github.com/antchfx/htmlquery>`_,``github.com/antchfx/htmlquery*``,,,4
   `json-iterator <https://github.com/json-iterator/go>`_,``github.com/json-iterator/go*``,,4,
   `jsonpatch <https://github.com/evanphx/json-patch>`_,``github.com/evanphx/json-patch*``,,12,
   `jsonquery <https://github.com/antchfx/jsonquery>`_,``github.com/antchfx/jsonquery*``,,,4
   `jwt-go <https://golang-jwt.github.io/jwt/>`_,"``github.com/golang-jwt/jwt*``, ``github.com/form3tech-oss/jwt-go*``, ``github.com/dgrijalva/jwt-go*``",,20,8
   `jwtauth <https://github.com/go-chi/jwtauth>`_,``github.com/go-chi/jwtauth*``,,,1
   `kataras/jwt <https://github.com/kataras/jwt>`_,``github.com/kataras/jwt*``,,,5
   `lestrrat-go/jwx <https://github.com/lestrrat-go/jwx>`_,"``github.com/lestrrat-go/jwx*``, ``github.com/lestrrat/go-jwx*``",,,3
   `lestrrat-go/libxml2 <https://github.com/lestrrat-go/libxml2>`_,``github.com/lestrrat-go/libxml2*``,,,3
   `nhooyr.io/websocket <https://nhooyr.io/websocket>`_,``nhooyr.io/websocket*``,2,,
   `protobuf <https://pkg.go.dev/google.golang.org/protobuf>`_,"``github.com/golang/protobuf*``, ``google.golang.org/protobuf*``",,16,
   `ws <https://github.com/gobwas/ws>`_,``github.com/gobwas/ws*``,2,,
   `xmlpath <https://gopkg.in/xmlpath.v2>`_,"``gopkg.in/xmlpath*``, ``github.com/go-xmlpath/xmlpath*``, ``github.com/crankycoder/xmlpath*``, ``launchpad.net/xmlpath*``, ``github.com/masterzen/xmlpath*``, ``github.com/going/toolkit/xmlpath*``, ``gopkg.in/go-xmlpath/xmlpath*``",,,14
   `xmlquery <https://github.com/antchfx/xmlquery>`_,``github.com/antchfx/xmlquery*``,,,8
   `xpathparser <https://github.com/santhosh-tekuri/xpathparser>`_,``github.com/santhosh-tekuri/xpathparser*``,,,2
   `yaml <https://gopkg.in/yaml.v3>`_,``gopkg.in/yaml*``,,9,
   `zap <https://go.uber.org/zap>`_,``go.uber.org/zap*``,,11,33
   Others,"``github.com/Masterminds/squirrel``, ``github.com/caarlos0/env``, ``github.com/go-gorm/gorm``, ``github.com/go-xorm/xorm``, ``github.com/gobuffalo/envy``, ``github.com/gogf/gf/database/gdb``, ``github.com/hashicorp/go-envparse``, ``github.com/jinzhu/gorm``, ``github.com/jmoiron/sqlx``, ``github.com/joho/godotenv``, ``github.com/kelseyhightower/envconfig``, ``github.com/lann/squirrel``, ``github.com/raindog308/gorqlite``, ``github.com/rqlite/gorqlite``, ``github.com/uptrace/bun``, ``go.mongodb.org/mongo-driver/mongo``, ``gopkg.in/Masterminds/squirrel``, ``gorm.io/gorm``, ``xorm.io/xorm``",117,16,391
   Totals,,459,941,1532

