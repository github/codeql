package main

//go:generate depstubber -vendor k8s.io/klog Verbose Info,Infof,Infoln,Error,Errorf,Errorln,Fatal,Fatalf,Fatalln,Exit,Exitf,Exitln,V
//go:generate depstubber -vendor github.com/astaxie/beego "" Alert,Critical,Debug,Emergency,Error,Info,Informational,Notice,Trace,Warn,Warning
//go:generate depstubber -vendor github.com/astaxie/beego/logs "" NewLogger,Alert,Critical,Debug,Emergency,Error,Info,Informational,Notice,Trace,Warn,Warning
//go:generate depstubber -vendor github.com/astaxie/beego/utils "" Display
//go:generate depstubber -vendor github.com/davecgh/go-spew/spew "" Dump,Errorf,Print,Printf,Println,Fdump,Fprint,Fprintf,Fprintln
//go:generate depstubber -vendor github.com/elazarl/goproxy ProxyCtx ""
//go:generate depstubber -vendor github.com/golang/glog Level,Verbose Info,InfoDepth,Infof,Infoln,Error,ErrorDepth,Errorf,Errorln,Fatal,FatalDepth,Fatalf,Fatalln,Exit,ExitDepth,Exitf,Exitln,V
//go:generate depstubber -vendor github.com/sirupsen/logrus FieldLogger,Fields,Entry,Logger,Level Debug,Debugf,Debugln,Error,Errorf,Errorln,Fatal,Fatalf,Fatalln,Info,Infof,Infoln,New,NewEntry,Panic,Panicf,Panicln,Print,Printf,Println,Trace,Tracef,Traceln,Warn,Warnf,Warnln,Warning,Warningf,Warningln,WithError,WithFields,WithField
//go:generate depstubber -vendor go.uber.org/zap Logger,SugaredLogger NewProduction

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/utils"
	"github.com/davecgh/go-spew/spew"
	"github.com/elazarl/goproxy"
	"github.com/golang/glog"
	"github.com/sirupsen/logrus"
	"go.uber.org/zap"
	"k8s.io/klog"
)

