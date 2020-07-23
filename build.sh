#! /bin/sh
# Generated from niminst
# Template is in tools/niminst/buildsh.nimf
# To regenerate run ``niminst csource`` or ``koch csource``

set -e

while :
do
  case "$1" in
    --os)
      optos=$2
      shift 2
      ;;
    --cpu)
      optcpu=$2
      shift 2
      ;;
    --osname)
      optosname=$2
      shift 2
      ;;
    --extraBuildArgs)
      extraBuildArgs=" $2"
      shift 2
      ;;
    --) # End of all options
      shift
      break;
      ;;
    -*)
      echo 2>&1 "Error: Unknown option: $1" >&2
      exit 1
      ;;
    *)  # No more options
      break
      ;;
  esac
done

CC="${CC:-gcc}"
COMP_FLAGS="${CPPFLAGS:-} ${CFLAGS:-} -w -O3 -fno-strict-aliasing$extraBuildArgs"
LINK_FLAGS="${LDFLAGS:-} "
PS4=""
# platform detection
ucpu=`uname -m`
uos=`uname`
uosname=
# bin dir detection
binDir=bin

if [ -s ../koch.nim ]; then
  binDir="../bin"
fi

if [ ! -d $binDir ]; then
  mkdir $binDir
fi

# override OS, CPU and OS Name with command-line arguments
if [ -n "$optos" ]; then
  uos="$optos"
fi
if [ -n "$optcpu" ]; then
  ucpu="$optcpu"
fi
if [ -n "$optcpu" ]; then
  uosname="$optosname"
fi

# convert to lower case:
ucpu=`echo $ucpu | tr "[:upper:]" "[:lower:]"`
uos=`echo $uos | tr "[:upper:]" "[:lower:]"`
uosname=`echo $uosname | tr "[:upper:]" "[:lower:]"`

case $uos in
  *linux* )
    myos="linux"
    LINK_FLAGS="$LINK_FLAGS -ldl -lm -lrt"
    ;;
  *dragonfly* )
    myos="dragonfly"
    LINK_FLAGS="$LINK_FLAGS -lm"
    ;;
  *freebsd* )
    myos="freebsd"
    CC="clang"
    LINK_FLAGS="$LINK_FLAGS -lm"
    ;;
  *openbsd* )
    myos="openbsd"
    LINK_FLAGS="$LINK_FLAGS -lm"
    ;;
  *netbsd* )
    myos="netbsd"
    LINK_FLAGS="$LINK_FLAGS -lm"
    ;;
  *darwin* )
    myos="macosx"
    CC="clang"
    LINK_FLAGS="$LINK_FLAGS -ldl -lm"
    if [ "$HOSTTYPE" = "x86_64" ] ; then
      ucpu="amd64"
    fi
    ;;
  *aix* )
    myos="aix"
    LINK_FLAGS="$LINK_FLAGS -ldl -lm"
    ;;
  *solaris* | *sun* )
    myos="solaris"
    LINK_FLAGS="$LINK_FLAGS -ldl -lm -lsocket -lnsl"
    ;;
  *haiku* )
    myos="haiku"
    LINK_FLAGS="$LINK_FLAGS -lroot -lnetwork"
    ;;
  *mingw* | *msys* )
    myos="windows"
    ;;
  *android* )
    myos="android"
    LINK_FLAGS="$LINK_FLAGS -ldl -lm -lrt"
    LINK_FLAGS="$LINK_FLAGS -landroid-glob"
    ;;
  *)
    echo 2>&1 "Error: unknown operating system: $uos"
    exit 1
    ;;
esac

case $ucpu in
  *i386* | *i486* | *i586* | *i686* | *bepc* | *i86pc* )
    mycpu="i386" ;;
  *amd*64* | *x86-64* | *x86_64* )
    mycpu="amd64" ;;
  *sparc*|*sun* )
    mycpu="sparc"
    if [ "$myos" = "linux" ] ; then
      if [ "$(getconf LONG_BIT)" = "64" ]; then
        mycpu="sparc64"
      elif [ "$(isainfo -b)" = "64" ]; then
        mycpu="sparc64"
      fi
    fi
    ;;
  *ppc64le* )
    mycpu="powerpc64el" ;;
  *ppc64* )
    if [ "$myos" = "linux" ] ; then
      COMP_FLAGS="$COMP_FLAGS -m64"
      LINK_FLAGS="$LINK_FLAGS -m64"
    fi
    mycpu="powerpc64" ;;
  *power*|*ppc* )
    if [ "$myos" = "freebsd" ] ; then
      COMP_FLAGS="$COMP_FLAGS -m64"
      LINK_FLAGS="$LINK_FLAGS -m64"
      mycpu=`uname -p`
	else
      mycpu="powerpc"
    fi
    ;;
  *ia64*)
    mycpu="ia64" ;;
  *m68k*)
    mycpu="m68k" ;;
  *mips* )
    mycpu="$("$CC" -dumpmachine | sed 's/-.*//')"
    case $mycpu in
      mips|mipsel|mips64|mips64el)
        ;;
      *)
        echo 2>&1 "Error: unknown MIPS target: $mycpu"
        exit 1
    esac
    ;;
  *alpha* )
    mycpu="alpha" ;;
  *arm*|*armv6l*|*armv71* )
    mycpu="arm" ;;
  *aarch64* )
    mycpu="arm64" ;;
  *riscv64* )
    mycpu="riscv64" ;;
  *)
    echo 2>&1 "Error: unknown processor: $ucpu"
    exit 1
    ;;
esac

case $uosname in
  *android* )
    LINK_FLAGS="$LINK_FLAGS -landroid-glob"
    myosname="android"
    myos="android"
    ;;
esac

# call the compiler:
echo \# OS:  $myos
echo \# CPU: $mycpu

