/**
 * Provides modeling for the `Mime` component of the `Rack` library.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

private predicate mimeTypeMatches(string ext, string mimeType) {
  ext = ".123" and mimeType = "application/vnd.lotus-1-2-3"
  or
  ext = ".3dml" and mimeType = "text/vnd.in3d.3dml"
  or
  ext = ".3g2" and mimeType = "video/3gpp2"
  or
  ext = ".3gp" and mimeType = "video/3gpp"
  or
  ext = ".a" and mimeType = "application/octet-stream"
  or
  ext = ".acc" and mimeType = "application/vnd.americandynamics.acc"
  or
  ext = ".ace" and mimeType = "application/x-ace-compressed"
  or
  ext = ".acu" and mimeType = "application/vnd.acucobol"
  or
  ext = ".aep" and mimeType = "application/vnd.audiograph"
  or
  ext = ".afp" and mimeType = "application/vnd.ibm.modcap"
  or
  ext = ".ai" and mimeType = "application/postscript"
  or
  ext = ".aif" and mimeType = "audio/x-aiff"
  or
  ext = ".aiff" and mimeType = "audio/x-aiff"
  or
  ext = ".ami" and mimeType = "application/vnd.amiga.ami"
  or
  ext = ".apng" and mimeType = "image/apng"
  or
  ext = ".appcache" and mimeType = "text/cache-manifest"
  or
  ext = ".apr" and mimeType = "application/vnd.lotus-approach"
  or
  ext = ".asc" and mimeType = "application/pgp-signature"
  or
  ext = ".asf" and mimeType = "video/x-ms-asf"
  or
  ext = ".asm" and mimeType = "text/x-asm"
  or
  ext = ".aso" and mimeType = "application/vnd.accpac.simply.aso"
  or
  ext = ".asx" and mimeType = "video/x-ms-asf"
  or
  ext = ".atc" and mimeType = "application/vnd.acucorp"
  or
  ext = ".atom" and mimeType = "application/atom+xml"
  or
  ext = ".atomcat" and mimeType = "application/atomcat+xml"
  or
  ext = ".atomsvc" and mimeType = "application/atomsvc+xml"
  or
  ext = ".atx" and mimeType = "application/vnd.antix.game-component"
  or
  ext = ".au" and mimeType = "audio/basic"
  or
  ext = ".avi" and mimeType = "video/x-msvideo"
  or
  ext = ".avif" and mimeType = "image/avif"
  or
  ext = ".bat" and mimeType = "application/x-msdownload"
  or
  ext = ".bcpio" and mimeType = "application/x-bcpio"
  or
  ext = ".bdm" and mimeType = "application/vnd.syncml.dm+wbxml"
  or
  ext = ".bh2" and mimeType = "application/vnd.fujitsu.oasysprs"
  or
  ext = ".bin" and mimeType = "application/octet-stream"
  or
  ext = ".bmi" and mimeType = "application/vnd.bmi"
  or
  ext = ".bmp" and mimeType = "image/bmp"
  or
  ext = ".box" and mimeType = "application/vnd.previewsystems.box"
  or
  ext = ".btif" and mimeType = "image/prs.btif"
  or
  ext = ".bz" and mimeType = "application/x-bzip"
  or
  ext = ".bz2" and mimeType = "application/x-bzip2"
  or
  ext = ".c" and mimeType = "text/x-c"
  or
  ext = ".c4g" and mimeType = "application/vnd.clonk.c4group"
  or
  ext = ".cab" and mimeType = "application/vnd.ms-cab-compressed"
  or
  ext = ".cc" and mimeType = "text/x-c"
  or
  ext = ".ccxml" and mimeType = "application/ccxml+xml"
  or
  ext = ".cdbcmsg" and mimeType = "application/vnd.contact.cmsg"
  or
  ext = ".cdkey" and mimeType = "application/vnd.mediastation.cdkey"
  or
  ext = ".cdx" and mimeType = "chemical/x-cdx"
  or
  ext = ".cdxml" and mimeType = "application/vnd.chemdraw+xml"
  or
  ext = ".cdy" and mimeType = "application/vnd.cinderella"
  or
  ext = ".cer" and mimeType = "application/pkix-cert"
  or
  ext = ".cgm" and mimeType = "image/cgm"
  or
  ext = ".chat" and mimeType = "application/x-chat"
  or
  ext = ".chm" and mimeType = "application/vnd.ms-htmlhelp"
  or
  ext = ".chrt" and mimeType = "application/vnd.kde.kchart"
  or
  ext = ".cif" and mimeType = "chemical/x-cif"
  or
  ext = ".cii" and mimeType = "application/vnd.anser-web-certificate-issue-initiation"
  or
  ext = ".cil" and mimeType = "application/vnd.ms-artgalry"
  or
  ext = ".cla" and mimeType = "application/vnd.claymore"
  or
  ext = ".class" and mimeType = "application/octet-stream"
  or
  ext = ".clkk" and mimeType = "application/vnd.crick.clicker.keyboard"
  or
  ext = ".clkp" and mimeType = "application/vnd.crick.clicker.palette"
  or
  ext = ".clkt" and mimeType = "application/vnd.crick.clicker.template"
  or
  ext = ".clkw" and mimeType = "application/vnd.crick.clicker.wordbank"
  or
  ext = ".clkx" and mimeType = "application/vnd.crick.clicker"
  or
  ext = ".clp" and mimeType = "application/x-msclip"
  or
  ext = ".cmc" and mimeType = "application/vnd.cosmocaller"
  or
  ext = ".cmdf" and mimeType = "chemical/x-cmdf"
  or
  ext = ".cml" and mimeType = "chemical/x-cml"
  or
  ext = ".cmp" and mimeType = "application/vnd.yellowriver-custom-menu"
  or
  ext = ".cmx" and mimeType = "image/x-cmx"
  or
  ext = ".com" and mimeType = "application/x-msdownload"
  or
  ext = ".conf" and mimeType = "text/plain"
  or
  ext = ".cpio" and mimeType = "application/x-cpio"
  or
  ext = ".cpp" and mimeType = "text/x-c"
  or
  ext = ".cpt" and mimeType = "application/mac-compactpro"
  or
  ext = ".crd" and mimeType = "application/x-mscardfile"
  or
  ext = ".crl" and mimeType = "application/pkix-crl"
  or
  ext = ".crt" and mimeType = "application/x-x509-ca-cert"
  or
  ext = ".csh" and mimeType = "application/x-csh"
  or
  ext = ".csml" and mimeType = "chemical/x-csml"
  or
  ext = ".csp" and mimeType = "application/vnd.commonspace"
  or
  ext = ".css" and mimeType = "text/css"
  or
  ext = ".csv" and mimeType = "text/csv"
  or
  ext = ".curl" and mimeType = "application/vnd.curl"
  or
  ext = ".cww" and mimeType = "application/prs.cww"
  or
  ext = ".cxx" and mimeType = "text/x-c"
  or
  ext = ".daf" and mimeType = "application/vnd.mobius.daf"
  or
  ext = ".davmount" and mimeType = "application/davmount+xml"
  or
  ext = ".dcr" and mimeType = "application/x-director"
  or
  ext = ".dd2" and mimeType = "application/vnd.oma.dd2+xml"
  or
  ext = ".ddd" and mimeType = "application/vnd.fujixerox.ddd"
  or
  ext = ".deb" and mimeType = "application/x-debian-package"
  or
  ext = ".der" and mimeType = "application/x-x509-ca-cert"
  or
  ext = ".dfac" and mimeType = "application/vnd.dreamfactory"
  or
  ext = ".diff" and mimeType = "text/x-diff"
  or
  ext = ".dis" and mimeType = "application/vnd.mobius.dis"
  or
  ext = ".djv" and mimeType = "image/vnd.djvu"
  or
  ext = ".djvu" and mimeType = "image/vnd.djvu"
  or
  ext = ".dll" and mimeType = "application/x-msdownload"
  or
  ext = ".dmg" and mimeType = "application/octet-stream"
  or
  ext = ".dna" and mimeType = "application/vnd.dna"
  or
  ext = ".doc" and mimeType = "application/msword"
  or
  ext = ".docm" and mimeType = "application/vnd.ms-word.document.macroEnabled.12"
  or
  ext = ".docx" and
  mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  or
  ext = ".dot" and mimeType = "application/msword"
  or
  ext = ".dotm" and mimeType = "application/vnd.ms-word.template.macroEnabled.12"
  or
  ext = ".dotx" and
  mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
  or
  ext = ".dp" and mimeType = "application/vnd.osgi.dp"
  or
  ext = ".dpg" and mimeType = "application/vnd.dpgraph"
  or
  ext = ".dsc" and mimeType = "text/prs.lines.tag"
  or
  ext = ".dtd" and mimeType = "application/xml-dtd"
  or
  ext = ".dts" and mimeType = "audio/vnd.dts"
  or
  ext = ".dtshd" and mimeType = "audio/vnd.dts.hd"
  or
  ext = ".dv" and mimeType = "video/x-dv"
  or
  ext = ".dvi" and mimeType = "application/x-dvi"
  or
  ext = ".dwf" and mimeType = "model/vnd.dwf"
  or
  ext = ".dwg" and mimeType = "image/vnd.dwg"
  or
  ext = ".dxf" and mimeType = "image/vnd.dxf"
  or
  ext = ".dxp" and mimeType = "application/vnd.spotfire.dxp"
  or
  ext = ".ear" and mimeType = "application/java-archive"
  or
  ext = ".ecelp4800" and mimeType = "audio/vnd.nuera.ecelp4800"
  or
  ext = ".ecelp7470" and mimeType = "audio/vnd.nuera.ecelp7470"
  or
  ext = ".ecelp9600" and mimeType = "audio/vnd.nuera.ecelp9600"
  or
  ext = ".ecma" and mimeType = "application/ecmascript"
  or
  ext = ".edm" and mimeType = "application/vnd.novadigm.edm"
  or
  ext = ".edx" and mimeType = "application/vnd.novadigm.edx"
  or
  ext = ".efif" and mimeType = "application/vnd.picsel"
  or
  ext = ".ei6" and mimeType = "application/vnd.pg.osasli"
  or
  ext = ".eml" and mimeType = "message/rfc822"
  or
  ext = ".eol" and mimeType = "audio/vnd.digital-winds"
  or
  ext = ".eot" and mimeType = "application/vnd.ms-fontobject"
  or
  ext = ".eps" and mimeType = "application/postscript"
  or
  ext = ".es3" and mimeType = "application/vnd.eszigno3+xml"
  or
  ext = ".esf" and mimeType = "application/vnd.epson.esf"
  or
  ext = ".etx" and mimeType = "text/x-setext"
  or
  ext = ".exe" and mimeType = "application/x-msdownload"
  or
  ext = ".ext" and mimeType = "application/vnd.novadigm.ext"
  or
  ext = ".ez" and mimeType = "application/andrew-inset"
  or
  ext = ".ez2" and mimeType = "application/vnd.ezpix-album"
  or
  ext = ".ez3" and mimeType = "application/vnd.ezpix-package"
  or
  ext = ".f" and mimeType = "text/x-fortran"
  or
  ext = ".f77" and mimeType = "text/x-fortran"
  or
  ext = ".f90" and mimeType = "text/x-fortran"
  or
  ext = ".fbs" and mimeType = "image/vnd.fastbidsheet"
  or
  ext = ".fdf" and mimeType = "application/vnd.fdf"
  or
  ext = ".fe_launch" and mimeType = "application/vnd.denovo.fcselayout-link"
  or
  ext = ".fg5" and mimeType = "application/vnd.fujitsu.oasysgp"
  or
  ext = ".fli" and mimeType = "video/x-fli"
  or
  ext = ".flif" and mimeType = "image/flif"
  or
  ext = ".flo" and mimeType = "application/vnd.micrografx.flo"
  or
  ext = ".flv" and mimeType = "video/x-flv"
  or
  ext = ".flw" and mimeType = "application/vnd.kde.kivio"
  or
  ext = ".flx" and mimeType = "text/vnd.fmi.flexstor"
  or
  ext = ".fly" and mimeType = "text/vnd.fly"
  or
  ext = ".fm" and mimeType = "application/vnd.framemaker"
  or
  ext = ".fnc" and mimeType = "application/vnd.frogans.fnc"
  or
  ext = ".for" and mimeType = "text/x-fortran"
  or
  ext = ".fpx" and mimeType = "image/vnd.fpx"
  or
  ext = ".fsc" and mimeType = "application/vnd.fsc.weblaunch"
  or
  ext = ".fst" and mimeType = "image/vnd.fst"
  or
  ext = ".ftc" and mimeType = "application/vnd.fluxtime.clip"
  or
  ext = ".fti" and mimeType = "application/vnd.anser-web-funds-transfer-initiation"
  or
  ext = ".fvt" and mimeType = "video/vnd.fvt"
  or
  ext = ".fzs" and mimeType = "application/vnd.fuzzysheet"
  or
  ext = ".g3" and mimeType = "image/g3fax"
  or
  ext = ".gac" and mimeType = "application/vnd.groove-account"
  or
  ext = ".gdl" and mimeType = "model/vnd.gdl"
  or
  ext = ".gem" and mimeType = "application/octet-stream"
  or
  ext = ".gemspec" and mimeType = "text/x-script.ruby"
  or
  ext = ".ghf" and mimeType = "application/vnd.groove-help"
  or
  ext = ".gif" and mimeType = "image/gif"
  or
  ext = ".gim" and mimeType = "application/vnd.groove-identity-message"
  or
  ext = ".gmx" and mimeType = "application/vnd.gmx"
  or
  ext = ".gph" and mimeType = "application/vnd.flographit"
  or
  ext = ".gqf" and mimeType = "application/vnd.grafeq"
  or
  ext = ".gram" and mimeType = "application/srgs"
  or
  ext = ".grv" and mimeType = "application/vnd.groove-injector"
  or
  ext = ".grxml" and mimeType = "application/srgs+xml"
  or
  ext = ".gtar" and mimeType = "application/x-gtar"
  or
  ext = ".gtm" and mimeType = "application/vnd.groove-tool-message"
  or
  ext = ".gtw" and mimeType = "model/vnd.gtw"
  or
  ext = ".gv" and mimeType = "text/vnd.graphviz"
  or
  ext = ".gz" and mimeType = "application/x-gzip"
  or
  ext = ".h" and mimeType = "text/x-c"
  or
  ext = ".h261" and mimeType = "video/h261"
  or
  ext = ".h263" and mimeType = "video/h263"
  or
  ext = ".h264" and mimeType = "video/h264"
  or
  ext = ".hbci" and mimeType = "application/vnd.hbci"
  or
  ext = ".hdf" and mimeType = "application/x-hdf"
  or
  ext = ".heic" and mimeType = "image/heic"
  or
  ext = ".heics" and mimeType = "image/heic-sequence"
  or
  ext = ".heif" and mimeType = "image/heif"
  or
  ext = ".heifs" and mimeType = "image/heif-sequence"
  or
  ext = ".hh" and mimeType = "text/x-c"
  or
  ext = ".hlp" and mimeType = "application/winhlp"
  or
  ext = ".hpgl" and mimeType = "application/vnd.hp-hpgl"
  or
  ext = ".hpid" and mimeType = "application/vnd.hp-hpid"
  or
  ext = ".hps" and mimeType = "application/vnd.hp-hps"
  or
  ext = ".hqx" and mimeType = "application/mac-binhex40"
  or
  ext = ".htc" and mimeType = "text/x-component"
  or
  ext = ".htke" and mimeType = "application/vnd.kenameaapp"
  or
  ext = ".htm" and mimeType = "text/html"
  or
  ext = ".html" and mimeType = "text/html"
  or
  ext = ".hvd" and mimeType = "application/vnd.yamaha.hv-dic"
  or
  ext = ".hvp" and mimeType = "application/vnd.yamaha.hv-voice"
  or
  ext = ".hvs" and mimeType = "application/vnd.yamaha.hv-script"
  or
  ext = ".icc" and mimeType = "application/vnd.iccprofile"
  or
  ext = ".ice" and mimeType = "x-conference/x-cooltalk"
  or
  ext = ".ico" and mimeType = "image/vnd.microsoft.icon"
  or
  ext = ".ics" and mimeType = "text/calendar"
  or
  ext = ".ief" and mimeType = "image/ief"
  or
  ext = ".ifb" and mimeType = "text/calendar"
  or
  ext = ".ifm" and mimeType = "application/vnd.shana.informed.formdata"
  or
  ext = ".igl" and mimeType = "application/vnd.igloader"
  or
  ext = ".igs" and mimeType = "model/iges"
  or
  ext = ".igx" and mimeType = "application/vnd.micrografx.igx"
  or
  ext = ".iif" and mimeType = "application/vnd.shana.informed.interchange"
  or
  ext = ".imp" and mimeType = "application/vnd.accpac.simply.imp"
  or
  ext = ".ims" and mimeType = "application/vnd.ms-ims"
  or
  ext = ".ipk" and mimeType = "application/vnd.shana.informed.package"
  or
  ext = ".irm" and mimeType = "application/vnd.ibm.rights-management"
  or
  ext = ".irp" and mimeType = "application/vnd.irepository.package+xml"
  or
  ext = ".iso" and mimeType = "application/octet-stream"
  or
  ext = ".itp" and mimeType = "application/vnd.shana.informed.formtemplate"
  or
  ext = ".ivp" and mimeType = "application/vnd.immervision-ivp"
  or
  ext = ".ivu" and mimeType = "application/vnd.immervision-ivu"
  or
  ext = ".jad" and mimeType = "text/vnd.sun.j2me.app-descriptor"
  or
  ext = ".jam" and mimeType = "application/vnd.jam"
  or
  ext = ".jar" and mimeType = "application/java-archive"
  or
  ext = ".java" and mimeType = "text/x-java-source"
  or
  ext = ".jisp" and mimeType = "application/vnd.jisp"
  or
  ext = ".jlt" and mimeType = "application/vnd.hp-jlyt"
  or
  ext = ".jnlp" and mimeType = "application/x-java-jnlp-file"
  or
  ext = ".joda" and mimeType = "application/vnd.joost.joda-archive"
  or
  ext = ".jp2" and mimeType = "image/jp2"
  or
  ext = ".jpeg" and mimeType = "image/jpeg"
  or
  ext = ".jpg" and mimeType = "image/jpeg"
  or
  ext = ".jpgv" and mimeType = "video/jpeg"
  or
  ext = ".jpm" and mimeType = "video/jpm"
  or
  ext = ".js" and mimeType = "application/javascript"
  or
  ext = ".json" and mimeType = "application/json"
  or
  ext = ".karbon" and mimeType = "application/vnd.kde.karbon"
  or
  ext = ".kfo" and mimeType = "application/vnd.kde.kformula"
  or
  ext = ".kia" and mimeType = "application/vnd.kidspiration"
  or
  ext = ".kml" and mimeType = "application/vnd.google-earth.kml+xml"
  or
  ext = ".kmz" and mimeType = "application/vnd.google-earth.kmz"
  or
  ext = ".kne" and mimeType = "application/vnd.kinar"
  or
  ext = ".kon" and mimeType = "application/vnd.kde.kontour"
  or
  ext = ".kpr" and mimeType = "application/vnd.kde.kpresenter"
  or
  ext = ".ksp" and mimeType = "application/vnd.kde.kspread"
  or
  ext = ".ktz" and mimeType = "application/vnd.kahootz"
  or
  ext = ".kwd" and mimeType = "application/vnd.kde.kword"
  or
  ext = ".latex" and mimeType = "application/x-latex"
  or
  ext = ".lbd" and mimeType = "application/vnd.llamagraphics.life-balance.desktop"
  or
  ext = ".lbe" and mimeType = "application/vnd.llamagraphics.life-balance.exchange+xml"
  or
  ext = ".les" and mimeType = "application/vnd.hhe.lesson-player"
  or
  ext = ".link66" and mimeType = "application/vnd.route66.link66+xml"
  or
  ext = ".log" and mimeType = "text/plain"
  or
  ext = ".lostxml" and mimeType = "application/lost+xml"
  or
  ext = ".lrm" and mimeType = "application/vnd.ms-lrm"
  or
  ext = ".ltf" and mimeType = "application/vnd.frogans.ltf"
  or
  ext = ".lvp" and mimeType = "audio/vnd.lucent.voice"
  or
  ext = ".lwp" and mimeType = "application/vnd.lotus-wordpro"
  or
  ext = ".m3u" and mimeType = "audio/x-mpegurl"
  or
  ext = ".m3u8" and mimeType = "application/x-mpegurl"
  or
  ext = ".m4a" and mimeType = "audio/mp4a-latm"
  or
  ext = ".m4v" and mimeType = "video/mp4"
  or
  ext = ".ma" and mimeType = "application/mathematica"
  or
  ext = ".mag" and mimeType = "application/vnd.ecowin.chart"
  or
  ext = ".man" and mimeType = "text/troff"
  or
  ext = ".manifest" and mimeType = "text/cache-manifest"
  or
  ext = ".mathml" and mimeType = "application/mathml+xml"
  or
  ext = ".mbk" and mimeType = "application/vnd.mobius.mbk"
  or
  ext = ".mbox" and mimeType = "application/mbox"
  or
  ext = ".mc1" and mimeType = "application/vnd.medcalcdata"
  or
  ext = ".mcd" and mimeType = "application/vnd.mcd"
  or
  ext = ".mdb" and mimeType = "application/x-msaccess"
  or
  ext = ".mdi" and mimeType = "image/vnd.ms-modi"
  or
  ext = ".mdoc" and mimeType = "text/troff"
  or
  ext = ".me" and mimeType = "text/troff"
  or
  ext = ".mfm" and mimeType = "application/vnd.mfmp"
  or
  ext = ".mgz" and mimeType = "application/vnd.proteus.magazine"
  or
  ext = ".mid" and mimeType = "audio/midi"
  or
  ext = ".midi" and mimeType = "audio/midi"
  or
  ext = ".mif" and mimeType = "application/vnd.mif"
  or
  ext = ".mime" and mimeType = "message/rfc822"
  or
  ext = ".mj2" and mimeType = "video/mj2"
  or
  ext = ".mlp" and mimeType = "application/vnd.dolby.mlp"
  or
  ext = ".mmd" and mimeType = "application/vnd.chipnuts.karaoke-mmd"
  or
  ext = ".mmf" and mimeType = "application/vnd.smaf"
  or
  ext = ".mml" and mimeType = "application/mathml+xml"
  or
  ext = ".mmr" and mimeType = "image/vnd.fujixerox.edmics-mmr"
  or
  ext = ".mng" and mimeType = "video/x-mng"
  or
  ext = ".mny" and mimeType = "application/x-msmoney"
  or
  ext = ".mov" and mimeType = "video/quicktime"
  or
  ext = ".movie" and mimeType = "video/x-sgi-movie"
  or
  ext = ".mp3" and mimeType = "audio/mpeg"
  or
  ext = ".mp4" and mimeType = "video/mp4"
  or
  ext = ".mp4a" and mimeType = "audio/mp4"
  or
  ext = ".mp4s" and mimeType = "application/mp4"
  or
  ext = ".mp4v" and mimeType = "video/mp4"
  or
  ext = ".mpc" and mimeType = "application/vnd.mophun.certificate"
  or
  ext = ".mpd" and mimeType = "application/dash+xml"
  or
  ext = ".mpeg" and mimeType = "video/mpeg"
  or
  ext = ".mpg" and mimeType = "video/mpeg"
  or
  ext = ".mpga" and mimeType = "audio/mpeg"
  or
  ext = ".mpkg" and mimeType = "application/vnd.apple.installer+xml"
  or
  ext = ".mpm" and mimeType = "application/vnd.blueice.multipass"
  or
  ext = ".mpn" and mimeType = "application/vnd.mophun.application"
  or
  ext = ".mpp" and mimeType = "application/vnd.ms-project"
  or
  ext = ".mpy" and mimeType = "application/vnd.ibm.minipay"
  or
  ext = ".mqy" and mimeType = "application/vnd.mobius.mqy"
  or
  ext = ".mrc" and mimeType = "application/marc"
  or
  ext = ".ms" and mimeType = "text/troff"
  or
  ext = ".mscml" and mimeType = "application/mediaservercontrol+xml"
  or
  ext = ".mseq" and mimeType = "application/vnd.mseq"
  or
  ext = ".msf" and mimeType = "application/vnd.epson.msf"
  or
  ext = ".msh" and mimeType = "model/mesh"
  or
  ext = ".msi" and mimeType = "application/x-msdownload"
  or
  ext = ".msl" and mimeType = "application/vnd.mobius.msl"
  or
  ext = ".msty" and mimeType = "application/vnd.muvee.style"
  or
  ext = ".mts" and mimeType = "model/vnd.mts"
  or
  ext = ".mus" and mimeType = "application/vnd.musician"
  or
  ext = ".mvb" and mimeType = "application/x-msmediaview"
  or
  ext = ".mwf" and mimeType = "application/vnd.mfer"
  or
  ext = ".mxf" and mimeType = "application/mxf"
  or
  ext = ".mxl" and mimeType = "application/vnd.recordare.musicxml"
  or
  ext = ".mxml" and mimeType = "application/xv+xml"
  or
  ext = ".mxs" and mimeType = "application/vnd.triscape.mxs"
  or
  ext = ".mxu" and mimeType = "video/vnd.mpegurl"
  or
  ext = ".n" and mimeType = "application/vnd.nokia.n-gage.symbian.install"
  or
  ext = ".nc" and mimeType = "application/x-netcdf"
  or
  ext = ".ngdat" and mimeType = "application/vnd.nokia.n-gage.data"
  or
  ext = ".nlu" and mimeType = "application/vnd.neurolanguage.nlu"
  or
  ext = ".nml" and mimeType = "application/vnd.enliven"
  or
  ext = ".nnd" and mimeType = "application/vnd.noblenet-directory"
  or
  ext = ".nns" and mimeType = "application/vnd.noblenet-sealer"
  or
  ext = ".nnw" and mimeType = "application/vnd.noblenet-web"
  or
  ext = ".npx" and mimeType = "image/vnd.net-fpx"
  or
  ext = ".nsf" and mimeType = "application/vnd.lotus-notes"
  or
  ext = ".oa2" and mimeType = "application/vnd.fujitsu.oasys2"
  or
  ext = ".oa3" and mimeType = "application/vnd.fujitsu.oasys3"
  or
  ext = ".oas" and mimeType = "application/vnd.fujitsu.oasys"
  or
  ext = ".obd" and mimeType = "application/x-msbinder"
  or
  ext = ".oda" and mimeType = "application/oda"
  or
  ext = ".odc" and mimeType = "application/vnd.oasis.opendocument.chart"
  or
  ext = ".odf" and mimeType = "application/vnd.oasis.opendocument.formula"
  or
  ext = ".odg" and mimeType = "application/vnd.oasis.opendocument.graphics"
  or
  ext = ".odi" and mimeType = "application/vnd.oasis.opendocument.image"
  or
  ext = ".odp" and mimeType = "application/vnd.oasis.opendocument.presentation"
  or
  ext = ".ods" and mimeType = "application/vnd.oasis.opendocument.spreadsheet"
  or
  ext = ".odt" and mimeType = "application/vnd.oasis.opendocument.text"
  or
  ext = ".oga" and mimeType = "audio/ogg"
  or
  ext = ".ogg" and mimeType = "application/ogg"
  or
  ext = ".ogv" and mimeType = "video/ogg"
  or
  ext = ".ogx" and mimeType = "application/ogg"
  or
  ext = ".org" and mimeType = "application/vnd.lotus-organizer"
  or
  ext = ".otc" and mimeType = "application/vnd.oasis.opendocument.chart-template"
  or
  ext = ".otf" and mimeType = "application/vnd.oasis.opendocument.formula-template"
  or
  ext = ".otg" and mimeType = "application/vnd.oasis.opendocument.graphics-template"
  or
  ext = ".oth" and mimeType = "application/vnd.oasis.opendocument.text-web"
  or
  ext = ".oti" and mimeType = "application/vnd.oasis.opendocument.image-template"
  or
  ext = ".otm" and mimeType = "application/vnd.oasis.opendocument.text-master"
  or
  ext = ".ots" and mimeType = "application/vnd.oasis.opendocument.spreadsheet-template"
  or
  ext = ".ott" and mimeType = "application/vnd.oasis.opendocument.text-template"
  or
  ext = ".oxt" and mimeType = "application/vnd.openofficeorg.extension"
  or
  ext = ".p" and mimeType = "text/x-pascal"
  or
  ext = ".p10" and mimeType = "application/pkcs10"
  or
  ext = ".p12" and mimeType = "application/x-pkcs12"
  or
  ext = ".p7b" and mimeType = "application/x-pkcs7-certificates"
  or
  ext = ".p7m" and mimeType = "application/pkcs7-mime"
  or
  ext = ".p7r" and mimeType = "application/x-pkcs7-certreqresp"
  or
  ext = ".p7s" and mimeType = "application/pkcs7-signature"
  or
  ext = ".pas" and mimeType = "text/x-pascal"
  or
  ext = ".pbd" and mimeType = "application/vnd.powerbuilder6"
  or
  ext = ".pbm" and mimeType = "image/x-portable-bitmap"
  or
  ext = ".pcl" and mimeType = "application/vnd.hp-pcl"
  or
  ext = ".pclxl" and mimeType = "application/vnd.hp-pclxl"
  or
  ext = ".pcx" and mimeType = "image/x-pcx"
  or
  ext = ".pdb" and mimeType = "chemical/x-pdb"
  or
  ext = ".pdf" and mimeType = "application/pdf"
  or
  ext = ".pem" and mimeType = "application/x-x509-ca-cert"
  or
  ext = ".pfr" and mimeType = "application/font-tdpfr"
  or
  ext = ".pgm" and mimeType = "image/x-portable-graymap"
  or
  ext = ".pgn" and mimeType = "application/x-chess-pgn"
  or
  ext = ".pgp" and mimeType = "application/pgp-encrypted"
  or
  ext = ".pic" and mimeType = "image/x-pict"
  or
  ext = ".pict" and mimeType = "image/pict"
  or
  ext = ".pkg" and mimeType = "application/octet-stream"
  or
  ext = ".pki" and mimeType = "application/pkixcmp"
  or
  ext = ".pkipath" and mimeType = "application/pkix-pkipath"
  or
  ext = ".pl" and mimeType = "text/x-script.perl"
  or
  ext = ".plb" and mimeType = "application/vnd.3gpp.pic-bw-large"
  or
  ext = ".plc" and mimeType = "application/vnd.mobius.plc"
  or
  ext = ".plf" and mimeType = "application/vnd.pocketlearn"
  or
  ext = ".pls" and mimeType = "application/pls+xml"
  or
  ext = ".pm" and mimeType = "text/x-script.perl-module"
  or
  ext = ".pml" and mimeType = "application/vnd.ctc-posml"
  or
  ext = ".png" and mimeType = "image/png"
  or
  ext = ".pnm" and mimeType = "image/x-portable-anymap"
  or
  ext = ".pntg" and mimeType = "image/x-macpaint"
  or
  ext = ".portpkg" and mimeType = "application/vnd.macports.portpkg"
  or
  ext = ".pot" and mimeType = "application/vnd.ms-powerpoint"
  or
  ext = ".potm" and mimeType = "application/vnd.ms-powerpoint.template.macroEnabled.12"
  or
  ext = ".potx" and
  mimeType = "application/vnd.openxmlformats-officedocument.presentationml.template"
  or
  ext = ".ppa" and mimeType = "application/vnd.ms-powerpoint"
  or
  ext = ".ppam" and mimeType = "application/vnd.ms-powerpoint.addin.macroEnabled.12"
  or
  ext = ".ppd" and mimeType = "application/vnd.cups-ppd"
  or
  ext = ".ppm" and mimeType = "image/x-portable-pixmap"
  or
  ext = ".pps" and mimeType = "application/vnd.ms-powerpoint"
  or
  ext = ".ppsm" and mimeType = "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
  or
  ext = ".ppsx" and
  mimeType = "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
  or
  ext = ".ppt" and mimeType = "application/vnd.ms-powerpoint"
  or
  ext = ".pptm" and mimeType = "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
  or
  ext = ".pptx" and
  mimeType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  or
  ext = ".prc" and mimeType = "application/vnd.palm"
  or
  ext = ".pre" and mimeType = "application/vnd.lotus-freelance"
  or
  ext = ".prf" and mimeType = "application/pics-rules"
  or
  ext = ".ps" and mimeType = "application/postscript"
  or
  ext = ".psb" and mimeType = "application/vnd.3gpp.pic-bw-small"
  or
  ext = ".psd" and mimeType = "image/vnd.adobe.photoshop"
  or
  ext = ".ptid" and mimeType = "application/vnd.pvi.ptid1"
  or
  ext = ".pub" and mimeType = "application/x-mspublisher"
  or
  ext = ".pvb" and mimeType = "application/vnd.3gpp.pic-bw-var"
  or
  ext = ".pwn" and mimeType = "application/vnd.3m.post-it-notes"
  or
  ext = ".py" and mimeType = "text/x-script.python"
  or
  ext = ".pya" and mimeType = "audio/vnd.ms-playready.media.pya"
  or
  ext = ".pyv" and mimeType = "video/vnd.ms-playready.media.pyv"
  or
  ext = ".qam" and mimeType = "application/vnd.epson.quickanime"
  or
  ext = ".qbo" and mimeType = "application/vnd.intu.qbo"
  or
  ext = ".qfx" and mimeType = "application/vnd.intu.qfx"
  or
  ext = ".qps" and mimeType = "application/vnd.publishare-delta-tree"
  or
  ext = ".qt" and mimeType = "video/quicktime"
  or
  ext = ".qtif" and mimeType = "image/x-quicktime"
  or
  ext = ".qxd" and mimeType = "application/vnd.quark.quarkxpress"
  or
  ext = ".ra" and mimeType = "audio/x-pn-realaudio"
  or
  ext = ".rake" and mimeType = "text/x-script.ruby"
  or
  ext = ".ram" and mimeType = "audio/x-pn-realaudio"
  or
  ext = ".rar" and mimeType = "application/x-rar-compressed"
  or
  ext = ".ras" and mimeType = "image/x-cmu-raster"
  or
  ext = ".rb" and mimeType = "text/x-script.ruby"
  or
  ext = ".rcprofile" and mimeType = "application/vnd.ipunplugged.rcprofile"
  or
  ext = ".rdf" and mimeType = "application/rdf+xml"
  or
  ext = ".rdz" and mimeType = "application/vnd.data-vision.rdz"
  or
  ext = ".rep" and mimeType = "application/vnd.businessobjects"
  or
  ext = ".rgb" and mimeType = "image/x-rgb"
  or
  ext = ".rif" and mimeType = "application/reginfo+xml"
  or
  ext = ".rl" and mimeType = "application/resource-lists+xml"
  or
  ext = ".rlc" and mimeType = "image/vnd.fujixerox.edmics-rlc"
  or
  ext = ".rld" and mimeType = "application/resource-lists-diff+xml"
  or
  ext = ".rm" and mimeType = "application/vnd.rn-realmedia"
  or
  ext = ".rmp" and mimeType = "audio/x-pn-realaudio-plugin"
  or
  ext = ".rms" and mimeType = "application/vnd.jcp.javame.midlet-rms"
  or
  ext = ".rnc" and mimeType = "application/relax-ng-compact-syntax"
  or
  ext = ".roff" and mimeType = "text/troff"
  or
  ext = ".rpm" and mimeType = "application/x-redhat-package-manager"
  or
  ext = ".rpss" and mimeType = "application/vnd.nokia.radio-presets"
  or
  ext = ".rpst" and mimeType = "application/vnd.nokia.radio-preset"
  or
  ext = ".rq" and mimeType = "application/sparql-query"
  or
  ext = ".rs" and mimeType = "application/rls-services+xml"
  or
  ext = ".rsd" and mimeType = "application/rsd+xml"
  or
  ext = ".rss" and mimeType = "application/rss+xml"
  or
  ext = ".rtf" and mimeType = "application/rtf"
  or
  ext = ".rtx" and mimeType = "text/richtext"
  or
  ext = ".ru" and mimeType = "text/x-script.ruby"
  or
  ext = ".s" and mimeType = "text/x-asm"
  or
  ext = ".saf" and mimeType = "application/vnd.yamaha.smaf-audio"
  or
  ext = ".sbml" and mimeType = "application/sbml+xml"
  or
  ext = ".sc" and mimeType = "application/vnd.ibm.secure-container"
  or
  ext = ".scd" and mimeType = "application/x-msschedule"
  or
  ext = ".scm" and mimeType = "application/vnd.lotus-screencam"
  or
  ext = ".scq" and mimeType = "application/scvp-cv-request"
  or
  ext = ".scs" and mimeType = "application/scvp-cv-response"
  or
  ext = ".sdkm" and mimeType = "application/vnd.solent.sdkm+xml"
  or
  ext = ".sdp" and mimeType = "application/sdp"
  or
  ext = ".see" and mimeType = "application/vnd.seemail"
  or
  ext = ".sema" and mimeType = "application/vnd.sema"
  or
  ext = ".semd" and mimeType = "application/vnd.semd"
  or
  ext = ".semf" and mimeType = "application/vnd.semf"
  or
  ext = ".setpay" and mimeType = "application/set-payment-initiation"
  or
  ext = ".setreg" and mimeType = "application/set-registration-initiation"
  or
  ext = ".sfd" and mimeType = "application/vnd.hydrostatix.sof-data"
  or
  ext = ".sfs" and mimeType = "application/vnd.spotfire.sfs"
  or
  ext = ".sgm" and mimeType = "text/sgml"
  or
  ext = ".sgml" and mimeType = "text/sgml"
  or
  ext = ".sh" and mimeType = "application/x-sh"
  or
  ext = ".shar" and mimeType = "application/x-shar"
  or
  ext = ".shf" and mimeType = "application/shf+xml"
  or
  ext = ".sig" and mimeType = "application/pgp-signature"
  or
  ext = ".sit" and mimeType = "application/x-stuffit"
  or
  ext = ".sitx" and mimeType = "application/x-stuffitx"
  or
  ext = ".skp" and mimeType = "application/vnd.koan"
  or
  ext = ".slt" and mimeType = "application/vnd.epson.salt"
  or
  ext = ".smi" and mimeType = "application/smil+xml"
  or
  ext = ".snd" and mimeType = "audio/basic"
  or
  ext = ".so" and mimeType = "application/octet-stream"
  or
  ext = ".spf" and mimeType = "application/vnd.yamaha.smaf-phrase"
  or
  ext = ".spl" and mimeType = "application/x-futuresplash"
  or
  ext = ".spot" and mimeType = "text/vnd.in3d.spot"
  or
  ext = ".spp" and mimeType = "application/scvp-vp-response"
  or
  ext = ".spq" and mimeType = "application/scvp-vp-request"
  or
  ext = ".src" and mimeType = "application/x-wais-source"
  or
  ext = ".srt" and mimeType = "text/srt"
  or
  ext = ".srx" and mimeType = "application/sparql-results+xml"
  or
  ext = ".sse" and mimeType = "application/vnd.kodak-descriptor"
  or
  ext = ".ssf" and mimeType = "application/vnd.epson.ssf"
  or
  ext = ".ssml" and mimeType = "application/ssml+xml"
  or
  ext = ".stf" and mimeType = "application/vnd.wt.stf"
  or
  ext = ".stk" and mimeType = "application/hyperstudio"
  or
  ext = ".str" and mimeType = "application/vnd.pg.format"
  or
  ext = ".sus" and mimeType = "application/vnd.sus-calendar"
  or
  ext = ".sv4cpio" and mimeType = "application/x-sv4cpio"
  or
  ext = ".sv4crc" and mimeType = "application/x-sv4crc"
  or
  ext = ".svd" and mimeType = "application/vnd.svd"
  or
  ext = ".svg" and mimeType = "image/svg+xml"
  or
  ext = ".svgz" and mimeType = "image/svg+xml"
  or
  ext = ".swf" and mimeType = "application/x-shockwave-flash"
  or
  ext = ".swi" and mimeType = "application/vnd.arastra.swi"
  or
  ext = ".t" and mimeType = "text/troff"
  or
  ext = ".tao" and mimeType = "application/vnd.tao.intent-module-archive"
  or
  ext = ".tar" and mimeType = "application/x-tar"
  or
  ext = ".tbz" and mimeType = "application/x-bzip-compressed-tar"
  or
  ext = ".tcap" and mimeType = "application/vnd.3gpp2.tcap"
  or
  ext = ".tcl" and mimeType = "application/x-tcl"
  or
  ext = ".tex" and mimeType = "application/x-tex"
  or
  ext = ".texi" and mimeType = "application/x-texinfo"
  or
  ext = ".texinfo" and mimeType = "application/x-texinfo"
  or
  ext = ".text" and mimeType = "text/plain"
  or
  ext = ".tif" and mimeType = "image/tiff"
  or
  ext = ".tiff" and mimeType = "image/tiff"
  or
  ext = ".tmo" and mimeType = "application/vnd.tmobile-livetv"
  or
  ext = ".torrent" and mimeType = "application/x-bittorrent"
  or
  ext = ".tpl" and mimeType = "application/vnd.groove-tool-template"
  or
  ext = ".tpt" and mimeType = "application/vnd.trid.tpt"
  or
  ext = ".tr" and mimeType = "text/troff"
  or
  ext = ".tra" and mimeType = "application/vnd.trueapp"
  or
  ext = ".trm" and mimeType = "application/x-msterminal"
  or
  ext = ".ts" and mimeType = "video/mp2t"
  or
  ext = ".tsv" and mimeType = "text/tab-separated-values"
  or
  ext = ".ttf" and mimeType = "application/octet-stream"
  or
  ext = ".twd" and mimeType = "application/vnd.simtech-mindmapper"
  or
  ext = ".txd" and mimeType = "application/vnd.genomatix.tuxedo"
  or
  ext = ".txf" and mimeType = "application/vnd.mobius.txf"
  or
  ext = ".txt" and mimeType = "text/plain"
  or
  ext = ".ufd" and mimeType = "application/vnd.ufdl"
  or
  ext = ".umj" and mimeType = "application/vnd.umajin"
  or
  ext = ".unityweb" and mimeType = "application/vnd.unity"
  or
  ext = ".uoml" and mimeType = "application/vnd.uoml+xml"
  or
  ext = ".uri" and mimeType = "text/uri-list"
  or
  ext = ".ustar" and mimeType = "application/x-ustar"
  or
  ext = ".utz" and mimeType = "application/vnd.uiq.theme"
  or
  ext = ".uu" and mimeType = "text/x-uuencode"
  or
  ext = ".vcd" and mimeType = "application/x-cdlink"
  or
  ext = ".vcf" and mimeType = "text/x-vcard"
  or
  ext = ".vcg" and mimeType = "application/vnd.groove-vcard"
  or
  ext = ".vcs" and mimeType = "text/x-vcalendar"
  or
  ext = ".vcx" and mimeType = "application/vnd.vcx"
  or
  ext = ".vis" and mimeType = "application/vnd.visionary"
  or
  ext = ".viv" and mimeType = "video/vnd.vivo"
  or
  ext = ".vrml" and mimeType = "model/vrml"
  or
  ext = ".vsd" and mimeType = "application/vnd.visio"
  or
  ext = ".vsf" and mimeType = "application/vnd.vsf"
  or
  ext = ".vtt" and mimeType = "text/vtt"
  or
  ext = ".vtu" and mimeType = "model/vnd.vtu"
  or
  ext = ".vxml" and mimeType = "application/voicexml+xml"
  or
  ext = ".war" and mimeType = "application/java-archive"
  or
  ext = ".wasm" and mimeType = "application/wasm"
  or
  ext = ".wav" and mimeType = "audio/x-wav"
  or
  ext = ".wax" and mimeType = "audio/x-ms-wax"
  or
  ext = ".wbmp" and mimeType = "image/vnd.wap.wbmp"
  or
  ext = ".wbs" and mimeType = "application/vnd.criticaltools.wbs+xml"
  or
  ext = ".wbxml" and mimeType = "application/vnd.wap.wbxml"
  or
  ext = ".webm" and mimeType = "video/webm"
  or
  ext = ".webp" and mimeType = "image/webp"
  or
  ext = ".wm" and mimeType = "video/x-ms-wm"
  or
  ext = ".wma" and mimeType = "audio/x-ms-wma"
  or
  ext = ".wmd" and mimeType = "application/x-ms-wmd"
  or
  ext = ".wmf" and mimeType = "application/x-msmetafile"
  or
  ext = ".wml" and mimeType = "text/vnd.wap.wml"
  or
  ext = ".wmlc" and mimeType = "application/vnd.wap.wmlc"
  or
  ext = ".wmls" and mimeType = "text/vnd.wap.wmlscript"
  or
  ext = ".wmlsc" and mimeType = "application/vnd.wap.wmlscriptc"
  or
  ext = ".wmv" and mimeType = "video/x-ms-wmv"
  or
  ext = ".wmx" and mimeType = "video/x-ms-wmx"
  or
  ext = ".wmz" and mimeType = "application/x-ms-wmz"
  or
  ext = ".woff" and mimeType = "application/font-woff"
  or
  ext = ".woff2" and mimeType = "application/font-woff2"
  or
  ext = ".wpd" and mimeType = "application/vnd.wordperfect"
  or
  ext = ".wpl" and mimeType = "application/vnd.ms-wpl"
  or
  ext = ".wps" and mimeType = "application/vnd.ms-works"
  or
  ext = ".wqd" and mimeType = "application/vnd.wqd"
  or
  ext = ".wri" and mimeType = "application/x-mswrite"
  or
  ext = ".wrl" and mimeType = "model/vrml"
  or
  ext = ".wsdl" and mimeType = "application/wsdl+xml"
  or
  ext = ".wspolicy" and mimeType = "application/wspolicy+xml"
  or
  ext = ".wtb" and mimeType = "application/vnd.webturbo"
  or
  ext = ".wvx" and mimeType = "video/x-ms-wvx"
  or
  ext = ".x3d" and mimeType = "application/vnd.hzn-3d-crossword"
  or
  ext = ".xar" and mimeType = "application/vnd.xara"
  or
  ext = ".xbd" and mimeType = "application/vnd.fujixerox.docuworks.binder"
  or
  ext = ".xbm" and mimeType = "image/x-xbitmap"
  or
  ext = ".xdm" and mimeType = "application/vnd.syncml.dm+xml"
  or
  ext = ".xdp" and mimeType = "application/vnd.adobe.xdp+xml"
  or
  ext = ".xdw" and mimeType = "application/vnd.fujixerox.docuworks"
  or
  ext = ".xenc" and mimeType = "application/xenc+xml"
  or
  ext = ".xer" and mimeType = "application/patch-ops-error+xml"
  or
  ext = ".xfdf" and mimeType = "application/vnd.adobe.xfdf"
  or
  ext = ".xfdl" and mimeType = "application/vnd.xfdl"
  or
  ext = ".xhtml" and mimeType = "application/xhtml+xml"
  or
  ext = ".xif" and mimeType = "image/vnd.xiff"
  or
  ext = ".xla" and mimeType = "application/vnd.ms-excel"
  or
  ext = ".xlam" and mimeType = "application/vnd.ms-excel.addin.macroEnabled.12"
  or
  ext = ".xls" and mimeType = "application/vnd.ms-excel"
  or
  ext = ".xlsb" and mimeType = "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
  or
  ext = ".xlsx" and mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  or
  ext = ".xlsm" and mimeType = "application/vnd.ms-excel.sheet.macroEnabled.12"
  or
  ext = ".xlt" and mimeType = "application/vnd.ms-excel"
  or
  ext = ".xltx" and
  mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
  or
  ext = ".xml" and mimeType = "application/xml"
  or
  ext = ".xo" and mimeType = "application/vnd.olpc-sugar"
  or
  ext = ".xop" and mimeType = "application/xop+xml"
  or
  ext = ".xpm" and mimeType = "image/x-xpixmap"
  or
  ext = ".xpr" and mimeType = "application/vnd.is-xpr"
  or
  ext = ".xps" and mimeType = "application/vnd.ms-xpsdocument"
  or
  ext = ".xpw" and mimeType = "application/vnd.intercon.formnet"
  or
  ext = ".xsl" and mimeType = "application/xml"
  or
  ext = ".xslt" and mimeType = "application/xslt+xml"
  or
  ext = ".xsm" and mimeType = "application/vnd.syncml+xml"
  or
  ext = ".xspf" and mimeType = "application/xspf+xml"
  or
  ext = ".xul" and mimeType = "application/vnd.mozilla.xul+xml"
  or
  ext = ".xwd" and mimeType = "image/x-xwindowdump"
  or
  ext = ".xyz" and mimeType = "chemical/x-xyz"
  or
  ext = ".yaml" and mimeType = "text/yaml"
  or
  ext = ".yml" and mimeType = "text/yaml"
  or
  ext = ".zaz" and mimeType = "application/vnd.zzazz.deck+xml"
  or
  ext = ".zip" and mimeType = "application/zip"
  or
  ext = ".zmm" and mimeType = "application/vnd.handheld-entertainment+xml"
}

/**
 * Provides modeling for the `Mime` component of the `Rack` library.
 */
module Mime {
  /** A call to `Rack::Mime.mime_type`. This method maps file extensions to MIME types. */
  class MimetypeCall extends DataFlow::CallNode {
    MimetypeCall() {
      this = API::getTopLevelMember("Rack").getMember("Mime").getAMethodCall("mime_type")
    }

    private string getExtension() {
      result = this.getArgument(0).getConstantValue().getStringlikeValue()
    }

    /** Gets the canonical MIME type string returned by this call. */
    string getMimeType() { mimeTypeMatches(this.getExtension(), result) }
  }
}
