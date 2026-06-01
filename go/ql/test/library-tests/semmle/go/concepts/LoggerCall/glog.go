//go:generate depstubber -vendor github.com/golang/glog Level,Verbose Error,ErrorContext,ErrorContextDepth,ErrorContextDepthf,ErrorContextf,ErrorDepth,ErrorDepthf,Errorf,Errorln,Exit,ExitContext,ExitContextDepth,ExitContextDepthf,ExitContextf,ExitDepth,ExitDepthf,Exitf,Exitln,Fatal,FatalContext,FatalContextDepth,FatalContextDepthf,FatalContextf,FatalDepth,FatalDepthf,Fatalf,Fatalln,Info,InfoContext,InfoContextDepth,InfoContextDepthf,InfoContextf,InfoDepth,InfoDepthf,Infof,Infoln,V,VDepth,Warning,WarningContext,WarningContextDepth,WarningContextDepthf,WarningContextf,WarningDepth,WarningDepthf,Warningf,Warningln
//go:generate depstubber -vendor k8s.io/klog Level,Verbose Error,ErrorDepth,Errorf,Errorln,Exit,ExitDepth,Exitf,Exitln,Fatal,FatalDepth,Fatalf,Fatalln,Info,InfoDepth,Infof,Infoln,V,Warning,WarningDepth,Warningf,Warningln

package main

import (
	"context"

	"github.com/golang/glog"
	"k8s.io/klog"
)