case $myos in
windows)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_widestrs.nim.c -o c_code/1_1/stdlib_widestrs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_io.nim.c -o c_code/1_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_system.nim.c -o c_code/1_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parseutils.nim.c -o c_code/1_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_math.nim.c -o c_code/1_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_unicode.nim.c -o c_code/1_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_strutils.nim.c -o c_code/1_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_pathnorm.nim.c -o c_code/1_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dynlib.nim.c -o c_code/1_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_winlean.nim.c -o c_code/1_1/stdlib_winlean.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_times.nim.c -o c_code/1_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_os.nim.c -o c_code/1_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_strtabs.nim.c -o c_code/1_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpathutils.nim.c -o c_code/1_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mropes.nim.c -o c_code/1_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_tables.nim.c -o c_code/1_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlineinfos.nim.c -o c_code/1_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplatform.nim.c -o c_code/1_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_terminal.nim.c -o c_code/1_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@moptions.nim.c -o c_code/1_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmsgs.nim.c -o c_code/1_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_streams.nim.c -o c_code/1_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cpuinfo.nim.c -o c_code/1_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_osproc.nim.c -o c_code/1_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sha1.nim.c -o c_code/1_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_lexbase.nim.c -o c_code/1_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mextccomp.nim.c -o c_code/1_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimblecmd.nim.c -o c_code/1_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parseopt.nim.c -o c_code/1_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mllstream.nim.c -o c_code/1_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mastalgo.nim.c -o c_code/1_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen.nim.c -o c_code/1_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpragmas.nim.c -o c_code/1_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mgorgeimpl.nim.c -o c_code/1_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvm.nim.c -o c_code/1_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgen.nim.c -o c_code/1_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimconf.nim.c -o c_code/1_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mscriptconfig.nim.c -o c_code/1_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcmdlinehelper.nim.c -o c_code/1_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnim.nim.c -o c_code/1_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/1_1/stdlib_widestrs.nim.o \
c_code/1_1/stdlib_io.nim.o \
c_code/1_1/stdlib_system.nim.o \
c_code/1_1/stdlib_parseutils.nim.o \
c_code/1_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/1_1/stdlib_unicode.nim.o \
c_code/1_1/stdlib_strutils.nim.o \
c_code/1_1/stdlib_pathnorm.nim.o \
c_code/1_1/stdlib_dynlib.nim.o \
c_code/1_1/stdlib_winlean.nim.o \
c_code/1_1/stdlib_times.nim.o \
c_code/1_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/1_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/1_1/@mpathutils.nim.o \
c_code/1_1/@mropes.nim.o \
c_code/1_1/stdlib_tables.nim.o \
c_code/1_1/@mlineinfos.nim.o \
c_code/1_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/1_1/stdlib_terminal.nim.o \
c_code/1_1/@moptions.nim.o \
c_code/1_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/1_1/stdlib_streams.nim.o \
c_code/1_1/stdlib_cpuinfo.nim.o \
c_code/1_1/stdlib_osproc.nim.o \
c_code/1_1/stdlib_sha1.nim.o \
c_code/1_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/1_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/1_1/@mnimblecmd.nim.o \
c_code/1_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/1_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/1_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/1_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/1_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/1_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/1_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/1_1/@mcgen.nim.o \
c_code/1_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/1_1/@mscriptconfig.nim.o \
c_code/1_1/@mcmdlinehelper.nim.o \
c_code/1_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_widestrs.nim.c -o c_code/1_2/stdlib_widestrs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_io.nim.c -o c_code/1_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_system.nim.c -o c_code/1_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_parseutils.nim.c -o c_code/1_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_math.nim.c -o c_code/1_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_unicode.nim.c -o c_code/1_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_strutils.nim.c -o c_code/1_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_pathnorm.nim.c -o c_code/1_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dynlib.nim.c -o c_code/1_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_winlean.nim.c -o c_code/1_2/stdlib_winlean.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_times.nim.c -o c_code/1_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_os.nim.c -o c_code/1_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_strtabs.nim.c -o c_code/1_2/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpathutils.nim.c -o c_code/1_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mropes.nim.c -o c_code/1_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_tables.nim.c -o c_code/1_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlineinfos.nim.c -o c_code/1_2/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplatform.nim.c -o c_code/1_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_terminal.nim.c -o c_code/1_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@moptions.nim.c -o c_code/1_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmsgs.nim.c -o c_code/1_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_streams.nim.c -o c_code/1_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cpuinfo.nim.c -o c_code/1_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_osproc.nim.c -o c_code/1_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sha1.nim.c -o c_code/1_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_lexbase.nim.c -o c_code/1_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_parsejson.nim.c -o c_code/1_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_json.nim.c -o c_code/1_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mextccomp.nim.c -o c_code/1_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimblecmd.nim.c -o c_code/1_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_parseopt.nim.c -o c_code/1_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcommands.nim.c -o c_code/1_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mllstream.nim.c -o c_code/1_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlexer.nim.c -o c_code/1_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparser.nim.c -o c_code/1_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrodutils.nim.c -o c_code/1_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mastalgo.nim.c -o c_code/1_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypes.nim.c -o c_code/1_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemfold.nim.c -o c_code/1_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemdata.nim.c -o c_code/1_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemtypinst.nim.c -o c_code/1_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen.nim.c -o c_code/1_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msigmatch.nim.c -o c_code/1_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpragmas.nim.c -o c_code/1_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mreorder.nim.c -o c_code/1_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msighashes.nim.c -o c_code/1_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftdestructors.nim.c -o c_code/1_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdfa.nim.c -o c_code/1_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@minjectdestructors.nim.c -o c_code/1_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdeps.nim.c -o c_code/1_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mgorgeimpl.nim.c -o c_code/1_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mevaltempl.nim.c -o c_code/1_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvm.nim.c -o c_code/1_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msem.nim.c -o c_code/1_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgmerge.nim.c -o c_code/1_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgen.nim.c -o c_code/1_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimconf.nim.c -o c_code/1_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mscriptconfig.nim.c -o c_code/1_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcmdlinehelper.nim.c -o c_code/1_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnim.nim.c -o c_code/1_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/1_2/stdlib_widestrs.nim.o \
c_code/1_2/stdlib_io.nim.o \
c_code/1_2/stdlib_system.nim.o \
c_code/1_2/stdlib_parseutils.nim.o \
c_code/1_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/1_2/stdlib_unicode.nim.o \
c_code/1_2/stdlib_strutils.nim.o \
c_code/1_2/stdlib_pathnorm.nim.o \
c_code/1_2/stdlib_dynlib.nim.o \
c_code/1_2/stdlib_winlean.nim.o \
c_code/1_2/stdlib_times.nim.o \
c_code/1_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/1_2/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/1_2/@mpathutils.nim.o \
c_code/1_2/@mropes.nim.o \
c_code/1_2/stdlib_tables.nim.o \
c_code/1_2/@mlineinfos.nim.o \
c_code/1_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/1_2/stdlib_terminal.nim.o \
c_code/1_2/@moptions.nim.o \
c_code/1_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/1_2/stdlib_streams.nim.o \
c_code/1_2/stdlib_cpuinfo.nim.o \
c_code/1_2/stdlib_osproc.nim.o \
c_code/1_2/stdlib_sha1.nim.o \
c_code/1_2/stdlib_lexbase.nim.o \
c_code/1_2/stdlib_parsejson.nim.o \
c_code/1_2/stdlib_json.nim.o \
c_code/1_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/1_2/@mnimblecmd.nim.o \
c_code/1_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/1_2/@mcommands.nim.o \
c_code/1_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/1_2/@mlexer.nim.o \
c_code/1_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/1_2/@mrodutils.nim.o \
c_code/1_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/1_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/1_2/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/1_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/1_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/1_2/@mdocgen.nim.o \
c_code/1_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/1_2/@mpragmas.nim.o \
c_code/1_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/1_2/@msighashes.nim.o \
c_code/1_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/1_2/@mdfa.nim.o \
c_code/1_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/1_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/1_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/1_2/@mevaltempl.nim.o \
c_code/1_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/1_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/1_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/1_2/@mcgen.nim.o \
c_code/1_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/1_2/@mscriptconfig.nim.o \
c_code/1_2/@mcmdlinehelper.nim.o \
c_code/1_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
linux)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_system.nim.c -o c_code/2_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mplatform.nim.c -o c_code/2_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sha1.nim.c -o c_code/1_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/1_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_io.nim.c -o c_code/2_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_system.nim.c -o c_code/2_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_strutils.nim.c -o c_code/2_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_posix.nim.c -o c_code/2_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_times.nim.c -o c_code/2_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_os.nim.c -o c_code/2_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_strtabs.nim.c -o c_code/2_2/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_tables.nim.c -o c_code/2_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mlineinfos.nim.c -o c_code/2_2/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mplatform.nim.c -o c_code/2_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_strformat.nim.c -o c_code/2_2/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@moptions.nim.c -o c_code/2_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mmsgs.nim.c -o c_code/2_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_streams.nim.c -o c_code/2_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_cpuinfo.nim.c -o c_code/2_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_osproc.nim.c -o c_code/2_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_sha1.nim.c -o c_code/2_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parsejson.nim.c -o c_code/2_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_json.nim.c -o c_code/2_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mextccomp.nim.c -o c_code/2_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnimblecmd.nim.c -o c_code/2_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mcommands.nim.c -o c_code/2_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mlexer.nim.c -o c_code/2_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mparser.nim.c -o c_code/2_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mrodutils.nim.c -o c_code/2_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mastalgo.nim.c -o c_code/2_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mtypes.nim.c -o c_code/2_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@msemfold.nim.c -o c_code/2_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mmodulepaths.nim.c -o c_code/2_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@msemdata.nim.c -o c_code/2_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@msemtypinst.nim.c -o c_code/2_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mdocgen.nim.c -o c_code/2_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@msigmatch.nim.c -o c_code/2_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpragmas.nim.c -o c_code/2_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mreorder.nim.c -o c_code/2_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@msighashes.nim.c -o c_code/2_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mliftdestructors.nim.c -o c_code/2_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mdfa.nim.c -o c_code/2_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@minjectdestructors.nim.c -o c_code/2_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mvmdeps.nim.c -o c_code/2_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mgorgeimpl.nim.c -o c_code/2_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mevaltempl.nim.c -o c_code/2_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mvm.nim.c -o c_code/2_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@msem.nim.c -o c_code/2_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mccgmerge.nim.c -o c_code/2_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mcgen.nim.c -o c_code/2_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnimconf.nim.c -o c_code/2_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mjsgen.nim.c -o c_code/2_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mdocgen2.nim.c -o c_code/2_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mscriptconfig.nim.c -o c_code/2_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mcmdlinehelper.nim.c -o c_code/2_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_2/stdlib_io.nim.o \
c_code/2_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_2/stdlib_posix.nim.o \
c_code/2_2/stdlib_times.nim.o \
c_code/2_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_2/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_2/stdlib_tables.nim.o \
c_code/2_2/@mlineinfos.nim.o \
c_code/2_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_2/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_2/@moptions.nim.o \
c_code/2_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_2/stdlib_streams.nim.o \
c_code/2_2/stdlib_cpuinfo.nim.o \
c_code/2_2/stdlib_osproc.nim.o \
c_code/2_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_2/stdlib_parsejson.nim.o \
c_code/2_2/stdlib_json.nim.o \
c_code/2_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_2/@mlexer.nim.o \
c_code/2_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_2/@mrodutils.nim.o \
c_code/2_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_2/@msemfold.nim.o \
c_code/2_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_2/@mdocgen.nim.o \
c_code/2_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_2/@mpragmas.nim.o \
c_code/2_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_2/@msighashes.nim.o \
c_code/2_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_2/@mdfa.nim.o \
c_code/2_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_2/@mevaltempl.nim.o \
c_code/2_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_2/@mcgen.nim.o \
c_code/2_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/2_2/@mjsgen.nim.o \
c_code/2_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_2/@mscriptconfig.nim.o \
c_code/2_2/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mplatform.nim.c -o c_code/2_3/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_sha1.nim.c -o c_code/2_3/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_3/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_3/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_4/@mplatform.nim.c -o c_code/2_4/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_sha1.nim.c -o c_code/2_3/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_4/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_3/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/@mplatform.nim.c -o c_code/2_5/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/stdlib_sha1.nim.c -o c_code/2_5/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_5/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_5/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_system.nim.c -o c_code/2_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/@mplatform.nim.c -o c_code/2_6/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sha1.nim.c -o c_code/1_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_6/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/1_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/stdlib_system.nim.c -o c_code/2_7/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/@mplatform.nim.c -o c_code/2_7/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/stdlib_sha1.nim.c -o c_code/2_7/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/@mtypes.nim.c -o c_code/2_7/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_7/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_7/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/2_7/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/2_7/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_8/@mplatform.nim.c -o c_code/2_8/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/stdlib_sha1.nim.c -o c_code/2_5/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_8/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_5/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_system.nim.c -o c_code/2_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_9/@mplatform.nim.c -o c_code/2_9/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/stdlib_sha1.nim.c -o c_code/2_7/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_9/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/2_7/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_system.nim.c -o c_code/2_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_10/@mplatform.nim.c -o c_code/2_10/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/stdlib_sha1.nim.c -o c_code/2_7/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_10/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/2_7/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_system.nim.c -o c_code/2_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_11/@mplatform.nim.c -o c_code/2_11/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sha1.nim.c -o c_code/1_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_11/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/1_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_12/@mplatform.nim.c -o c_code/2_12/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/stdlib_sha1.nim.c -o c_code/2_5/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_12/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_5/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_13/@mplatform.nim.c -o c_code/2_13/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_sha1.nim.c -o c_code/2_3/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_13/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_3/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_system.nim.c -o c_code/2_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strutils.nim.c -o c_code/2_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_posix.nim.c -o c_code/2_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_os.nim.c -o c_code/2_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_tables.nim.c -o c_code/2_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_14/@mplatform.nim.c -o c_code/2_14/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_osproc.nim.c -o c_code/2_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/stdlib_sha1.nim.c -o c_code/2_7/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_parsejson.nim.c -o c_code/1_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_json.nim.c -o c_code/1_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mextccomp.nim.c -o c_code/2_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimblecmd.nim.c -o c_code/2_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcommands.nim.c -o c_code/1_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlexer.nim.c -o c_code/1_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparser.nim.c -o c_code/1_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrodutils.nim.c -o c_code/1_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mastalgo.nim.c -o c_code/2_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypes.nim.c -o c_code/1_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemfold.nim.c -o c_code/1_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemdata.nim.c -o c_code/1_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemtypinst.nim.c -o c_code/1_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mdocgen.nim.c -o c_code/2_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msigmatch.nim.c -o c_code/1_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mreorder.nim.c -o c_code/1_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msighashes.nim.c -o c_code/1_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftdestructors.nim.c -o c_code/1_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdfa.nim.c -o c_code/1_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@minjectdestructors.nim.c -o c_code/1_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdeps.nim.c -o c_code/1_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mevaltempl.nim.c -o c_code/1_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msem.nim.c -o c_code/1_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgmerge.nim.c -o c_code/1_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcgen.nim.c -o c_code/2_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnimconf.nim.c -o c_code/2_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mjsgen.nim.c -o c_code/2_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mcmdlinehelper.nim.c -o c_code/2_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/2_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/2_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/2_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/2_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/2_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/2_14/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/2_1/stdlib_osproc.nim.o \
c_code/2_7/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/1_1/stdlib_parsejson.nim.o \
c_code/1_1/stdlib_json.nim.o \
c_code/2_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/2_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/1_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/1_1/@mlexer.nim.o \
c_code/1_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/1_1/@mrodutils.nim.o \
c_code/2_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/1_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/1_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/1_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/1_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/2_1/@mdocgen.nim.o \
c_code/1_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/1_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/1_1/@msighashes.nim.o \
c_code/1_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/1_1/@mdfa.nim.o \
c_code/1_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/1_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/1_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/1_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/1_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/2_1/@mcgen.nim.o \
c_code/2_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/2_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/2_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_15/@mplatform.nim.c -o c_code/2_15/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_sha1.nim.c -o c_code/2_3/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_15/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_3/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_16/@mplatform.nim.c -o c_code/2_16/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_sha1.nim.c -o c_code/2_3/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_16/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_3/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_system.nim.c -o c_code/2_3/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strutils.nim.c -o c_code/2_3/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_posix.nim.c -o c_code/2_3/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_os.nim.c -o c_code/2_3/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_tables.nim.c -o c_code/2_3/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_17/@mplatform.nim.c -o c_code/2_17/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_osproc.nim.c -o c_code/2_3/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_sha1.nim.c -o c_code/2_3/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parsejson.nim.c -o c_code/2_3/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_json.nim.c -o c_code/2_3/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mextccomp.nim.c -o c_code/2_3/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimblecmd.nim.c -o c_code/2_3/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcommands.nim.c -o c_code/2_3/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlexer.nim.c -o c_code/2_3/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mparser.nim.c -o c_code/2_3/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mrodutils.nim.c -o c_code/2_3/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mastalgo.nim.c -o c_code/2_3/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mtypes.nim.c -o c_code/2_3/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemfold.nim.c -o c_code/2_3/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemdata.nim.c -o c_code/2_3/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msemtypinst.nim.c -o c_code/2_3/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdocgen.nim.c -o c_code/2_3/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msigmatch.nim.c -o c_code/2_3/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mreorder.nim.c -o c_code/2_3/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msighashes.nim.c -o c_code/2_3/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mliftdestructors.nim.c -o c_code/2_3/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mdfa.nim.c -o c_code/2_3/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@minjectdestructors.nim.c -o c_code/2_3/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvmdeps.nim.c -o c_code/2_3/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mevaltempl.nim.c -o c_code/2_3/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@msem.nim.c -o c_code/2_3/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mccgmerge.nim.c -o c_code/2_3/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcgen.nim.c -o c_code/2_3/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mnimconf.nim.c -o c_code/2_3/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mjsgen.nim.c -o c_code/1_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mcmdlinehelper.nim.c -o c_code/2_3/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/2_3/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/2_3/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/2_3/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/2_3/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/2_3/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/2_17/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/2_3/stdlib_osproc.nim.o \
c_code/2_3/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/2_3/stdlib_parsejson.nim.o \
c_code/2_3/stdlib_json.nim.o \
c_code/2_3/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/2_3/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/2_3/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/2_3/@mlexer.nim.o \
c_code/2_3/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/2_3/@mrodutils.nim.o \
c_code/2_3/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/2_3/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/2_3/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/2_3/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/2_3/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/2_3/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/2_3/@mdocgen.nim.o \
c_code/2_3/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/2_3/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/2_3/@msighashes.nim.o \
c_code/2_3/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/2_3/@mdfa.nim.o \
c_code/2_3/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/2_3/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/2_3/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/2_3/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/2_3/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/2_3/@mcgen.nim.o \
c_code/2_3/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/1_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/2_3/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
macosx)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_system.nim.c -o c_code/3_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_times.nim.c -o c_code/3_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_os.nim.c -o c_code/3_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mplatform.nim.c -o c_code/3_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@moptions.nim.c -o c_code/3_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_cpuinfo.nim.c -o c_code/3_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_osproc.nim.c -o c_code/3_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mextccomp.nim.c -o c_code/3_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimblecmd.nim.c -o c_code/3_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mtypes.nim.c -o c_code/3_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvm.nim.c -o c_code/3_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mscriptconfig.nim.c -o c_code/3_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/3_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/3_1/stdlib_times.nim.o \
c_code/3_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/3_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/3_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/3_1/stdlib_cpuinfo.nim.o \
c_code/3_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/3_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/3_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/3_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/3_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/3_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_system.nim.c -o c_code/3_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_times.nim.c -o c_code/3_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_os.nim.c -o c_code/3_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mplatform.nim.c -o c_code/3_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@moptions.nim.c -o c_code/3_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_cpuinfo.nim.c -o c_code/3_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_osproc.nim.c -o c_code/3_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mextccomp.nim.c -o c_code/3_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimblecmd.nim.c -o c_code/3_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mtypes.nim.c -o c_code/3_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvm.nim.c -o c_code/3_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mscriptconfig.nim.c -o c_code/3_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/3_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/3_2/stdlib_times.nim.o \
c_code/3_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/3_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/3_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/3_2/stdlib_cpuinfo.nim.o \
c_code/3_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/3_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/3_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/3_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/3_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/3_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_5/stdlib_system.nim.c -o c_code/3_5/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_times.nim.c -o c_code/3_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_os.nim.c -o c_code/3_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_5/@mplatform.nim.c -o c_code/3_5/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@moptions.nim.c -o c_code/3_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_cpuinfo.nim.c -o c_code/3_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_osproc.nim.c -o c_code/3_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/stdlib_sha1.nim.c -o c_code/2_5/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mextccomp.nim.c -o c_code/3_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimblecmd.nim.c -o c_code/3_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mtypes.nim.c -o c_code/3_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvm.nim.c -o c_code/3_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mscriptconfig.nim.c -o c_code/3_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/3_5/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/3_2/stdlib_times.nim.o \
c_code/3_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/3_5/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/3_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/3_2/stdlib_cpuinfo.nim.o \
c_code/3_2/stdlib_osproc.nim.o \
c_code/2_5/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/3_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/3_2/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/3_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/3_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/3_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
solaris)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_system.nim.c -o c_code/4_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_times.nim.c -o c_code/4_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_os.nim.c -o c_code/4_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mplatform.nim.c -o c_code/4_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@moptions.nim.c -o c_code/4_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_osproc.nim.c -o c_code/4_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mextccomp.nim.c -o c_code/4_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mnimblecmd.nim.c -o c_code/4_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mtypes.nim.c -o c_code/3_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/4_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mvm.nim.c -o c_code/4_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mscriptconfig.nim.c -o c_code/4_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/4_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/4_1/stdlib_times.nim.o \
c_code/4_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/4_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/4_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/4_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/4_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/4_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/3_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/4_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/4_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/4_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_system.nim.c -o c_code/4_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_times.nim.c -o c_code/4_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_os.nim.c -o c_code/4_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mplatform.nim.c -o c_code/4_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_osproc.nim.c -o c_code/4_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mnimblecmd.nim.c -o c_code/4_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mtypes.nim.c -o c_code/4_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/4_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mvm.nim.c -o c_code/4_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mscriptconfig.nim.c -o c_code/4_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/4_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/4_2/stdlib_times.nim.o \
c_code/4_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/4_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/4_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/4_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/4_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/4_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/4_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/4_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_7/stdlib_system.nim.c -o c_code/4_7/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_times.nim.c -o c_code/4_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_os.nim.c -o c_code/4_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_7/@mplatform.nim.c -o c_code/4_7/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@moptions.nim.c -o c_code/4_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_osproc.nim.c -o c_code/4_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_7/stdlib_sha1.nim.c -o c_code/2_7/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mextccomp.nim.c -o c_code/4_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mnimblecmd.nim.c -o c_code/4_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_7/@mtypes.nim.c -o c_code/4_7/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/4_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mvm.nim.c -o c_code/4_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mscriptconfig.nim.c -o c_code/4_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/4_7/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/4_1/stdlib_times.nim.o \
c_code/4_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/4_7/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/4_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/4_1/stdlib_osproc.nim.o \
c_code/2_7/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/4_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/4_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/4_7/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/4_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/4_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/4_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_8/stdlib_system.nim.c -o c_code/4_8/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_times.nim.c -o c_code/4_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_os.nim.c -o c_code/4_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_8/@mplatform.nim.c -o c_code/4_8/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_osproc.nim.c -o c_code/4_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/stdlib_sha1.nim.c -o c_code/2_5/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mnimblecmd.nim.c -o c_code/4_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mtypes.nim.c -o c_code/4_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/4_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mvm.nim.c -o c_code/4_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mscriptconfig.nim.c -o c_code/4_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/4_8/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/4_2/stdlib_times.nim.o \
c_code/4_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/4_8/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/4_2/stdlib_osproc.nim.o \
c_code/2_5/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/4_2/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/4_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/4_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/4_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/4_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
freebsd)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_system.nim.c -o c_code/5_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_times.nim.c -o c_code/5_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_os.nim.c -o c_code/5_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/@mplatform.nim.c -o c_code/5_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@moptions.nim.c -o c_code/4_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_cpuinfo.nim.c -o c_code/3_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_osproc.nim.c -o c_code/5_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mextccomp.nim.c -o c_code/4_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimblecmd.nim.c -o c_code/3_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mtypes.nim.c -o c_code/3_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvm.nim.c -o c_code/3_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mscriptconfig.nim.c -o c_code/3_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/5_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/5_1/stdlib_times.nim.o \
c_code/5_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/5_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/4_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/3_1/stdlib_cpuinfo.nim.o \
c_code/5_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/4_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/3_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/3_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/3_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/3_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_system.nim.c -o c_code/5_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_times.nim.c -o c_code/5_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_os.nim.c -o c_code/5_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/@mplatform.nim.c -o c_code/5_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_cpuinfo.nim.c -o c_code/3_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_osproc.nim.c -o c_code/5_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimblecmd.nim.c -o c_code/3_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mtypes.nim.c -o c_code/3_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvm.nim.c -o c_code/3_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mscriptconfig.nim.c -o c_code/3_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/5_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/5_2/stdlib_times.nim.o \
c_code/5_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/5_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/3_2/stdlib_cpuinfo.nim.o \
c_code/5_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/3_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/3_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/3_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/3_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_5/stdlib_system.nim.c -o c_code/5_5/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_times.nim.c -o c_code/5_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_os.nim.c -o c_code/5_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_5/@mplatform.nim.c -o c_code/5_5/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_cpuinfo.nim.c -o c_code/3_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_osproc.nim.c -o c_code/5_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_5/stdlib_sha1.nim.c -o c_code/2_5/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimblecmd.nim.c -o c_code/3_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mtypes.nim.c -o c_code/3_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvm.nim.c -o c_code/3_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mscriptconfig.nim.c -o c_code/3_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/5_5/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/5_2/stdlib_times.nim.o \
c_code/5_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/5_5/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/3_2/stdlib_cpuinfo.nim.o \
c_code/5_2/stdlib_osproc.nim.o \
c_code/2_5/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/3_2/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/3_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/3_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/3_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
netbsd)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_system.nim.c -o c_code/5_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_1/stdlib_times.nim.c -o c_code/6_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_1/stdlib_os.nim.c -o c_code/6_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_1/@mplatform.nim.c -o c_code/6_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@moptions.nim.c -o c_code/4_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_1/stdlib_cpuinfo.nim.c -o c_code/6_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_1/stdlib_osproc.nim.c -o c_code/6_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mextccomp.nim.c -o c_code/4_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimblecmd.nim.c -o c_code/3_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mtypes.nim.c -o c_code/3_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvm.nim.c -o c_code/3_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mscriptconfig.nim.c -o c_code/3_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/5_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/6_1/stdlib_times.nim.o \
c_code/6_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/6_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/4_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/6_1/stdlib_cpuinfo.nim.o \
c_code/6_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/4_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/3_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/3_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/3_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/3_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_system.nim.c -o c_code/5_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_2/stdlib_times.nim.c -o c_code/6_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_2/stdlib_os.nim.c -o c_code/6_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_2/@mplatform.nim.c -o c_code/6_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_2/stdlib_cpuinfo.nim.c -o c_code/6_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_2/stdlib_osproc.nim.c -o c_code/6_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimblecmd.nim.c -o c_code/3_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mtypes.nim.c -o c_code/4_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvm.nim.c -o c_code/3_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mscriptconfig.nim.c -o c_code/3_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/5_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/6_2/stdlib_times.nim.o \
c_code/6_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/6_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/6_2/stdlib_cpuinfo.nim.o \
c_code/6_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/3_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/4_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/3_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/3_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
openbsd)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_system.nim.c -o c_code/5_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_times.nim.c -o c_code/5_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/7_1/stdlib_os.nim.c -o c_code/7_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/7_1/@mplatform.nim.c -o c_code/7_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@moptions.nim.c -o c_code/4_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_1/stdlib_cpuinfo.nim.c -o c_code/6_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_osproc.nim.c -o c_code/5_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mextccomp.nim.c -o c_code/4_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimblecmd.nim.c -o c_code/3_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mtypes.nim.c -o c_code/3_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvm.nim.c -o c_code/3_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mscriptconfig.nim.c -o c_code/3_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/5_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/5_1/stdlib_times.nim.o \
c_code/7_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/7_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/4_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/6_1/stdlib_cpuinfo.nim.o \
c_code/5_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/4_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/3_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/3_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/3_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/3_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_system.nim.c -o c_code/5_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_times.nim.c -o c_code/5_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/7_2/stdlib_os.nim.c -o c_code/7_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/7_2/@mplatform.nim.c -o c_code/7_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/6_2/stdlib_cpuinfo.nim.c -o c_code/6_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_osproc.nim.c -o c_code/5_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimblecmd.nim.c -o c_code/3_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mtypes.nim.c -o c_code/3_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvm.nim.c -o c_code/3_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mscriptconfig.nim.c -o c_code/3_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/5_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/5_2/stdlib_times.nim.o \
c_code/7_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/7_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/6_2/stdlib_cpuinfo.nim.o \
c_code/5_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/3_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/3_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/3_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/3_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
dragonfly)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_io.nim.c -o c_code/3_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_system.nim.c -o c_code/5_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/stdlib_os.nim.c -o c_code/8_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/@mplatform.nim.c -o c_code/8_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@moptions.nim.c -o c_code/4_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmsgs.nim.c -o c_code/3_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_streams.nim.c -o c_code/3_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/stdlib_cpuinfo.nim.c -o c_code/8_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_1/stdlib_osproc.nim.c -o c_code/5_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_json.nim.c -o c_code/3_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/@mextccomp.nim.c -o c_code/4_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/@mnimblecmd.nim.c -o c_code/8_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcommands.nim.c -o c_code/3_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mlexer.nim.c -o c_code/3_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mtypes.nim.c -o c_code/3_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemfold.nim.c -o c_code/3_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mmodulepaths.nim.c -o c_code/3_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/8_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msigmatch.nim.c -o c_code/3_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mpragmas.nim.c -o c_code/3_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mvmdeps.nim.c -o c_code/3_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mgorgeimpl.nim.c -o c_code/3_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/@mvm.nim.c -o c_code/8_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msem.nim.c -o c_code/3_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen2.nim.c -o c_code/3_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_1/@mscriptconfig.nim.c -o c_code/8_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcmdlinehelper.nim.c -o c_code/3_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/3_1/stdlib_io.nim.o \
c_code/5_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/8_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/8_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/4_1/@moptions.nim.o \
c_code/3_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/3_1/stdlib_streams.nim.o \
c_code/8_1/stdlib_cpuinfo.nim.o \
c_code/5_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/3_1/stdlib_json.nim.o \
c_code/4_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/8_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/3_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/3_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/3_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/3_1/@msemfold.nim.o \
c_code/3_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/8_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/3_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/3_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/3_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/3_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/8_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/3_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/3_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/8_1/@mscriptconfig.nim.o \
c_code/3_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_io.nim.c -o c_code/3_2/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_system.nim.c -o c_code/5_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/stdlib_os.nim.c -o c_code/8_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/@mplatform.nim.c -o c_code/8_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@moptions.nim.c -o c_code/4_2/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmsgs.nim.c -o c_code/3_2/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_streams.nim.c -o c_code/3_2/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/stdlib_cpuinfo.nim.c -o c_code/8_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/5_2/stdlib_osproc.nim.c -o c_code/5_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_json.nim.c -o c_code/3_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/@mextccomp.nim.c -o c_code/4_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/@mnimblecmd.nim.c -o c_code/8_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcommands.nim.c -o c_code/3_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mlexer.nim.c -o c_code/3_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mtypes.nim.c -o c_code/3_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemfold.nim.c -o c_code/3_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mmodulepaths.nim.c -o c_code/3_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/8_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msigmatch.nim.c -o c_code/3_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mpragmas.nim.c -o c_code/3_2/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mvmdeps.nim.c -o c_code/3_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mgorgeimpl.nim.c -o c_code/3_2/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/@mvm.nim.c -o c_code/8_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msem.nim.c -o c_code/3_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen2.nim.c -o c_code/3_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/8_2/@mscriptconfig.nim.c -o c_code/8_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcmdlinehelper.nim.c -o c_code/3_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/3_2/stdlib_io.nim.o \
c_code/5_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/8_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/8_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/4_2/@moptions.nim.o \
c_code/3_2/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/3_2/stdlib_streams.nim.o \
c_code/8_2/stdlib_cpuinfo.nim.o \
c_code/5_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/3_2/stdlib_json.nim.o \
c_code/4_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/8_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/3_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/3_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/3_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/3_2/@msemfold.nim.o \
c_code/3_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/8_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/3_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/3_2/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/3_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/3_2/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/8_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/3_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/3_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/8_2/@mscriptconfig.nim.o \
c_code/3_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
haiku)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_io.nim.c -o c_code/2_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/stdlib_system.nim.c -o c_code/9_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_strutils.nim.c -o c_code/3_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_posix.nim.c -o c_code/3_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_1/stdlib_times.nim.c -o c_code/4_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/stdlib_os.nim.c -o c_code/9_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strtabs.nim.c -o c_code/2_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_tables.nim.c -o c_code/3_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mlineinfos.nim.c -o c_code/2_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mplatform.nim.c -o c_code/9_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_strformat.nim.c -o c_code/2_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@moptions.nim.c -o c_code/2_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mmsgs.nim.c -o c_code/2_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/stdlib_cpuinfo.nim.c -o c_code/9_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/stdlib_osproc.nim.c -o c_code/9_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_sha1.nim.c -o c_code/3_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/stdlib_parsejson.nim.c -o c_code/3_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/stdlib_json.nim.c -o c_code/9_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mextccomp.nim.c -o c_code/9_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mnimblecmd.nim.c -o c_code/9_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mcommands.nim.c -o c_code/9_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mlexer.nim.c -o c_code/9_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mparser.nim.c -o c_code/3_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mrodutils.nim.c -o c_code/3_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mastalgo.nim.c -o c_code/3_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mtypes.nim.c -o c_code/9_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@msemfold.nim.c -o c_code/9_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemdata.nim.c -o c_code/3_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msemtypinst.nim.c -o c_code/3_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/9_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdocgen.nim.c -o c_code/3_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@msigmatch.nim.c -o c_code/9_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpragmas.nim.c -o c_code/2_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mreorder.nim.c -o c_code/3_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@msighashes.nim.c -o c_code/3_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mliftdestructors.nim.c -o c_code/3_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mdfa.nim.c -o c_code/3_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@minjectdestructors.nim.c -o c_code/3_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mvmdeps.nim.c -o c_code/9_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mevaltempl.nim.c -o c_code/3_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mvm.nim.c -o c_code/9_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@msem.nim.c -o c_code/9_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mccgmerge.nim.c -o c_code/3_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mcgen.nim.c -o c_code/3_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnimconf.nim.c -o c_code/3_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mjsgen.nim.c -o c_code/1_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mscriptconfig.nim.c -o c_code/9_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_1/@mcmdlinehelper.nim.c -o c_code/9_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_1/@mnim.nim.c -o c_code/3_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/2_1/stdlib_io.nim.o \
c_code/9_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/3_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/3_1/stdlib_posix.nim.o \
c_code/4_1/stdlib_times.nim.o \
c_code/9_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/2_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/3_1/stdlib_tables.nim.o \
c_code/2_1/@mlineinfos.nim.o \
c_code/9_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/2_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/2_1/@moptions.nim.o \
c_code/2_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/9_1/stdlib_cpuinfo.nim.o \
c_code/9_1/stdlib_osproc.nim.o \
c_code/3_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/3_1/stdlib_parsejson.nim.o \
c_code/9_1/stdlib_json.nim.o \
c_code/9_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/9_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/9_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/9_1/@mlexer.nim.o \
c_code/3_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/3_1/@mrodutils.nim.o \
c_code/3_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/9_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/9_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/3_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/3_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/9_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/3_1/@mdocgen.nim.o \
c_code/9_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/2_1/@mpragmas.nim.o \
c_code/3_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/3_1/@msighashes.nim.o \
c_code/3_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/3_1/@mdfa.nim.o \
c_code/3_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/9_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/3_1/@mevaltempl.nim.o \
c_code/9_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/9_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/3_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/3_1/@mcgen.nim.o \
c_code/3_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/1_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/9_1/@mscriptconfig.nim.o \
c_code/9_1/@mcmdlinehelper.nim.o \
c_code/3_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_io.nim.c -o c_code/2_3/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/stdlib_system.nim.c -o c_code/9_2/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_strutils.nim.c -o c_code/3_2/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_posix.nim.c -o c_code/3_2/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/4_2/stdlib_times.nim.c -o c_code/4_2/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/stdlib_os.nim.c -o c_code/9_2/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strtabs.nim.c -o c_code/2_3/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_tables.nim.c -o c_code/3_2/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mlineinfos.nim.c -o c_code/2_3/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mplatform.nim.c -o c_code/9_2/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_strformat.nim.c -o c_code/2_3/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@moptions.nim.c -o c_code/2_3/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mmsgs.nim.c -o c_code/2_3/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/stdlib_cpuinfo.nim.c -o c_code/9_2/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/stdlib_osproc.nim.c -o c_code/9_2/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_sha1.nim.c -o c_code/3_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/stdlib_parsejson.nim.c -o c_code/3_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/stdlib_json.nim.c -o c_code/9_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mextccomp.nim.c -o c_code/9_2/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mnimblecmd.nim.c -o c_code/9_2/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseopt.nim.c -o c_code/2_2/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mcommands.nim.c -o c_code/9_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mlexer.nim.c -o c_code/9_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mparser.nim.c -o c_code/3_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mrodutils.nim.c -o c_code/3_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mastalgo.nim.c -o c_code/3_2/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mtypes.nim.c -o c_code/9_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@msemfold.nim.c -o c_code/9_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemdata.nim.c -o c_code/3_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msemtypinst.nim.c -o c_code/3_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/9_2/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdocgen.nim.c -o c_code/3_2/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@msigmatch.nim.c -o c_code/9_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mpragmas.nim.c -o c_code/2_3/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mreorder.nim.c -o c_code/3_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@msighashes.nim.c -o c_code/3_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mliftdestructors.nim.c -o c_code/3_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mdfa.nim.c -o c_code/3_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@minjectdestructors.nim.c -o c_code/3_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mvmdeps.nim.c -o c_code/9_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mevaltempl.nim.c -o c_code/3_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mvm.nim.c -o c_code/9_2/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@msem.nim.c -o c_code/9_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mccgmerge.nim.c -o c_code/3_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mscriptconfig.nim.c -o c_code/9_2/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mcmdlinehelper.nim.c -o c_code/9_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnim.nim.c -o c_code/3_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/2_3/stdlib_io.nim.o \
c_code/9_2/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/3_2/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/3_2/stdlib_posix.nim.o \
c_code/4_2/stdlib_times.nim.o \
c_code/9_2/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_3/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/3_2/stdlib_tables.nim.o \
c_code/2_3/@mlineinfos.nim.o \
c_code/9_2/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_3/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/2_3/@moptions.nim.o \
c_code/2_3/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/9_2/stdlib_cpuinfo.nim.o \
c_code/9_2/stdlib_osproc.nim.o \
c_code/3_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/3_2/stdlib_parsejson.nim.o \
c_code/9_2/stdlib_json.nim.o \
c_code/9_2/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/9_2/@mnimblecmd.nim.o \
c_code/2_2/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/9_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/9_2/@mlexer.nim.o \
c_code/3_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/3_2/@mrodutils.nim.o \
c_code/3_2/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/9_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/9_2/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/3_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/3_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/3_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/9_2/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/3_2/@mdocgen.nim.o \
c_code/9_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/2_3/@mpragmas.nim.o \
c_code/3_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/3_2/@msighashes.nim.o \
c_code/3_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/3_2/@mdfa.nim.o \
c_code/3_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/9_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/3_2/@mevaltempl.nim.o \
c_code/9_2/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/9_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/3_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/9_2/@mscriptconfig.nim.o \
c_code/9_2/@mcmdlinehelper.nim.o \
c_code/3_2/@mnim.nim.o $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
android)
  case $mycpu in
  i386)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_io.nim.c -o c_code/10_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_system.nim.c -o c_code/10_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_strutils.nim.c -o c_code/10_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_posix.nim.c -o c_code/10_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_os.nim.c -o c_code/10_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_strtabs.nim.c -o c_code/10_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_tables.nim.c -o c_code/10_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mlineinfos.nim.c -o c_code/10_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mplatform.nim.c -o c_code/10_1/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_strformat.nim.c -o c_code/10_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@moptions.nim.c -o c_code/10_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mmsgs.nim.c -o c_code/10_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_osproc.nim.c -o c_code/10_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_sha1.nim.c -o c_code/10_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_parsejson.nim.c -o c_code/10_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_json.nim.c -o c_code/10_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mextccomp.nim.c -o c_code/10_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mnimblecmd.nim.c -o c_code/10_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseopt.nim.c -o c_code/2_1/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mcommands.nim.c -o c_code/10_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mlexer.nim.c -o c_code/10_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mparser.nim.c -o c_code/10_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mrodutils.nim.c -o c_code/10_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mastalgo.nim.c -o c_code/10_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mtypes.nim.c -o c_code/10_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msemfold.nim.c -o c_code/10_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msemdata.nim.c -o c_code/10_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msemtypinst.nim.c -o c_code/10_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/10_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/10_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mdocgen.nim.c -o c_code/10_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msigmatch.nim.c -o c_code/10_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mpragmas.nim.c -o c_code/10_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mreorder.nim.c -o c_code/10_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msighashes.nim.c -o c_code/10_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mliftdestructors.nim.c -o c_code/10_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mdfa.nim.c -o c_code/10_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@minjectdestructors.nim.c -o c_code/10_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mvmdeps.nim.c -o c_code/10_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mevaltempl.nim.c -o c_code/10_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msem.nim.c -o c_code/10_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mccgmerge.nim.c -o c_code/10_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mcgen.nim.c -o c_code/10_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mnimconf.nim.c -o c_code/10_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mjsgen.nim.c -o c_code/10_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mcmdlinehelper.nim.c -o c_code/10_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/10_1/stdlib_io.nim.o \