func handler(req *http.Request, ctx *goproxy.ProxyCtx) {
	username := req.URL.Query()["username"][0]
	slice := []any{"username", username}
	testFlag := req.URL.Query()["testFlag"][0]

	{
		fmt.Print(username)       // $ hasTaintFlow="username"
		fmt.Printf(username)      // $ hasTaintFlow="username"
		fmt.Println(username)     // $ hasTaintFlow="username"
		fmt.Fprint(nil, username) // Fprint functions are only loggers if they target stdout/stderr
		fmt.Fprintf(nil, username)
		fmt.Fprintln(nil, username)
	}
	// log
	{
		log.Print("user %s logged in.\n", username)   // $ hasTaintFlow="username"
		log.Printf("user %s logged in.\n", username)  // $ hasTaintFlow="username"
		log.Println("user %s logged in.\n", username) // $ hasTaintFlow="username"

		if testFlag == "true" {
			log.Fatal("user %s logged in.\n", username) // $ hasTaintFlow="username"
		}
		if testFlag == "true" {
			log.Fatalf("user %s logged in.\n", username) // $ hasTaintFlow="username"
		}
		if testFlag == "true" {
			log.Fatalln("user %s logged in.\n", username) // $ hasTaintFlow="username"
		}
		if testFlag == "true" {
			log.Panic("user %s logged in.\n", username) // $ hasTaintFlow="username"
		}
		if testFlag == "true" {
			log.Panicf("user %s logged in.\n", username) // $ hasTaintFlow="username"
		}
		if testFlag == "true" {
			log.Panicln("user %s logged in.\n", username) // $ hasTaintFlow="username"
		}

		logger := log.Default()
		logger.Print("user %s logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Printf("user %s logged in.\n", username)  // $ hasTaintFlow="username"
		logger.Println("user %s logged in.\n", username) // $ hasTaintFlow="username"
		logger.Fatal("user %s logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Fatalf("user %s logged in.\n", username)  // $ hasTaintFlow="username"
		logger.Fatalln("user %s logged in.\n", username) // $ hasTaintFlow="username"
		logger.Panic("user %s logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Panicf("user %s logged in.\n", username)  // $ hasTaintFlow="username"
		logger.Panicln("user %s logged in.\n", username) // $ hasTaintFlow="username"
	}
	// k8s.io/klog
	{
		verbose := klog.V(0)
		verbose.Info(username)   // $ hasTaintFlow="username"
		verbose.Infof(username)  // $ hasTaintFlow="username"
		verbose.Infoln(username) // $ hasTaintFlow="username"
		klog.Info(username)      // $ hasTaintFlow="username"
		klog.Infof(username)     // $ hasTaintFlow="username"
		klog.Infoln(username)    // $ hasTaintFlow="username"
		klog.Error(username)     // $ hasTaintFlow="username"
		klog.Errorf(username)    // $ hasTaintFlow="username"
		klog.Errorln(username)   // $ hasTaintFlow="username"
		klog.Fatal(username)     // $ hasTaintFlow="username"
		klog.Fatalf(username)    // $ hasTaintFlow="username"
		klog.Fatalln(username)   // $ hasTaintFlow="username"
		klog.Exit(username)      // $ hasTaintFlow="username"
		klog.Exitf(username)     // $ hasTaintFlow="username"
		klog.Exitln(username)    // $ hasTaintFlow="username"
	}
	// astaxie/beego
	{
		beego.Alert(username)         // $ hasTaintFlow="username"
		beego.Critical(username)      // $ hasTaintFlow="username"
		beego.Debug(username)         // $ hasTaintFlow="username"
		beego.Emergency(username)     // $ hasTaintFlow="username"
		beego.Error(username)         // $ hasTaintFlow="username"
		beego.Info(username)          // $ hasTaintFlow="username"
		beego.Informational(username) // $ hasTaintFlow="username"
		beego.Notice(username)        // $ hasTaintFlow="username"
		beego.Trace(username)         // $ hasTaintFlow="username"
		beego.Warn(username)          // $ hasTaintFlow="username"
		beego.Warning(username)       // $ hasTaintFlow="username"

		logs.Alert(username)         // $ hasTaintFlow="username"
		logs.Critical(username)      // $ hasTaintFlow="username"
		logs.Debug(username)         // $ hasTaintFlow="username"
		logs.Emergency(username)     // $ hasTaintFlow="username"
		logs.Error(username)         // $ hasTaintFlow="username"
		logs.Info(username)          // $ hasTaintFlow="username"
		logs.Informational(username) // $ hasTaintFlow="username"
		logs.Notice(username)        // $ hasTaintFlow="username"
		logs.Trace(username)         // $ hasTaintFlow="username"
		logs.Warn(username)          // $ hasTaintFlow="username"
		logs.Warning(username)       // $ hasTaintFlow="username"

		log := logs.NewLogger(10000)
		log.Alert(username)         // $ hasTaintFlow="username"
		log.Critical(username)      // $ hasTaintFlow="username"
		log.Debug(username)         // $ hasTaintFlow="username"
		log.Emergency(username)     // $ hasTaintFlow="username"
		log.Error(username)         // $ hasTaintFlow="username"
		log.Info(username)          // $ hasTaintFlow="username"
		log.Informational(username) // $ hasTaintFlow="username"
		log.Notice(username)        // $ hasTaintFlow="username"
		log.Trace(username)         // $ hasTaintFlow="username"
		log.Warn(username)          // $ hasTaintFlow="username"
		log.Warning(username)       // $ hasTaintFlow="username"

		utils.Display(username) // $ hasTaintFlow="username"
	}
	// elazarl/goproxy
	{
		ctx.Logf(username)        // $ hasTaintFlow="username"
		ctx.Logf("%s", username)  // $ hasTaintFlow="username"
		ctx.Warnf(username)       // $ hasTaintFlow="username"
		ctx.Warnf("%s", username) // $ hasTaintFlow="username"
	}
	// golang/glog
	{
		verbose := glog.V(0)
		verbose.Info(username)   // $ hasTaintFlow="username"
		verbose.Infof(username)  // $ hasTaintFlow="username"
		verbose.Infoln(username) // $ hasTaintFlow="username"

		glog.Info(username)          // $ hasTaintFlow="username"
		glog.InfoDepth(0, username)  // $ hasTaintFlow="username"
		glog.Infof(username)         // $ hasTaintFlow="username"
		glog.Infoln(username)        // $ hasTaintFlow="username"
		glog.Error(username)         // $ hasTaintFlow="username"
		glog.ErrorDepth(0, username) // $ hasTaintFlow="username"
		glog.Errorf(username)        // $ hasTaintFlow="username"
		glog.Errorln(username)       // $ hasTaintFlow="username"
		glog.Fatal(username)         // $ hasTaintFlow="username"
		glog.FatalDepth(0, username) // $ hasTaintFlow="username"
		glog.Fatalf(username)        // $ hasTaintFlow="username"
		glog.Fatalln(username)       // $ hasTaintFlow="username"
		glog.Exit(username)          // $ hasTaintFlow="username"
		glog.ExitDepth(0, username)  // $ hasTaintFlow="username"
		glog.Exitf(username)         // $ hasTaintFlow="username"
		glog.Exitln(username)        // $ hasTaintFlow="username"

	}
	// sirupsen/logrus
	{
		err := fmt.Errorf("error: %s", username)
		fields := make(logrus.Fields)
		fields["username"] = username
		logger := logrus.New()
		entry := logrus.NewEntry(logger)

		logrus.Debug(username)         // $ hasTaintFlow="username"
		logrus.Debugf(username, "")    // $ hasTaintFlow="username"
		logrus.Debugf("", username)    // $ hasTaintFlow="username"
		logrus.Debugln(username)       // $ hasTaintFlow="username"
		logrus.Error(username)         // $ hasTaintFlow="username"
		logrus.Errorf(username, "")    // $ hasTaintFlow="username"
		logrus.Errorf("", username)    // $ hasTaintFlow="username"
		logrus.Errorln(username)       // $ hasTaintFlow="username"
		logrus.Fatal(username)         // $ hasTaintFlow="username"
		logrus.Fatalf(username, "")    // $ hasTaintFlow="username"
		logrus.Fatalf("", username)    // $ hasTaintFlow="username"
		logrus.Fatalln(username)       // $ hasTaintFlow="username"
		logrus.Info(username)          // $ hasTaintFlow="username"
		logrus.Infof(username, "")     // $ hasTaintFlow="username"
		logrus.Infof("", username)     // $ hasTaintFlow="username"
		logrus.Infoln(username)        // $ hasTaintFlow="username"
		logrus.Panic(username)         // $ hasTaintFlow="username"
		logrus.Panicf(username, "")    // $ hasTaintFlow="username"
		logrus.Panicf("", username)    // $ hasTaintFlow="username"
		logrus.Panicln(username)       // $ hasTaintFlow="username"
		logrus.Print(username)         // $ hasTaintFlow="username"
		logrus.Printf(username, "")    // $ hasTaintFlow="username"
		logrus.Printf("", username)    // $ hasTaintFlow="username"
		logrus.Println(username)       // $ hasTaintFlow="username"
		logrus.Trace(username)         // $ hasTaintFlow="username"
		logrus.Tracef(username, "")    // $ hasTaintFlow="username"
		logrus.Tracef("", username)    // $ hasTaintFlow="username"
		logrus.Traceln(username)       // $ hasTaintFlow="username"
		logrus.Warn(username)          // $ hasTaintFlow="username"
		logrus.Warnf(username, "")     // $ hasTaintFlow="username"
		logrus.Warnf("", username)     // $ hasTaintFlow="username"
		logrus.Warnln(username)        // $ hasTaintFlow="username"
		logrus.Warning(username)       // $ hasTaintFlow="username"
		logrus.Warningf(username, "")  // $ hasTaintFlow="username"
		logrus.Warningf("", username)  // $ hasTaintFlow="username"
		logrus.Warningln(username)     // $ hasTaintFlow="username"
		logrus.WithError(err)          // $ hasTaintFlow="err"
		logrus.WithField(username, "") // $ hasTaintFlow="username"
		logrus.WithField("", username) // $ hasTaintFlow="username"
		logrus.WithFields(fields)      // $ hasTaintFlow="fields"

		entry.Debug(username)         // $ hasTaintFlow="username"
		entry.Debugf(username, "")    // $ hasTaintFlow="username"
		entry.Debugf("", username)    // $ hasTaintFlow="username"
		entry.Debugln(username)       // $ hasTaintFlow="username"
		entry.Error(username)         // $ hasTaintFlow="username"
		entry.Errorf(username, "")    // $ hasTaintFlow="username"
		entry.Errorf("", username)    // $ hasTaintFlow="username"
		entry.Errorln(username)       // $ hasTaintFlow="username"
		entry.Fatal(username)         // $ hasTaintFlow="username"
		entry.Fatalf(username, "")    // $ hasTaintFlow="username"
		entry.Fatalf("", username)    // $ hasTaintFlow="username"
		entry.Fatalln(username)       // $ hasTaintFlow="username"
		entry.Info(username)          // $ hasTaintFlow="username"
		entry.Infof(username, "")     // $ hasTaintFlow="username"
		entry.Infof("", username)     // $ hasTaintFlow="username"
		entry.Infoln(username)        // $ hasTaintFlow="username"
		entry.Log(0, username)        // $ hasTaintFlow="username"
		entry.Logf(0, username, "")   // $ hasTaintFlow="username"
		entry.Logf(0, "", username)   // $ hasTaintFlow="username"
		entry.Logln(0, username)      // $ hasTaintFlow="username"
		entry.Panic(username)         // $ hasTaintFlow="username"
		entry.Panicf(username, "")    // $ hasTaintFlow="username"
		entry.Panicf("", username)    // $ hasTaintFlow="username"
		entry.Panicln(username)       // $ hasTaintFlow="username"
		entry.Print(username)         // $ hasTaintFlow="username"
		entry.Printf(username, "")    // $ hasTaintFlow="username"
		entry.Printf("", username)    // $ hasTaintFlow="username"
		entry.Println(username)       // $ hasTaintFlow="username"
		entry.Trace(username)         // $ hasTaintFlow="username"
		entry.Tracef(username, "")    // $ hasTaintFlow="username"
		entry.Tracef("", username)    // $ hasTaintFlow="username"
		entry.Traceln(username)       // $ hasTaintFlow="username"
		entry.Warn(username)          // $ hasTaintFlow="username"
		entry.Warnf(username, "")     // $ hasTaintFlow="username"
		entry.Warnf("", username)     // $ hasTaintFlow="username"
		entry.Warnln(username)        // $ hasTaintFlow="username"
		entry.Warning(username)       // $ hasTaintFlow="username"
		entry.Warningf(username, "")  // $ hasTaintFlow="username"
		entry.Warningf("", username)  // $ hasTaintFlow="username"
		entry.Warningln(username)     // $ hasTaintFlow="username"
		entry.WithError(err)          // $ hasTaintFlow="err"
		entry.WithField(username, "") // $ hasTaintFlow="username"
		entry.WithField("", username) // $ hasTaintFlow="username"
		entry.WithFields(fields)      // $ hasTaintFlow="fields"

		logger.Debug(username)         // $ hasTaintFlow="username"
		logger.Debugf(username, "")    // $ hasTaintFlow="username"
		logger.Debugf("", username)    // $ hasTaintFlow="username"
		logger.Debugln(username)       // $ hasTaintFlow="username"
		logger.Error(username)         // $ hasTaintFlow="username"
		logger.Errorf(username, "")    // $ hasTaintFlow="username"
		logger.Errorf("", username)    // $ hasTaintFlow="username"
		logger.Errorln(username)       // $ hasTaintFlow="username"
		logger.Fatal(username)         // $ hasTaintFlow="username"
		logger.Fatalf(username, "")    // $ hasTaintFlow="username"
		logger.Fatalf("", username)    // $ hasTaintFlow="username"
		logger.Fatalln(username)       // $ hasTaintFlow="username"
		logger.Info(username)          // $ hasTaintFlow="username"
		logger.Infof(username, "")     // $ hasTaintFlow="username"
		logger.Infof("", username)     // $ hasTaintFlow="username"
		logger.Infoln(username)        // $ hasTaintFlow="username"
		logger.Log(0, username)        // $ hasTaintFlow="username"
		logger.Logf(0, username, "")   // $ hasTaintFlow="username"
		logger.Logf(0, "", username)   // $ hasTaintFlow="username"
		logger.Logln(0, username)      // $ hasTaintFlow="username"
		logger.Panic(username)         // $ hasTaintFlow="username"
		logger.Panicf(username, "")    // $ hasTaintFlow="username"
		logger.Panicf("", username)    // $ hasTaintFlow="username"
		logger.Panicln(username)       // $ hasTaintFlow="username"
		logger.Print(username)         // $ hasTaintFlow="username"
		logger.Printf(username, "")    // $ hasTaintFlow="username"
		logger.Printf("", username)    // $ hasTaintFlow="username"
		logger.Println(username)       // $ hasTaintFlow="username"
		logger.Trace(username)         // $ hasTaintFlow="username"
		logger.Tracef(username, "")    // $ hasTaintFlow="username"
		logger.Tracef("", username)    // $ hasTaintFlow="username"
		logger.Traceln(username)       // $ hasTaintFlow="username"
		logger.Warn(username)          // $ hasTaintFlow="username"
		logger.Warnf(username, "")     // $ hasTaintFlow="username"
		logger.Warnf("", username)     // $ hasTaintFlow="username"
		logger.Warnln(username)        // $ hasTaintFlow="username"
		logger.Warning(username)       // $ hasTaintFlow="username"
		logger.Warningf(username, "")  // $ hasTaintFlow="username"
		logger.Warningf("", username)  // $ hasTaintFlow="username"
		logger.Warningln(username)     // $ hasTaintFlow="username"
		logger.WithError(err)          // $ hasTaintFlow="err"
		logger.WithField(username, "") // $ hasTaintFlow="username"
		logger.WithField("", username) // $ hasTaintFlow="username"
		logger.WithFields(fields)      // $ hasTaintFlow="fields"

		var fieldlogger logrus.FieldLogger = entry
		fieldlogger.Debug(username)         // $ hasTaintFlow="username"
		fieldlogger.Debugf(username, "")    // $ hasTaintFlow="username"
		fieldlogger.Debugf("", username)    // $ hasTaintFlow="username"
		fieldlogger.Debugln(username)       // $ hasTaintFlow="username"
		fieldlogger.Error(username)         // $ hasTaintFlow="username"
		fieldlogger.Errorf(username, "")    // $ hasTaintFlow="username"
		fieldlogger.Errorf("", username)    // $ hasTaintFlow="username"
		fieldlogger.Errorln(username)       // $ hasTaintFlow="username"
		fieldlogger.Fatal(username)         // $ hasTaintFlow="username"
		fieldlogger.Fatalf(username, "")    // $ hasTaintFlow="username"
		fieldlogger.Fatalf("", username)    // $ hasTaintFlow="username"
		fieldlogger.Fatalln(username)       // $ hasTaintFlow="username"
		fieldlogger.Info(username)          // $ hasTaintFlow="username"
		fieldlogger.Infof(username, "")     // $ hasTaintFlow="username"
		fieldlogger.Infof("", username)     // $ hasTaintFlow="username"
		fieldlogger.Infoln(username)        // $ hasTaintFlow="username"
		fieldlogger.Panic(username)         // $ hasTaintFlow="username"
		fieldlogger.Panicf(username, "")    // $ hasTaintFlow="username"
		fieldlogger.Panicf("", username)    // $ hasTaintFlow="username"
		fieldlogger.Panicln(username)       // $ hasTaintFlow="username"
		fieldlogger.Print(username)         // $ hasTaintFlow="username"
		fieldlogger.Printf(username, "")    // $ hasTaintFlow="username"
		fieldlogger.Printf("", username)    // $ hasTaintFlow="username"
		fieldlogger.Println(username)       // $ hasTaintFlow="username"
		fieldlogger.Warn(username)          // $ hasTaintFlow="username"
		fieldlogger.Warnf(username, "")     // $ hasTaintFlow="username"
		fieldlogger.Warnf("", username)     // $ hasTaintFlow="username"
		fieldlogger.Warnln(username)        // $ hasTaintFlow="username"
		fieldlogger.Warning(username)       // $ hasTaintFlow="username"
		fieldlogger.Warningf(username, "")  // $ hasTaintFlow="username"
		fieldlogger.Warningf("", username)  // $ hasTaintFlow="username"
		fieldlogger.Warningln(username)     // $ hasTaintFlow="username"
		fieldlogger.WithError(err)          // $ hasTaintFlow="err"
		fieldlogger.WithField(username, "") // $ hasTaintFlow="username"
		fieldlogger.WithField("", username) // $ hasTaintFlow="username"
		fieldlogger.WithFields(fields)      // $ hasTaintFlow="fields"
	}
	// davecgh/go-spew/spew
	{
		spew.Dump(username)          // $ hasTaintFlow="username"
		spew.Errorf(username)        // $ hasTaintFlow="username"
		spew.Print(username)         // $ hasTaintFlow="username"
		spew.Printf(username)        // $ hasTaintFlow="username"
		spew.Println(username)       // $ hasTaintFlow="username"
		spew.Fdump(nil, username)    // $ hasTaintFlow="username"
		spew.Fprint(nil, username)   // $ hasTaintFlow="username"
		spew.Fprintf(nil, username)  // $ hasTaintFlow="username"
		spew.Fprintln(nil, username) // $ hasTaintFlow="username"
	}
	// zap
	{
		logger, _ := zap.NewProduction()
		logger.DPanic(username) // $ hasTaintFlow="username"
		logger.Debug(username)  // $ hasTaintFlow="username"
		logger.Error(username)  // $ hasTaintFlow="username"
		if testFlag == " true" {
			logger.Fatal(username) // $ hasTaintFlow="username"
		}
		logger.Info(username) // $ hasTaintFlow="username"
		if testFlag == " true" {
			logger.Panic(username) // $ hasTaintFlow="username"
		}
		logger.Warn(username)        // $ hasTaintFlow="username"
		logger.Named(username)       // $ hasTaintFlow="username"
		logger.With(username)        // $ hasTaintFlow="username"
		logger.WithOptions(username) // $ hasTaintFlow="username"

		sLogger := logger.Sugar()
		sLogger.DPanic(username) // $ hasTaintFlow="username"
		sLogger.Debug(username)  // $ hasTaintFlow="username"
		sLogger.Error(username)  // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Fatal(username) // $ hasTaintFlow="username"
		}
		sLogger.Info(username) // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Panic(username) // $ hasTaintFlow="username"
		}
		sLogger.Warn(username)    // $ hasTaintFlow="username"
		sLogger.DPanicf(username) // $ hasTaintFlow="username"
		sLogger.Debugf(username)  // $ hasTaintFlow="username"
		sLogger.Errorf(username)  // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Fatalf(username) // $ hasTaintFlow="username"
		}
		sLogger.Infof(username) // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Panicf(username) // $ hasTaintFlow="username"
		}
		sLogger.Warnf(username)   // $ hasTaintFlow="username"
		sLogger.DPanicw(username) // $ hasTaintFlow="username"
		sLogger.Debugw(username)  // $ hasTaintFlow="username"
		sLogger.Errorw(username)  // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Fatalw(username) // $ hasTaintFlow="username"
		}
		sLogger.Infow(username) // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Panicw(username) // $ hasTaintFlow="username"
		}
		sLogger.Warnw(username) // $ hasTaintFlow="username"
		sLogger.Named(username) // $ hasTaintFlow="username"
		sLogger.With(username)  // $ hasTaintFlow="username"
	}
	// heuristic logger interface
	{
		logger.Printf(username)                // $ hasTaintFlow="username"
		logger.Printf("%s", username)          // $ hasTaintFlow="username"
		simpleLogger.Tracew(username)          // $ hasTaintFlow="username"
		simpleLogger.Tracew("%s", username)    // $ hasTaintFlow="username"
		simpleLogger.Debugw("%s %s", slice...) // $ hasTaintFlow="slice"
	}

}

