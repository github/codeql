//go:generate depstubber -vendor github.com/golang/glog "" Error,ErrorDepth,Errorf,Errorln,Exit,ExitDepth,Exitf,Exitln,Fatal,FatalDepth,Fatalf,Fatalln,Info,InfoDepth,Infof,Infoln,Warning,WarningDepth,Warningf,Warningln
//go:generate depstubber -vendor k8s.io/klog "" Error,ErrorDepth,Errorf,Errorln,Exit,ExitDepth,Exitf,Exitln,Fatal,FatalDepth,Fatalf,Fatalln,Info,InfoDepth,Infof,Infoln,Warning,WarningDepth,Warningf,Warningln

package main

import (
	"github.com/golang/glog"
	"k8s.io/klog"
)

func glogTest() {
	glog.Error(text)           // $ logger=text
	glog.ErrorDepth(0, text)   // $ logger=text
	glog.Errorf(fmt, text)     // $ logger=fmt logger=text
	glog.Errorln(text)         // $ logger=text
	glog.Exit(text)            // $ logger=text
	glog.ExitDepth(0, text)    // $ logger=text
	glog.Exitf(fmt, text)      // $ logger=fmt logger=text
	glog.Exitln(text)          // $ logger=text
	glog.Fatal(text)           // $ logger=text
	glog.FatalDepth(0, text)   // $ logger=text
	glog.Fatalf(fmt, text)     // $ logger=fmt logger=text
	glog.Fatalln(text)         // $ logger=text
	glog.Info(text)            // $ logger=text
	glog.InfoDepth(0, text)    // $ logger=text
	glog.Infof(fmt, text)      // $ logger=fmt logger=text
	glog.Infoln(text)          // $ logger=text
	glog.Warning(text)         // $ logger=text
	glog.WarningDepth(0, text) // $ logger=text
	glog.Warningf(fmt, text)   // $ logger=fmt logger=text
	glog.Warningln(text)       // $ logger=text

	klog.Error(text)           // $ logger=text
	klog.ErrorDepth(0, text)   // $ logger=text
	klog.Errorf(fmt, text)     // $ logger=fmt logger=text
	klog.Errorln(text)         // $ logger=text
	klog.Exit(text)            // $ logger=text
	klog.ExitDepth(0, text)    // $ logger=text
	klog.Exitf(fmt, text)      // $ logger=fmt logger=text
	klog.Exitln(text)          // $ logger=text
	klog.Fatal(text)           // $ logger=text
	klog.FatalDepth(0, text)   // $ logger=text
	klog.Fatalf(fmt, text)     // $ logger=fmt logger=text
	klog.Fatalln(text)         // $ logger=text
	klog.Info(text)            // $ logger=text
	klog.InfoDepth(0, text)    // $ logger=text
	klog.Infof(fmt, text)      // $ logger=fmt logger=text
	klog.Infoln(text)          // $ logger=text
	klog.Warning(text)         // $ logger=text
	klog.WarningDepth(0, text) // $ logger=text
	klog.Warningf(fmt, text)   // $ logger=fmt logger=text
	klog.Warningln(text)       // $ logger=text
}