c_code/10_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/10_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/10_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/10_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/10_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/10_1/stdlib_tables.nim.o \
c_code/10_1/@mlineinfos.nim.o \
c_code/10_1/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/10_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/10_1/@moptions.nim.o \
c_code/10_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/10_1/stdlib_osproc.nim.o \
c_code/10_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/10_1/stdlib_parsejson.nim.o \
c_code/10_1/stdlib_json.nim.o \
c_code/10_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/10_1/@mnimblecmd.nim.o \
c_code/2_1/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/10_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/10_1/@mlexer.nim.o \
c_code/10_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/10_1/@mrodutils.nim.o \
c_code/10_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/10_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/10_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/10_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/10_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/10_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/10_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/10_1/@mdocgen.nim.o \
c_code/10_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/10_1/@mpragmas.nim.o \
c_code/10_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/10_1/@msighashes.nim.o \
c_code/10_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/10_1/@mdfa.nim.o \
c_code/10_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/10_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/10_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/10_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/10_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/10_1/@mcgen.nim.o \
c_code/10_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/10_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/10_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_assertions.nim.c -o c_code/1_1/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_dollars.nim.c -o c_code/1_1/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_formatfloat.nim.c -o c_code/1_1/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_io.nim.c -o c_code/10_1/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_system.nim.c -o c_code/10_1/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_parseutils.nim.c -o c_code/2_1/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_math.nim.c -o c_code/2_1/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_algorithm.nim.c -o c_code/1_1/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_unicode.nim.c -o c_code/2_1/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_strutils.nim.c -o c_code/10_1/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_pathnorm.nim.c -o c_code/2_1/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_posix.nim.c -o c_code/10_1/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_times.nim.c -o c_code/2_1/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_os.nim.c -o c_code/10_1/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_hashes.nim.c -o c_code/1_1/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_strtabs.nim.c -o c_code/10_1/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_sets.nim.c -o c_code/1_1/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mpathutils.nim.c -o c_code/2_1/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mropes.nim.c -o c_code/2_1/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_tables.nim.c -o c_code/10_1/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mlineinfos.nim.c -o c_code/10_1/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_6/@mplatform.nim.c -o c_code/10_6/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprefixmatches.nim.c -o c_code/1_1/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_strformat.nim.c -o c_code/10_1/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_terminal.nim.c -o c_code/2_1/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@moptions.nim.c -o c_code/10_1/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mmsgs.nim.c -o c_code/10_1/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcondsyms.nim.c -o c_code/1_1/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_streams.nim.c -o c_code/2_1/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_cpuinfo.nim.c -o c_code/2_1/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_osproc.nim.c -o c_code/10_1/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_sha1.nim.c -o c_code/10_1/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_lexbase.nim.c -o c_code/2_1/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_parsejson.nim.c -o c_code/10_1/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/stdlib_json.nim.c -o c_code/10_1/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mextccomp.nim.c -o c_code/10_1/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mwordrecg.nim.c -o c_code/1_1/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mnimblecmd.nim.c -o c_code/10_1/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_6/stdlib_parseopt.nim.c -o c_code/2_6/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mincremental.nim.c -o c_code/1_1/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mcommands.nim.c -o c_code/10_1/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mllstream.nim.c -o c_code/2_1/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midents.nim.c -o c_code/1_1/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@midgen.nim.c -o c_code/1_1/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mint128.nim.c -o c_code/1_1/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mast.nim.c -o c_code/1_1/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimlexbase.nim.c -o c_code/1_1/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mlexer.nim.c -o c_code/10_1/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mparser.nim.c -o c_code/10_1/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mrenderer.nim.c -o c_code/1_1/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilters.nim.c -o c_code/1_1/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mfilter_tmpl.nim.c -o c_code/1_1/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msyntaxes.nim.c -o c_code/1_1/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_intsets.nim.c -o c_code/1_1/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mrodutils.nim.c -o c_code/10_1/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mastalgo.nim.c -o c_code/10_1/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtrees.nim.c -o c_code/1_1/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mtypes.nim.c -o c_code/10_1/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbtrees.nim.c -o c_code/1_1/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_md5.nim.c -o c_code/1_1/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulegraphs.nim.c -o c_code/1_1/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmagicsys.nim.c -o c_code/1_1/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mbitsets.nim.c -o c_code/1_1/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimsets.nim.c -o c_code/1_1/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msemfold.nim.c -o c_code/10_1/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodulepaths.nim.c -o c_code/1_1/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmdef.nim.c -o c_code/1_1/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msemdata.nim.c -o c_code/10_1/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlinter.nim.c -o c_code/1_1/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mnimfix@sprettybase.nim.c -o c_code/1_1/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlookups.nim.c -o c_code/1_1/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msemtypinst.nim.c -o c_code/10_1/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mparampatterns.nim.c -o c_code/1_1/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlowerings.nim.c -o c_code/1_1/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/10_1/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/10_1/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_xmltree.nim.c -o c_code/1_1/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_uri.nim.c -o c_code/1_1/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/stdlib_cgi.nim.c -o c_code/1_1/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtypesrenderer.nim.c -o c_code/1_1/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mdocgen.nim.c -o c_code/10_1/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msigmatch.nim.c -o c_code/10_1/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mimporter.nim.c -o c_code/1_1/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mprocfind.nim.c -o c_code/1_1/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mpragmas.nim.c -o c_code/10_1/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mreorder.nim.c -o c_code/10_1/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpasses.nim.c -o c_code/1_1/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msaturate.nim.c -o c_code/1_1/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mguards.nim.c -o c_code/1_1/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msighashes.nim.c -o c_code/10_1/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mliftdestructors.nim.c -o c_code/10_1/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msempass2.nim.c -o c_code/1_1/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgmeth.nim.c -o c_code/1_1/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@maliases.nim.c -o c_code/1_1/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpatterns.nim.c -o c_code/1_1/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mdfa.nim.c -o c_code/10_1/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@minjectdestructors.nim.c -o c_code/10_1/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mliftlocals.nim.c -o c_code/1_1/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mlambdalifting.nim.c -o c_code/1_1/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mclosureiters.nim.c -o c_code/1_1/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtransf.nim.c -o c_code/1_1/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmgen.nim.c -o c_code/1_1/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mvmdeps.nim.c -o c_code/10_1/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mvmmarshal.nim.c -o c_code/1_1/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mgorgeimpl.nim.c -o c_code/2_1/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmacrocacheimpl.nim.c -o c_code/1_1/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mevaltempl.nim.c -o c_code/10_1/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mvm.nim.c -o c_code/2_1/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemmacrosanity.nim.c -o c_code/1_1/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpluginsupport.nim.c -o c_code/1_1/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@slocals.nim.c -o c_code/1_1/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sitersgen.nim.c -o c_code/1_1/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mplugins@sactive.nim.c -o c_code/1_1/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mspawn.nim.c -o c_code/1_1/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@msemparallel.nim.c -o c_code/1_1/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@msem.nim.c -o c_code/10_1/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mccgutils.nim.c -o c_code/1_1/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mtreetab.nim.c -o c_code/1_1/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mndi.nim.c -o c_code/1_1/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mcgendata.nim.c -o c_code/1_1/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mccgmerge.nim.c -o c_code/10_1/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@menumtostr.nim.c -o c_code/1_1/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/stdlib_dynlib.nim.c -o c_code/2_1/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mcgen.nim.c -o c_code/10_1/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mnimconf.nim.c -o c_code/10_1/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mpassaux.nim.c -o c_code/1_1/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdepends.nim.c -o c_code/1_1/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmodules.nim.c -o c_code/1_1/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mjsgen.nim.c -o c_code/10_1/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mdocgen2.nim.c -o c_code/1_1/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_1/@mmain.nim.c -o c_code/1_1/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mscriptconfig.nim.c -o c_code/2_1/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_1/@mcmdlinehelper.nim.c -o c_code/10_1/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_1/@mnim.nim.c -o c_code/2_1/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_1/stdlib_assertions.nim.o \
c_code/1_1/stdlib_dollars.nim.o \
c_code/1_1/stdlib_formatfloat.nim.o \
c_code/10_1/stdlib_io.nim.o \
c_code/10_1/stdlib_system.nim.o \
c_code/2_1/stdlib_parseutils.nim.o \
c_code/2_1/stdlib_math.nim.o \
c_code/1_1/stdlib_algorithm.nim.o \
c_code/2_1/stdlib_unicode.nim.o \
c_code/10_1/stdlib_strutils.nim.o \
c_code/2_1/stdlib_pathnorm.nim.o \
c_code/10_1/stdlib_posix.nim.o \
c_code/2_1/stdlib_times.nim.o \
c_code/10_1/stdlib_os.nim.o \
c_code/1_1/stdlib_hashes.nim.o \
c_code/10_1/stdlib_strtabs.nim.o \
c_code/1_1/stdlib_sets.nim.o \
c_code/2_1/@mpathutils.nim.o \
c_code/2_1/@mropes.nim.o \
c_code/10_1/stdlib_tables.nim.o \
c_code/10_1/@mlineinfos.nim.o \
c_code/10_6/@mplatform.nim.o \
c_code/1_1/@mprefixmatches.nim.o \
c_code/10_1/stdlib_strformat.nim.o \
c_code/2_1/stdlib_terminal.nim.o \
c_code/10_1/@moptions.nim.o \
c_code/10_1/@mmsgs.nim.o \
c_code/1_1/@mcondsyms.nim.o \
c_code/2_1/stdlib_streams.nim.o \
c_code/2_1/stdlib_cpuinfo.nim.o \
c_code/10_1/stdlib_osproc.nim.o \
c_code/10_1/stdlib_sha1.nim.o \
c_code/2_1/stdlib_lexbase.nim.o \
c_code/10_1/stdlib_parsejson.nim.o \
c_code/10_1/stdlib_json.nim.o \
c_code/10_1/@mextccomp.nim.o \
c_code/1_1/@mwordrecg.nim.o \
c_code/10_1/@mnimblecmd.nim.o \
c_code/2_6/stdlib_parseopt.nim.o \
c_code/1_1/@mincremental.nim.o \
c_code/10_1/@mcommands.nim.o \
c_code/2_1/@mllstream.nim.o \
c_code/1_1/@midents.nim.o \
c_code/1_1/@midgen.nim.o \
c_code/1_1/@mint128.nim.o \
c_code/1_1/@mast.nim.o \
c_code/1_1/@mnimlexbase.nim.o \
c_code/10_1/@mlexer.nim.o \
c_code/10_1/@mparser.nim.o \
c_code/1_1/@mrenderer.nim.o \
c_code/1_1/@mfilters.nim.o \
c_code/1_1/@mfilter_tmpl.nim.o \
c_code/1_1/@msyntaxes.nim.o \
c_code/1_1/stdlib_intsets.nim.o \
c_code/10_1/@mrodutils.nim.o \
c_code/10_1/@mastalgo.nim.o \
c_code/1_1/@mtrees.nim.o \
c_code/10_1/@mtypes.nim.o \
c_code/1_1/@mbtrees.nim.o \
c_code/1_1/stdlib_md5.nim.o \
c_code/1_1/@mmodulegraphs.nim.o \
c_code/1_1/@mmagicsys.nim.o \
c_code/1_1/@mbitsets.nim.o \
c_code/1_1/@mnimsets.nim.o \
c_code/10_1/@msemfold.nim.o \
c_code/1_1/@mmodulepaths.nim.o \
c_code/1_1/@mvmdef.nim.o \
c_code/10_1/@msemdata.nim.o \
c_code/1_1/@mlinter.nim.o \
c_code/1_1/@mnimfix@sprettybase.nim.o \
c_code/1_1/@mlookups.nim.o \
c_code/10_1/@msemtypinst.nim.o \
c_code/1_1/@mparampatterns.nim.o \
c_code/1_1/@mlowerings.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/10_1/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_1/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/10_1/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_1/stdlib_xmltree.nim.o \
c_code/1_1/stdlib_uri.nim.o \
c_code/1_1/stdlib_cgi.nim.o \
c_code/1_1/@mtypesrenderer.nim.o \
c_code/10_1/@mdocgen.nim.o \
c_code/10_1/@msigmatch.nim.o \
c_code/1_1/@mimporter.nim.o \
c_code/1_1/@mprocfind.nim.o \
c_code/10_1/@mpragmas.nim.o \
c_code/10_1/@mreorder.nim.o \
c_code/1_1/@mpasses.nim.o \
c_code/1_1/@msaturate.nim.o \
c_code/1_1/@mguards.nim.o \
c_code/10_1/@msighashes.nim.o \
c_code/10_1/@mliftdestructors.nim.o \
c_code/1_1/@msempass2.nim.o \
c_code/1_1/@mcgmeth.nim.o \
c_code/1_1/@maliases.nim.o \
c_code/1_1/@mpatterns.nim.o \
c_code/10_1/@mdfa.nim.o \
c_code/10_1/@minjectdestructors.nim.o \
c_code/1_1/@mliftlocals.nim.o \
c_code/1_1/@mlambdalifting.nim.o \
c_code/1_1/@mclosureiters.nim.o \
c_code/1_1/@mtransf.nim.o \
c_code/1_1/@mvmgen.nim.o \
c_code/10_1/@mvmdeps.nim.o \
c_code/1_1/@mvmmarshal.nim.o \
c_code/2_1/@mgorgeimpl.nim.o \
c_code/1_1/@mmacrocacheimpl.nim.o \
c_code/10_1/@mevaltempl.nim.o \
c_code/2_1/@mvm.nim.o \
c_code/1_1/@msemmacrosanity.nim.o \
c_code/1_1/@mpluginsupport.nim.o \
c_code/1_1/@mplugins@slocals.nim.o \
c_code/1_1/@mplugins@sitersgen.nim.o \
c_code/1_1/@mplugins@sactive.nim.o \
c_code/1_1/@mspawn.nim.o \
c_code/1_1/@msemparallel.nim.o \
c_code/10_1/@msem.nim.o \
c_code/1_1/@mccgutils.nim.o \
c_code/1_1/@mtreetab.nim.o \
c_code/1_1/@mndi.nim.o \
c_code/1_1/@mcgendata.nim.o \
c_code/10_1/@mccgmerge.nim.o \
c_code/1_1/@menumtostr.nim.o \
c_code/2_1/stdlib_dynlib.nim.o \
c_code/10_1/@mcgen.nim.o \
c_code/10_1/@mnimconf.nim.o \
c_code/1_1/@mpassaux.nim.o \
c_code/1_1/@mdepends.nim.o \
c_code/1_1/@mmodules.nim.o \
c_code/10_1/@mjsgen.nim.o \
c_code/1_1/@mdocgen2.nim.o \
c_code/1_1/@mmain.nim.o \
c_code/2_1/@mscriptconfig.nim.o \
c_code/10_1/@mcmdlinehelper.nim.o \
c_code/2_1/@mnim.nim.o $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_io.nim.c -o c_code/10_16/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_system.nim.c -o c_code/10_16/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_strutils.nim.c -o c_code/10_16/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_posix.nim.c -o c_code/10_16/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_times.nim.c -o c_code/2_3/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_os.nim.c -o c_code/10_16/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_strtabs.nim.c -o c_code/10_16/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_tables.nim.c -o c_code/10_16/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mlineinfos.nim.c -o c_code/10_16/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mplatform.nim.c -o c_code/10_16/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_strformat.nim.c -o c_code/10_16/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@moptions.nim.c -o c_code/10_16/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mmsgs.nim.c -o c_code/10_16/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_cpuinfo.nim.c -o c_code/2_3/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_osproc.nim.c -o c_code/10_16/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sha1.nim.c -o c_code/1_2/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_parsejson.nim.c -o c_code/1_2/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_json.nim.c -o c_code/1_2/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mextccomp.nim.c -o c_code/10_16/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mnimblecmd.nim.c -o c_code/10_16/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcommands.nim.c -o c_code/1_2/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlexer.nim.c -o c_code/1_2/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparser.nim.c -o c_code/1_2/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrodutils.nim.c -o c_code/1_2/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mastalgo.nim.c -o c_code/10_16/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypes.nim.c -o c_code/1_2/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemfold.nim.c -o c_code/1_2/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemdata.nim.c -o c_code/1_2/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemtypinst.nim.c -o c_code/1_2/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/10_16/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mdocgen.nim.c -o c_code/10_16/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msigmatch.nim.c -o c_code/1_2/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mpragmas.nim.c -o c_code/10_16/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mreorder.nim.c -o c_code/1_2/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msighashes.nim.c -o c_code/1_2/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftdestructors.nim.c -o c_code/1_2/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdfa.nim.c -o c_code/1_2/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@minjectdestructors.nim.c -o c_code/1_2/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdeps.nim.c -o c_code/1_2/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mevaltempl.nim.c -o c_code/1_2/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mvm.nim.c -o c_code/2_3/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msem.nim.c -o c_code/1_2/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgmerge.nim.c -o c_code/1_2/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mcgen.nim.c -o c_code/10_16/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mnimconf.nim.c -o c_code/10_16/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mjsgen.nim.c -o c_code/10_16/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mscriptconfig.nim.c -o c_code/2_3/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/@mcmdlinehelper.nim.c -o c_code/10_16/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/10_16/stdlib_io.nim.o \
c_code/10_16/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/10_16/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/10_16/stdlib_posix.nim.o \
c_code/2_3/stdlib_times.nim.o \
c_code/10_16/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/10_16/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/10_16/stdlib_tables.nim.o \
c_code/10_16/@mlineinfos.nim.o \
c_code/10_16/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/10_16/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/10_16/@moptions.nim.o \
c_code/10_16/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/2_3/stdlib_cpuinfo.nim.o \
c_code/10_16/stdlib_osproc.nim.o \
c_code/1_2/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/1_2/stdlib_parsejson.nim.o \
c_code/1_2/stdlib_json.nim.o \
c_code/10_16/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/10_16/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/1_2/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/1_2/@mlexer.nim.o \
c_code/1_2/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/1_2/@mrodutils.nim.o \
c_code/10_16/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/1_2/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/1_2/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/1_2/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/1_2/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/10_16/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/10_16/@mdocgen.nim.o \
c_code/1_2/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/10_16/@mpragmas.nim.o \
c_code/1_2/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/1_2/@msighashes.nim.o \
c_code/1_2/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/1_2/@mdfa.nim.o \
c_code/1_2/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/1_2/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/1_2/@mevaltempl.nim.o \
c_code/2_3/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/1_2/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/1_2/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/10_16/@mcgen.nim.o \
c_code/10_16/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/10_16/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/2_3/@mscriptconfig.nim.o \
c_code/10_16/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
nintendoswitch)
  case $mycpu in
  i386)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  amd64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  ia64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  alpha)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  sparc64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  m68k)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mipsel)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  mips64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  powerpc64el)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  arm64)
    set -x
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_assertions.nim.c -o c_code/1_2/stdlib_assertions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_dollars.nim.c -o c_code/1_2/stdlib_dollars.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_formatfloat.nim.c -o c_code/1_2/stdlib_formatfloat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/10_16/stdlib_io.nim.c -o c_code/10_16/stdlib_io.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_system.nim.c -o c_code/11_16/stdlib_system.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_parseutils.nim.c -o c_code/2_2/stdlib_parseutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_math.nim.c -o c_code/2_2/stdlib_math.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_algorithm.nim.c -o c_code/1_2/stdlib_algorithm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_unicode.nim.c -o c_code/2_2/stdlib_unicode.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_strutils.nim.c -o c_code/11_16/stdlib_strutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_pathnorm.nim.c -o c_code/2_2/stdlib_pathnorm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_posix.nim.c -o c_code/11_16/stdlib_posix.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_times.nim.c -o c_code/11_16/stdlib_times.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_os.nim.c -o c_code/11_16/stdlib_os.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_hashes.nim.c -o c_code/1_2/stdlib_hashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_strtabs.nim.c -o c_code/2_2/stdlib_strtabs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_sets.nim.c -o c_code/1_2/stdlib_sets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mpathutils.nim.c -o c_code/2_2/@mpathutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mropes.nim.c -o c_code/2_2/@mropes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_tables.nim.c -o c_code/11_16/stdlib_tables.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mlineinfos.nim.c -o c_code/2_2/@mlineinfos.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mplatform.nim.c -o c_code/11_16/@mplatform.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprefixmatches.nim.c -o c_code/1_2/@mprefixmatches.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_strformat.nim.c -o c_code/2_2/stdlib_strformat.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_terminal.nim.c -o c_code/2_2/stdlib_terminal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@moptions.nim.c -o c_code/11_16/@moptions.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mmsgs.nim.c -o c_code/11_16/@mmsgs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcondsyms.nim.c -o c_code/1_2/@mcondsyms.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_streams.nim.c -o c_code/2_3/stdlib_streams.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_cpuinfo.nim.c -o c_code/11_16/stdlib_cpuinfo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_osproc.nim.c -o c_code/11_16/stdlib_osproc.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_sha1.nim.c -o c_code/11_16/stdlib_sha1.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_lexbase.nim.c -o c_code/2_2/stdlib_lexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_parsejson.nim.c -o c_code/11_16/stdlib_parsejson.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/stdlib_json.nim.c -o c_code/11_16/stdlib_json.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mextccomp.nim.c -o c_code/11_16/@mextccomp.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mwordrecg.nim.c -o c_code/1_2/@mwordrecg.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mnimblecmd.nim.c -o c_code/11_16/@mnimblecmd.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/stdlib_parseopt.nim.c -o c_code/2_3/stdlib_parseopt.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mincremental.nim.c -o c_code/1_2/@mincremental.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mcommands.nim.c -o c_code/11_16/@mcommands.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mllstream.nim.c -o c_code/2_2/@mllstream.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midents.nim.c -o c_code/1_2/@midents.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@midgen.nim.c -o c_code/1_2/@midgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mint128.nim.c -o c_code/1_2/@mint128.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mast.nim.c -o c_code/1_2/@mast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimlexbase.nim.c -o c_code/1_2/@mnimlexbase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mlexer.nim.c -o c_code/11_16/@mlexer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mparser.nim.c -o c_code/11_16/@mparser.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mrenderer.nim.c -o c_code/1_2/@mrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilters.nim.c -o c_code/1_2/@mfilters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mfilter_tmpl.nim.c -o c_code/1_2/@mfilter_tmpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msyntaxes.nim.c -o c_code/1_2/@msyntaxes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_intsets.nim.c -o c_code/1_2/stdlib_intsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mrodutils.nim.c -o c_code/11_16/@mrodutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mastalgo.nim.c -o c_code/11_16/@mastalgo.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtrees.nim.c -o c_code/1_2/@mtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mtypes.nim.c -o c_code/11_16/@mtypes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbtrees.nim.c -o c_code/1_2/@mbtrees.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_md5.nim.c -o c_code/1_2/stdlib_md5.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulegraphs.nim.c -o c_code/1_2/@mmodulegraphs.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmagicsys.nim.c -o c_code/1_2/@mmagicsys.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mbitsets.nim.c -o c_code/1_2/@mbitsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimsets.nim.c -o c_code/1_2/@mnimsets.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@msemfold.nim.c -o c_code/11_16/@msemfold.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodulepaths.nim.c -o c_code/1_2/@mmodulepaths.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmdef.nim.c -o c_code/1_2/@mvmdef.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@msemdata.nim.c -o c_code/11_16/@msemdata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlinter.nim.c -o c_code/1_2/@mlinter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mnimfix@sprettybase.nim.c -o c_code/1_2/@mnimfix@sprettybase.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlookups.nim.c -o c_code/1_2/@mlookups.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@msemtypinst.nim.c -o c_code/11_16/@msemtypinst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mparampatterns.nim.c -o c_code/1_2/@mparampatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlowerings.nim.c -o c_code/1_2/@mlowerings.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@m..@slib@spackages@sdocutils@srst.nim.c -o c_code/11_16/@m..@slib@spackages@sdocutils@srst.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.c -o c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@m..@slib@spackages@sdocutils@srstgen.nim.c -o c_code/11_16/@m..@slib@spackages@sdocutils@srstgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_xmltree.nim.c -o c_code/1_2/stdlib_xmltree.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_uri.nim.c -o c_code/1_2/stdlib_uri.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/stdlib_cgi.nim.c -o c_code/1_2/stdlib_cgi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtypesrenderer.nim.c -o c_code/1_2/@mtypesrenderer.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mdocgen.nim.c -o c_code/11_16/@mdocgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@msigmatch.nim.c -o c_code/11_16/@msigmatch.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mimporter.nim.c -o c_code/1_2/@mimporter.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mprocfind.nim.c -o c_code/1_2/@mprocfind.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mpragmas.nim.c -o c_code/11_16/@mpragmas.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mreorder.nim.c -o c_code/11_16/@mreorder.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpasses.nim.c -o c_code/1_2/@mpasses.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msaturate.nim.c -o c_code/1_2/@msaturate.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mguards.nim.c -o c_code/1_2/@mguards.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@msighashes.nim.c -o c_code/11_16/@msighashes.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mliftdestructors.nim.c -o c_code/11_16/@mliftdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msempass2.nim.c -o c_code/1_2/@msempass2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgmeth.nim.c -o c_code/1_2/@mcgmeth.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@maliases.nim.c -o c_code/1_2/@maliases.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpatterns.nim.c -o c_code/1_2/@mpatterns.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mdfa.nim.c -o c_code/11_16/@mdfa.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@minjectdestructors.nim.c -o c_code/11_16/@minjectdestructors.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mliftlocals.nim.c -o c_code/1_2/@mliftlocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mlambdalifting.nim.c -o c_code/1_2/@mlambdalifting.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mclosureiters.nim.c -o c_code/1_2/@mclosureiters.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtransf.nim.c -o c_code/1_2/@mtransf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmgen.nim.c -o c_code/1_2/@mvmgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mvmdeps.nim.c -o c_code/11_16/@mvmdeps.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mvmmarshal.nim.c -o c_code/1_2/@mvmmarshal.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_3/@mgorgeimpl.nim.c -o c_code/2_3/@mgorgeimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmacrocacheimpl.nim.c -o c_code/1_2/@mmacrocacheimpl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mevaltempl.nim.c -o c_code/11_16/@mevaltempl.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mvm.nim.c -o c_code/11_16/@mvm.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemmacrosanity.nim.c -o c_code/1_2/@msemmacrosanity.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpluginsupport.nim.c -o c_code/1_2/@mpluginsupport.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@slocals.nim.c -o c_code/1_2/@mplugins@slocals.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sitersgen.nim.c -o c_code/1_2/@mplugins@sitersgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mplugins@sactive.nim.c -o c_code/1_2/@mplugins@sactive.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mspawn.nim.c -o c_code/1_2/@mspawn.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@msemparallel.nim.c -o c_code/1_2/@msemparallel.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@msem.nim.c -o c_code/11_16/@msem.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mccgutils.nim.c -o c_code/1_2/@mccgutils.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mtreetab.nim.c -o c_code/1_2/@mtreetab.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mndi.nim.c -o c_code/1_2/@mndi.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mcgendata.nim.c -o c_code/1_2/@mcgendata.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mccgmerge.nim.c -o c_code/11_16/@mccgmerge.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@menumtostr.nim.c -o c_code/1_2/@menumtostr.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/stdlib_dynlib.nim.c -o c_code/2_2/stdlib_dynlib.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mcgen.nim.c -o c_code/3_2/@mcgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mnimconf.nim.c -o c_code/3_2/@mnimconf.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mpassaux.nim.c -o c_code/1_2/@mpassaux.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdepends.nim.c -o c_code/1_2/@mdepends.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmodules.nim.c -o c_code/1_2/@mmodules.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/3_2/@mjsgen.nim.c -o c_code/3_2/@mjsgen.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mdocgen2.nim.c -o c_code/1_2/@mdocgen2.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/1_2/@mmain.nim.c -o c_code/1_2/@mmain.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/11_16/@mscriptconfig.nim.c -o c_code/11_16/@mscriptconfig.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/9_2/@mcmdlinehelper.nim.c -o c_code/9_2/@mcmdlinehelper.nim.o
    $CC $COMP_FLAGS -Ic_code -c c_code/2_2/@mnim.nim.c -o c_code/2_2/@mnim.nim.o
    $CC -o $binDir/nim  \