type Logger interface {
	Printf(string, ...interface{})
}

type SimpleLogger interface {
	Debugw(msg string, keysAndValues ...any)
	Infow(msg string, keysAndValues ...any)
	Warnw(msg string, keysAndValues ...any)
	Errorw(msg string, keysAndValues ...any)
	Tracew(msg string, keysAndValues ...any)
}

var (
	logger       Logger
	simpleLogger SimpleLogger
)

// GOOD: The user-provided value is escaped before being written to the log.
func handlerGood(req *http.Request) {
	username := req.URL.Query()["username"][0]
	escapedUsername := strings.Replace(username, "\n", "", -1)
	escapedUsername = strings.Replace(escapedUsername, "\r", "", -1)
	log.Printf("user %s logged in.\n", escapedUsername)
}

// GOOD: The user-provided value is escaped before being written to the log.
func handlerGood2(req *http.Request) {
	username := req.URL.Query()["username"][0]
	escapedUsername := strings.ReplaceAll(username, "\n", "")
	escapedUsername = strings.ReplaceAll(escapedUsername, "\r", "")
	log.Printf("user %s logged in.\n", escapedUsername)
}

// GOOD: The user-provided value is escaped before being written to the log.
func handlerGood3(req *http.Request) {
	username := req.URL.Query()["username"][0]
	replacer := strings.NewReplacer("\n", "", "\r", "")
	log.Printf("user %s logged in.\n", replacer.Replace(username))
	log.Printf("user %s logged in.\n", replacerLocal1(username))
	log.Printf("user %s logged in.\n", replacerLocal2(username))
	log.Printf("user %s logged in.\n", replacerGlobal1(username))
	log.Printf("user %s logged in.\n", replacerGlobal2(username))
}