func glogTest(selector int) {
	ctx := context.Background()

	glog.Error(text)                           // $ logger=text
	glog.ErrorContext(ctx, text)               // $ logger=text
	glog.ErrorContextDepth(ctx, 0, text)       // $ logger=text
	glog.ErrorContextDepthf(ctx, 0, fmt, text) // $ logger=fmt logger=text
	glog.ErrorContextf(ctx, fmt, text)         // $ logger=fmt logger=text
	glog.ErrorDepth(0, text)                   // $ logger=text
	glog.ErrorDepthf(0, fmt, text)             // $ logger=fmt logger=text
	glog.Errorf(fmt, text)                     // $ logger=fmt logger=text
	glog.Errorln(text)                         // $ logger=text
	if selector == 1 {
		glog.Exit(text) // $ logger=text
	}
	if selector == 2 {
		glog.ExitContext(ctx, text) // $ logger=text
	}
	if selector == 3 {
		glog.ExitContextDepth(ctx, 0, text) // $ logger=text
	}
	if selector == 4 {
		glog.ExitContextDepthf(ctx, 0, fmt, text) // $ logger=fmt logger=text
	}
	if selector == 5 {
		glog.ExitContextf(ctx, fmt, text) // $ logger=fmt logger=text
	}
	if selector == 6 {
		glog.ExitDepth(0, text) // $ logger=text
	}
	if selector == 7 {
		glog.ExitDepthf(0, fmt, text) // $ logger=fmt logger=text
	}
	if selector == 8 {
		glog.Exitf(fmt, text) // $ logger=fmt logger=text
	}
	if selector == 9 {
		glog.Exitln(text) // $ logger=text
	}
	if selector == 10 {
		glog.Fatal(text) // $ logger=text
	}
	if selector == 11 {
		glog.FatalContext(ctx, text) // $ logger=text
	}
	if selector == 12 {
		glog.FatalContextDepth(ctx, 0, text) // $ logger=text
	}
	if selector == 13 {
		glog.FatalContextDepthf(ctx, 0, fmt, text) // $ logger=fmt logger=text
	}
	if selector == 14 {
		glog.FatalContextf(ctx, fmt, text) // $ logger=fmt logger=text
	}
	if selector == 15 {
		glog.FatalDepth(0, text) // $ logger=text
	}
	if selector == 16 {
		glog.FatalDepthf(0, fmt, text) // $ logger=fmt logger=text
	}
	if selector == 17 {
		glog.Fatalf(fmt, text) // $ logger=fmt logger=text
	}
	if selector == 18 {
		glog.Fatalln(text) // $ logger=text
	}
	glog.Info(text)                              // $ logger=text
	glog.InfoContext(ctx, text)                  // $ logger=text
	glog.InfoContextDepth(ctx, 0, text)          // $ logger=text
	glog.InfoContextDepthf(ctx, 0, fmt, text)    // $ logger=fmt logger=text
	glog.InfoContextf(ctx, fmt, text)            // $ logger=fmt logger=text
	glog.InfoDepth(0, text)                      // $ logger=text
	glog.InfoDepthf(0, fmt, text)                // $ logger=fmt logger=text
	glog.Infof(fmt, text)                        // $ logger=fmt logger=text
	glog.Infoln(text)                            // $ logger=text
	glog.Warning(text)                           // $ logger=text
	glog.WarningContext(ctx, text)               // $ logger=text
	glog.WarningContextDepth(ctx, 0, text)       // $ logger=text
	glog.WarningContextDepthf(ctx, 0, fmt, text) // $ logger=fmt logger=text
	glog.WarningContextf(ctx, fmt, text)         // $ logger=fmt logger=text
	glog.WarningDepth(0, text)                   // $ logger=text
	glog.WarningDepthf(0, fmt, text)             // $ logger=fmt logger=text
	glog.Warningf(fmt, text)                     // $ logger=fmt logger=text
	glog.Warningln(text)                         // $ logger=text

	glog.V(0).Info(text)                           // $ logger=text
	glog.V(0).InfoContext(ctx, text)               // $ logger=text
	glog.V(0).InfoContextDepth(ctx, 0, text)       // $ logger=text
	glog.V(0).InfoContextDepthf(ctx, 0, fmt, text) // $ logger=fmt logger=text
	glog.V(0).InfoContextf(ctx, fmt, text)         // $ logger=fmt logger=text
	glog.V(0).InfoDepth(0, text)                   // $ logger=text
	glog.V(0).InfoDepthf(0, fmt, text)             // $ logger=fmt logger=text
	glog.V(0).Infof(fmt, text)                     // $ logger=fmt logger=text
	glog.V(0).Infoln(text)                         // $ logger=text
	glog.VDepth(0, 0).Info(text)                   // $ logger=text

	// components corresponding to the format specifier "%T" are not considered vulnerable
	glog.ErrorContextDepthf(ctx, 0, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	glog.ErrorContextf(ctx, "%s: found type %T", text, v)         // $ logger="%s: found type %T" logger=text type-logger=v
	glog.ErrorDepthf(0, "%s: found type %T", text, v)             // $ logger="%s: found type %T" logger=text type-logger=v
	glog.Errorf("%s: found type %T", text, v)                     // $ logger="%s: found type %T" logger=text type-logger=v
	if selector == 19 {
		glog.ExitContextDepthf(ctx, 0, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 20 {
		glog.ExitContextf(ctx, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 21 {
		glog.ExitDepthf(0, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 22 {
		glog.Exitf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 23 {
		glog.FatalContextDepthf(ctx, 0, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 24 {
		glog.FatalContextf(ctx, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 25 {
		glog.FatalDepthf(0, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 26 {
		glog.Fatalf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	glog.InfoContextDepthf(ctx, 0, "%s: found type %T", text, v)      // $ logger="%s: found type %T" logger=text type-logger=v
	glog.InfoContextf(ctx, "%s: found type %T", text, v)              // $ logger="%s: found type %T" logger=text type-logger=v
	glog.InfoDepthf(0, "%s: found type %T", text, v)                  // $ logger="%s: found type %T" logger=text type-logger=v
	glog.Infof("%s: found type %T", text, v)                          // $ logger="%s: found type %T" logger=text type-logger=v
	glog.WarningContextDepthf(ctx, 0, "%s: found type %T", text, v)   // $ logger="%s: found type %T" logger=text type-logger=v
	glog.WarningContextf(ctx, "%s: found type %T", text, v)           // $ logger="%s: found type %T" logger=text type-logger=v
	glog.WarningDepthf(0, "%s: found type %T", text, v)               // $ logger="%s: found type %T" logger=text type-logger=v
	glog.Warningf("%s: found type %T", text, v)                       // $ logger="%s: found type %T" logger=text type-logger=v
	glog.V(0).InfoContextDepthf(ctx, 0, "%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	glog.V(0).InfoContextf(ctx, "%s: found type %T", text, v)         // $ logger="%s: found type %T" logger=text type-logger=v
	glog.V(0).InfoDepthf(0, "%s: found type %T", text, v)             // $ logger="%s: found type %T" logger=text type-logger=v
	glog.V(0).Infof("%s: found type %T", text, v)                     // $ logger="%s: found type %T" logger=text type-logger=v

	klog.Error(text)         // $ logger=text
	klog.ErrorDepth(0, text) // $ logger=text
	klog.Errorf(fmt, text)   // $ logger=fmt logger=text
	klog.Errorln(text)       // $ logger=text
	if selector == 27 {
		klog.Exit(text) // $ logger=text
	}
	if selector == 28 {
		klog.ExitDepth(0, text) // $ logger=text
	}
	if selector == 29 {
		klog.Exitf(fmt, text) // $ logger=fmt logger=text
	}
	if selector == 30 {
		klog.Exitln(text) // $ logger=text
	}
	if selector == 31 {
		klog.Fatal(text) // $ logger=text
	}
	if selector == 32 {
		klog.FatalDepth(0, text) // $ logger=text
	}
	if selector == 33 {
		klog.Fatalf(fmt, text) // $ logger=fmt logger=text
	}
	if selector == 34 {
		klog.Fatalln(text) // $ logger=text
	}
	klog.Info(text)            // $ logger=text
	klog.InfoDepth(0, text)    // $ logger=text
	klog.Infof(fmt, text)      // $ logger=fmt logger=text
	klog.Infoln(text)          // $ logger=text
	klog.Warning(text)         // $ logger=text
	klog.WarningDepth(0, text) // $ logger=text
	klog.Warningf(fmt, text)   // $ logger=fmt logger=text
	klog.Warningln(text)       // $ logger=text
	klog.V(0).Info(text)       // $ logger=text
	klog.V(0).Infof(fmt, text) // $ logger=fmt logger=text
	klog.V(0).Infoln(text)     // $ logger=text

	// components corresponding to the format specifier "%T" are not considered vulnerable
	klog.Errorf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	if selector == 35 {
		klog.Exitf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	if selector == 36 {
		klog.Fatalf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
	klog.Infof("%s: found type %T", text, v)      // $ logger="%s: found type %T" logger=text type-logger=v
	klog.Warningf("%s: found type %T", text, v)   // $ logger="%s: found type %T" logger=text type-logger=v
	klog.V(0).Infof("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
}