c_code/1_2/stdlib_assertions.nim.o \
c_code/1_2/stdlib_dollars.nim.o \
c_code/1_2/stdlib_formatfloat.nim.o \
c_code/10_16/stdlib_io.nim.o \
c_code/11_16/stdlib_system.nim.o \
c_code/2_2/stdlib_parseutils.nim.o \
c_code/2_2/stdlib_math.nim.o \
c_code/1_2/stdlib_algorithm.nim.o \
c_code/2_2/stdlib_unicode.nim.o \
c_code/11_16/stdlib_strutils.nim.o \
c_code/2_2/stdlib_pathnorm.nim.o \
c_code/11_16/stdlib_posix.nim.o \
c_code/11_16/stdlib_times.nim.o \
c_code/11_16/stdlib_os.nim.o \
c_code/1_2/stdlib_hashes.nim.o \
c_code/2_2/stdlib_strtabs.nim.o \
c_code/1_2/stdlib_sets.nim.o \
c_code/2_2/@mpathutils.nim.o \
c_code/2_2/@mropes.nim.o \
c_code/11_16/stdlib_tables.nim.o \
c_code/2_2/@mlineinfos.nim.o \
c_code/11_16/@mplatform.nim.o \
c_code/1_2/@mprefixmatches.nim.o \
c_code/2_2/stdlib_strformat.nim.o \
c_code/2_2/stdlib_terminal.nim.o \
c_code/11_16/@moptions.nim.o \
c_code/11_16/@mmsgs.nim.o \
c_code/1_2/@mcondsyms.nim.o \
c_code/2_3/stdlib_streams.nim.o \
c_code/11_16/stdlib_cpuinfo.nim.o \
c_code/11_16/stdlib_osproc.nim.o \
c_code/11_16/stdlib_sha1.nim.o \
c_code/2_2/stdlib_lexbase.nim.o \
c_code/11_16/stdlib_parsejson.nim.o \
c_code/11_16/stdlib_json.nim.o \
c_code/11_16/@mextccomp.nim.o \
c_code/1_2/@mwordrecg.nim.o \
c_code/11_16/@mnimblecmd.nim.o \
c_code/2_3/stdlib_parseopt.nim.o \
c_code/1_2/@mincremental.nim.o \
c_code/11_16/@mcommands.nim.o \
c_code/2_2/@mllstream.nim.o \
c_code/1_2/@midents.nim.o \
c_code/1_2/@midgen.nim.o \
c_code/1_2/@mint128.nim.o \
c_code/1_2/@mast.nim.o \
c_code/1_2/@mnimlexbase.nim.o \
c_code/11_16/@mlexer.nim.o \
c_code/11_16/@mparser.nim.o \
c_code/1_2/@mrenderer.nim.o \
c_code/1_2/@mfilters.nim.o \
c_code/1_2/@mfilter_tmpl.nim.o \
c_code/1_2/@msyntaxes.nim.o \
c_code/1_2/stdlib_intsets.nim.o \
c_code/11_16/@mrodutils.nim.o \
c_code/11_16/@mastalgo.nim.o \
c_code/1_2/@mtrees.nim.o \
c_code/11_16/@mtypes.nim.o \
c_code/1_2/@mbtrees.nim.o \
c_code/1_2/stdlib_md5.nim.o \
c_code/1_2/@mmodulegraphs.nim.o \
c_code/1_2/@mmagicsys.nim.o \
c_code/1_2/@mbitsets.nim.o \
c_code/1_2/@mnimsets.nim.o \
c_code/11_16/@msemfold.nim.o \
c_code/1_2/@mmodulepaths.nim.o \
c_code/1_2/@mvmdef.nim.o \
c_code/11_16/@msemdata.nim.o \
c_code/1_2/@mlinter.nim.o \
c_code/1_2/@mnimfix@sprettybase.nim.o \
c_code/1_2/@mlookups.nim.o \
c_code/11_16/@msemtypinst.nim.o \
c_code/1_2/@mparampatterns.nim.o \
c_code/1_2/@mlowerings.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@srstast.nim.o \
c_code/11_16/@m..@slib@spackages@sdocutils@srst.nim.o \
c_code/1_2/@m..@slib@spackages@sdocutils@shighlite.nim.o \
c_code/11_16/@m..@slib@spackages@sdocutils@srstgen.nim.o \
c_code/1_2/stdlib_xmltree.nim.o \
c_code/1_2/stdlib_uri.nim.o \
c_code/1_2/stdlib_cgi.nim.o \
c_code/1_2/@mtypesrenderer.nim.o \
c_code/11_16/@mdocgen.nim.o \
c_code/11_16/@msigmatch.nim.o \
c_code/1_2/@mimporter.nim.o \
c_code/1_2/@mprocfind.nim.o \
c_code/11_16/@mpragmas.nim.o \
c_code/11_16/@mreorder.nim.o \
c_code/1_2/@mpasses.nim.o \
c_code/1_2/@msaturate.nim.o \
c_code/1_2/@mguards.nim.o \
c_code/11_16/@msighashes.nim.o \
c_code/11_16/@mliftdestructors.nim.o \
c_code/1_2/@msempass2.nim.o \
c_code/1_2/@mcgmeth.nim.o \
c_code/1_2/@maliases.nim.o \
c_code/1_2/@mpatterns.nim.o \
c_code/11_16/@mdfa.nim.o \
c_code/11_16/@minjectdestructors.nim.o \
c_code/1_2/@mliftlocals.nim.o \
c_code/1_2/@mlambdalifting.nim.o \
c_code/1_2/@mclosureiters.nim.o \
c_code/1_2/@mtransf.nim.o \
c_code/1_2/@mvmgen.nim.o \
c_code/11_16/@mvmdeps.nim.o \
c_code/1_2/@mvmmarshal.nim.o \
c_code/2_3/@mgorgeimpl.nim.o \
c_code/1_2/@mmacrocacheimpl.nim.o \
c_code/11_16/@mevaltempl.nim.o \
c_code/11_16/@mvm.nim.o \
c_code/1_2/@msemmacrosanity.nim.o \
c_code/1_2/@mpluginsupport.nim.o \
c_code/1_2/@mplugins@slocals.nim.o \
c_code/1_2/@mplugins@sitersgen.nim.o \
c_code/1_2/@mplugins@sactive.nim.o \
c_code/1_2/@mspawn.nim.o \
c_code/1_2/@msemparallel.nim.o \
c_code/11_16/@msem.nim.o \
c_code/1_2/@mccgutils.nim.o \
c_code/1_2/@mtreetab.nim.o \
c_code/1_2/@mndi.nim.o \
c_code/1_2/@mcgendata.nim.o \
c_code/11_16/@mccgmerge.nim.o \
c_code/1_2/@menumtostr.nim.o \
c_code/2_2/stdlib_dynlib.nim.o \
c_code/3_2/@mcgen.nim.o \
c_code/3_2/@mnimconf.nim.o \
c_code/1_2/@mpassaux.nim.o \
c_code/1_2/@mdepends.nim.o \
c_code/1_2/@mmodules.nim.o \
c_code/3_2/@mjsgen.nim.o \
c_code/1_2/@mdocgen2.nim.o \
c_code/1_2/@mmain.nim.o \
c_code/11_16/@mscriptconfig.nim.o \
c_code/9_2/@mcmdlinehelper.nim.o \
c_code/2_2/@mnim.nim.o $LINK_FLAGS
    ;;
  riscv64)
    set -x
    $CC -o $binDir/nim  $LINK_FLAGS
    ;;
  *)
    echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
    exit 1
    ;;
  esac
  ;;
*)
  echo 2>&1 "Error: no C code generated for: [$myos: $mycpu]"
  exit 1
  ;;
esac

: SUCCESS

