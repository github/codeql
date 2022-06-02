module github.com/securekey/fabric-snaps

require (
	github.com/DATA-DOG/godog v0.7.4
	github.com/cactus/go-statsd-client v3.1.1+incompatible // indirect
	github.com/cloudflare/cfssl v0.0.0-20180323000720-5d63dbd981b5 // indirect
	github.com/facebookgo/clock v0.0.0-20150410010913-600d898af40a // indirect
	github.com/fsouza/go-dockerclient v1.3.0
	github.com/go-kit/kit v0.7.0
	github.com/go-logfmt/logfmt v0.4.0 // indirect
	github.com/golang/protobuf v1.2.0
	github.com/google/certificate-transparency-go v0.0.0-20180219093839-391726f8973d // indirect
	github.com/hyperledger/fabric v1.4.0
	github.com/hyperledger/fabric-sdk-go v0.0.0-20190125204638-b490519efff9
	github.com/onsi/gomega v1.5.0 // indirect
	github.com/op/go-logging v0.0.0-20160315200505-970db520ece7
	github.com/pkg/errors v0.8.1
	github.com/rs/xid v0.0.0-20170604230408-02dd45c33376
	github.com/securekey/fabric-snaps/membershipsnap/pkg/membership v0.0.0
	github.com/securekey/fabric-snaps/util/rolesmgr v0.4.0
	github.com/securekey/fabric-snaps/util/statemgr v0.4.0
	github.com/spf13/cobra v0.0.3
	github.com/spf13/pflag v1.0.3
	github.com/spf13/viper v0.0.0-20171227194143-aafc9e6bc7b7
	github.com/stretchr/testify v1.3.0
	github.com/uber-go/tally v3.3.2+incompatible // indirect
	github.com/xeipuuv/gojsonpointer v0.0.0-20170225233418-6fe8760cad35 // indirect
	github.com/xeipuuv/gojsonreference v0.0.0-20150808065054-e02fc20de94c // indirect
	github.com/xeipuuv/gojsonschema v0.0.0-20170528113821-0c8571ac0ce1
	golang.org/x/crypto v0.0.0-20181001203147-e3636079e1a4
	golang.org/x/net v0.0.0-20181003013248-f5e5bdd77824
	golang.org/x/tools v0.0.0-20181026183834-f60e5f99f081
	google.golang.org/grpc v1.17.0

)

replace github.com/hyperledger/fabric => github.com/securekey/fabric-next v0.0.0-20190216163058-9e08161f2597

replace github.com/docker/libnetwork => github.com/docker/libnetwork v0.0.0-20180608203834-19279f049241

replace github.com/docker/docker => github.com/docker/docker v0.0.0-20180827131323-0c5f8d2b9b23

replace golang.org/x/crypto => golang.org/x/crypto v0.0.0-20180827131323-e3636079e1a4

replace github.com/spf13/afero => github.com/spf13/afero v1.2.1

replace github.com/hashicorp/hcl => github.com/hashicorp/hcl v1.0.0

replace github.com/go-logfmt/logfmt => github.com/go-logfmt/logfmt v0.3.0

replace github.com/stretchr/testify => github.com/stretchr/testify v1.2.2

replace github.com/onsi/gomega => github.com/onsi/gomega v1.4.2

replace github.com/securekey/fabric-snaps/util/rolesmgr => ./util/rolesmgr

replace github.com/securekey/fabric-snaps/util/statemgr => ./util/statemgr

replace github.com/securekey/fabric-snaps/membershipsnap/pkg/membership => ./membershipsnap/pkg/membership

replace google.golang.org/grpc => google.golang.org/grpc v1.15.0

replace github.com/pkg/errors => github.com/pkg/errors v0.8.0

replace github.com/spf13/oldviper => github.com/spf13/viper v0.0.0-20150908122457-1967d93db724