func replacerLocal1(s string) string {
	replacer := strings.NewReplacer("\n", "", "\r", "")
	return replacer.Replace(s)
}

func replacerLocal2(s string) string {
	replacer := strings.NewReplacer("\n", "", "\r", "")
	buf := new(bytes.Buffer)
	replacer.WriteString(buf, s)
	return buf.String()
}

var globalReplacer = strings.NewReplacer("\n", "", "\r", "")

func replacerGlobal1(s string) string {
	return globalReplacer.Replace(s)
}

func replacerGlobal2(s string) string {
	buf := new(bytes.Buffer)
	globalReplacer.WriteString(buf, s)
	return buf.String()
}

// GOOD: User-provided values formatted using a %q directive, which escapes newlines
func handlerGood4(req *http.Request, ctx *goproxy.ProxyCtx) {
	username := req.URL.Query()["username"][0]
	testFlag := req.URL.Query()["testFlag"][0]
	log.Printf("user %q logged in.\n", username)
	// Flags shouldn't make a difference...
	log.Printf("user %-50q logged in.\n", username)
	// Except for the '#' flag that retains newlines, emitting a backtick-delimited string:
	log.Printf("user %#10q logged in.\n", username) // $ hasTaintFlow="username"

	// Check this works with fmt:
	log.Print(fmt.Sprintf("user %q logged in.\n", username))
	log.Print(fmt.Sprintf("user %-50q logged in.\n", username))
	log.Print(fmt.Sprintf("user %#10q logged in.\n", username)) // $ hasTaintFlow="call to Sprintf"

	// Check this works with a variety of other loggers:
	// k8s.io/klog
	{
		verbose := klog.V(0)
		verbose.Infof("user %q logged in.\n", username)
		klog.Infof("user %q logged in.\n", username)
		klog.Errorf("user %q logged in.\n", username)
		klog.Fatalf("user %q logged in.\n", username)
		klog.Exitf("user %q logged in.\n", username)
	}
	// elazarl/goproxy
	{
		ctx.Logf("user %q logged in.\n", username)
		ctx.Warnf("user %q logged in.\n", username)
	}
	// golang/glog
	{
		verbose := glog.V(0)
		verbose.Infof("user %q logged in.\n", username)

		glog.Infof("user %q logged in.\n", username)
		glog.Errorf("user %q logged in.\n", username)
		glog.Fatalf("user %q logged in.\n", username)
		glog.Exitf("user %q logged in.\n", username)
	}
	// sirupsen/logrus
	{
		logrus.Debugf("user %q logged in.\n", username)
		logrus.Errorf("user %q logged in.\n", username)
		logrus.Fatalf("user %q logged in.\n", username)
		logrus.Infof("user %q logged in.\n", username)
		logrus.Panicf("user %q logged in.\n", username)
		logrus.Printf("user %q logged in.\n", username)
		logrus.Tracef("user %q logged in.\n", username)
		logrus.Warnf("user %q logged in.\n", username)
		logrus.Warningf("user %q logged in.\n", username)

		fields := make(logrus.Fields)
		entry := logrus.WithFields(fields)
		entry.Debugf("user %q logged in.\n", username)
		entry.Errorf("user %q logged in.\n", username)
		entry.Fatalf("user %q logged in.\n", username)
		entry.Infof("user %q logged in.\n", username)
		entry.Logf(0, "user %q logged in.\n", username)
		entry.Panicf("user %q logged in.\n", username)
		entry.Printf("user %q logged in.\n", username)
		entry.Tracef("user %q logged in.\n", username)
		entry.Warnf("user %q logged in.\n", username)
		entry.Warningf("user %q logged in.\n", username)

		logger := entry.Logger
		logger.Debugf("user %q logged in.\n", username)
		logger.Errorf("user %q logged in.\n", username)
		logger.Fatalf("user %q logged in.\n", username)
		logger.Infof("user %q logged in.\n", username)
		logger.Logf(0, "user %q logged in.\n", username)
		logger.Panicf("user %q logged in.\n", username)
		logger.Printf("user %q logged in.\n", username)
		logger.Tracef("user %q logged in.\n", username)
		logger.Warnf("user %q logged in.\n", username)
		logger.Warningf("user %q logged in.\n", username)
	}
	// davecgh/go-spew/spew
	{
		spew.Errorf("user %q logged in.\n", username)
		spew.Printf("user %q logged in.\n", username)
		spew.Fprintf(nil, "user %q logged in.\n", username)
	}
	// zap
	{
		logger, _ := zap.NewProduction()
		sLogger := logger.Sugar()
		sLogger.DPanicf("user %q logged in.\n", username)
		sLogger.Debugf("user %q logged in.\n", username)
		sLogger.Errorf("user %q logged in.\n", username)
		if testFlag == " true" {
			sLogger.Fatalf("user %q logged in.\n", username)
		}
		sLogger.Infof("user %q logged in.\n", username)
		if testFlag == " true" {
			sLogger.Panicf("user %q logged in.\n", username)
		}
		sLogger.Warnf("user %q logged in.\n", username)
	}

	// Check those same loggers recognise that %#q is still dangerous:
	// k8s.io/klog
	{
		verbose := klog.V(0)
		verbose.Infof("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		klog.Infof("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		klog.Errorf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		klog.Fatalf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		klog.Exitf("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
	}
	// elazarl/goproxy
	{
		ctx.Logf("user %#q logged in.\n", username)  // $ hasTaintFlow="username"
		ctx.Warnf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
	}
	// golang/glog
	{
		verbose := glog.V(0)
		verbose.Infof("user %#q logged in.\n", username) // $ hasTaintFlow="username"

		glog.Infof("user %#q logged in.\n", username)  // $ hasTaintFlow="username"
		glog.Errorf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		glog.Fatalf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		glog.Exitf("user %#q logged in.\n", username)  // $ hasTaintFlow="username"
	}
	// sirupsen/logrus
	{
		logrus.Debugf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logrus.Errorf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logrus.Fatalf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logrus.Infof("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		logrus.Panicf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logrus.Printf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logrus.Tracef("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logrus.Warnf("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		logrus.Warningf("user %#q logged in.\n", username) // $ hasTaintFlow="username"

		fields := make(logrus.Fields)
		entry := logrus.WithFields(fields)
		entry.Debugf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		entry.Errorf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		entry.Fatalf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		entry.Infof("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		entry.Logf(0, "user %#q logged in.\n", username)  // $ hasTaintFlow="username"
		entry.Panicf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		entry.Printf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		entry.Tracef("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		entry.Warnf("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		entry.Warningf("user %#q logged in.\n", username) // $ hasTaintFlow="username"

		logger := entry.Logger
		logger.Debugf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Errorf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Fatalf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Infof("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		logger.Logf(0, "user %#q logged in.\n", username)  // $ hasTaintFlow="username"
		logger.Panicf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Printf("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Tracef("user %#q logged in.\n", username)   // $ hasTaintFlow="username"
		logger.Warnf("user %#q logged in.\n", username)    // $ hasTaintFlow="username"
		logger.Warningf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
	}
	// davecgh/go-spew/spew
	{
		spew.Errorf("user %#q logged in.\n", username)       // $ hasTaintFlow="username"
		spew.Printf("user %#q logged in.\n", username)       // $ hasTaintFlow="username"
		spew.Fprintf(nil, "user %#q logged in.\n", username) // $ hasTaintFlow="username"
	}
	// zap
	{
		logger, _ := zap.NewProduction()
		sLogger := logger.Sugar()
		sLogger.DPanicf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		sLogger.Debugf("user %#q logged in.\n", username)  // $ hasTaintFlow="username"
		sLogger.Errorf("user %#q logged in.\n", username)  // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Fatalf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		}
		sLogger.Infof("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		if testFlag == " true" {
			sLogger.Panicf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
		}
		sLogger.Warnf("user %#q logged in.\n", username) // $ hasTaintFlow="username"
	}
}
