#! /bin/sh
# Generated by niminst

if [ $# -eq 1 ] ; then
  case $1 in
    "--help"|"-h"|"help"|"h")
      echo "Nim deinstallation script"
      echo "Usage: [sudo] sh deinstall.sh DIR"
      echo "Where DIR may be:"
      echo "  /usr/bin"
      echo "  /usr/local/bin"
      echo "  /opt"
      echo "  <some other dir> (treated similar '/opt')"
      exit 1
      ;;
    "/usr/bin")
      bindir=/usr/bin
      configdir=/etc/nim
      libdir=/usr/lib/nim
      docdir=/usr/share/nim/doc
      datadir=/usr/share/nim/data
      nimbleDir="/opt/nimble/pkgs/compiler-1.5.1"
      ;;
    "/usr/local/bin")
      bindir=/usr/local/bin
      configdir=/etc/nim
      libdir=/usr/local/lib/nim
      docdir=/usr/local/share/nim/doc
      datadir=/usr/local/share/nim/data
      nimbleDir="/opt/nimble/pkgs/compiler-1.5.1"
      ;;
    "/opt")
      bindir="/opt/nim/bin"
      configdir="/opt/nim/config"
      libdir="/opt/nim/lib"
      docdir="/opt/nim/doc"
      datadir="/opt/nim/data"
      nimbleDir="/opt/nimble/pkgs/compiler-1.5.1"
      ;;
    *)
      bindir="$1/nim/bin"
      configdir="$1/nim/config"
      libdir="$1/nim/lib"
      docdir="$1/nim/doc"
      datadir="$1/nim/data"
      nimbleDir="$1/nim"
      ;;
  esac
  echo "removing files..."

  rm -f $bindir/nim
  rm -f $configdir/nim.cfg
  rm -f $configdir/nimdoc.cfg
  rm -f $configdir/nimdoc.tex.cfg
  rm -f $configdir/rename.rules.cfg
  rm -f $configdir/config.nims
  rm -rf $docdir
  rm -rf $datadir
  rm -rf $libdir

    rm -f $nimbleDir/compiler/aliases.nim
    rm -f $nimbleDir/compiler/ast.nim
    rm -f $nimbleDir/compiler/astalgo.nim
    rm -f $nimbleDir/compiler/bitsets.nim
    rm -f $nimbleDir/compiler/btrees.nim
    rm -f $nimbleDir/compiler/canonicalizer_unused.nim
    rm -f $nimbleDir/compiler/ccgcalls.nim
    rm -f $nimbleDir/compiler/ccgexprs.nim
    rm -f $nimbleDir/compiler/ccgliterals.nim
    rm -f $nimbleDir/compiler/ccgmerge.nim
    rm -f $nimbleDir/compiler/ccgreset.nim
    rm -f $nimbleDir/compiler/ccgstmts.nim
    rm -f $nimbleDir/compiler/ccgthreadvars.nim
    rm -f $nimbleDir/compiler/ccgtrav.nim
    rm -f $nimbleDir/compiler/ccgtypes.nim
    rm -f $nimbleDir/compiler/ccgutils.nim
    rm -f $nimbleDir/compiler/cgen.nim
    rm -f $nimbleDir/compiler/cgendata.nim
    rm -f $nimbleDir/compiler/cgmeth.nim
    rm -f $nimbleDir/compiler/closureiters.nim
    rm -f $nimbleDir/compiler/cmdlinehelper.nim
    rm -f $nimbleDir/compiler/commands.nim
    rm -f $nimbleDir/compiler/condsyms.nim
    rm -f $nimbleDir/compiler/debuginfo.nim
    rm -f $nimbleDir/compiler/depends.nim
    rm -f $nimbleDir/compiler/dfa.nim
    rm -f $nimbleDir/compiler/docgen.nim
    rm -f $nimbleDir/compiler/docgen2.nim
    rm -f $nimbleDir/compiler/enumtostr.nim
    rm -f $nimbleDir/compiler/evalffi.nim
    rm -f $nimbleDir/compiler/evaltempl.nim
    rm -f $nimbleDir/compiler/extccomp.nim
    rm -f $nimbleDir/compiler/filter_tmpl.nim
    rm -f $nimbleDir/compiler/filters.nim
    rm -f $nimbleDir/compiler/gorgeimpl.nim
    rm -f $nimbleDir/compiler/guards.nim
    rm -f $nimbleDir/compiler/hlo.nim
    rm -f $nimbleDir/compiler/ic/to_packed_ast.nim
    rm -f $nimbleDir/compiler/ic/packed_ast.nim
    rm -f $nimbleDir/compiler/ic/rodfiles.nim
    rm -f $nimbleDir/compiler/ic/bitabs.nim
    rm -f $nimbleDir/compiler/ic/design.rst
    rm -f $nimbleDir/compiler/idents.nim
    rm -f $nimbleDir/compiler/importer.nim
    rm -f $nimbleDir/compiler/index.nim
    rm -f $nimbleDir/compiler/injectdestructors.nim
    rm -f $nimbleDir/compiler/installer.ini
    rm -f $nimbleDir/compiler/int128.nim
    rm -f $nimbleDir/compiler/isolation_check.nim
    rm -f $nimbleDir/compiler/jsgen.nim
    rm -f $nimbleDir/compiler/jstypes.nim
    rm -f $nimbleDir/compiler/lambdalifting.nim
    rm -f $nimbleDir/compiler/layouter.nim
    rm -f $nimbleDir/compiler/lexer.nim
    rm -f $nimbleDir/compiler/liftdestructors.nim
    rm -f $nimbleDir/compiler/liftlocals.nim
    rm -f $nimbleDir/compiler/lineinfos.nim
    rm -f $nimbleDir/compiler/linter.nim
    rm -f $nimbleDir/compiler/llstream.nim
    rm -f $nimbleDir/compiler/lookups.nim
    rm -f $nimbleDir/compiler/lowerings.nim
    rm -f $nimbleDir/compiler/macrocacheimpl.nim
    rm -f $nimbleDir/compiler/magicsys.nim
    rm -f $nimbleDir/compiler/main.nim
    rm -f $nimbleDir/compiler/mapping.txt
    rm -f $nimbleDir/compiler/modulegraphs.nim
    rm -f $nimbleDir/compiler/modulepaths.nim
    rm -f $nimbleDir/compiler/modules.nim
    rm -f $nimbleDir/compiler/msgs.nim
    rm -f $nimbleDir/compiler/ndi.nim
    rm -f $nimbleDir/compiler/nilcheck.nim
    rm -f $nimbleDir/compiler/nim.cfg
    rm -f $nimbleDir/compiler/nim.nim
    rm -f $nimbleDir/compiler/nimblecmd.nim
    rm -f $nimbleDir/compiler/nimconf.nim
    rm -f $nimbleDir/compiler/nimeval.nim
    rm -f $nimbleDir/compiler/nimfix/prettybase.nim
    rm -f $nimbleDir/compiler/nimfix/nimfix.nim.cfg
    rm -f $nimbleDir/compiler/nimfix/nimfix.nim
    rm -f $nimbleDir/compiler/nimlexbase.nim
    rm -f $nimbleDir/compiler/nimpaths.nim
    rm -f $nimbleDir/compiler/nimsets.nim
    rm -f $nimbleDir/compiler/nodejs.nim
    rm -f $nimbleDir/compiler/nversion.nim
    rm -f $nimbleDir/compiler/optimizer.nim
    rm -f $nimbleDir/compiler/options.nim
    rm -f $nimbleDir/compiler/packagehandling.nim
    rm -f $nimbleDir/compiler/parampatterns.nim
    rm -f $nimbleDir/compiler/parser.nim
    rm -f $nimbleDir/compiler/passaux.nim
    rm -f $nimbleDir/compiler/passes.nim
    rm -f $nimbleDir/compiler/pathutils.nim
    rm -f $nimbleDir/compiler/patterns.nim
    rm -f $nimbleDir/compiler/platform.nim
    rm -f $nimbleDir/compiler/plugins/locals.nim
    rm -f $nimbleDir/compiler/plugins/itersgen.nim
    rm -f $nimbleDir/compiler/plugins/active.nim
    rm -f $nimbleDir/compiler/pluginsupport.nim
    rm -f $nimbleDir/compiler/pragmas.nim
    rm -f $nimbleDir/compiler/prefixmatches.nim
    rm -f $nimbleDir/compiler/procfind.nim
    rm -f $nimbleDir/compiler/readme.md
    rm -f $nimbleDir/compiler/renderer.nim
    rm -f $nimbleDir/compiler/renderverbatim.nim
    rm -f $nimbleDir/compiler/reorder.nim
    rm -f $nimbleDir/compiler/rodutils.nim
    rm -f $nimbleDir/compiler/ropes.nim
    rm -f $nimbleDir/compiler/saturate.nim
    rm -f $nimbleDir/compiler/scriptconfig.nim
    rm -f $nimbleDir/compiler/sem.nim
    rm -f $nimbleDir/compiler/semcall.nim
    rm -f $nimbleDir/compiler/semdata.nim
    rm -f $nimbleDir/compiler/semexprs.nim
    rm -f $nimbleDir/compiler/semfields.nim
    rm -f $nimbleDir/compiler/semfold.nim
    rm -f $nimbleDir/compiler/semgnrc.nim
    rm -f $nimbleDir/compiler/seminst.nim
    rm -f $nimbleDir/compiler/semmacrosanity.nim
    rm -f $nimbleDir/compiler/semmagic.nim
    rm -f $nimbleDir/compiler/semobjconstr.nim
    rm -f $nimbleDir/compiler/semparallel.nim
    rm -f $nimbleDir/compiler/sempass2.nim
    rm -f $nimbleDir/compiler/semstmts.nim
    rm -f $nimbleDir/compiler/semtempl.nim
    rm -f $nimbleDir/compiler/semtypes.nim
    rm -f $nimbleDir/compiler/semtypinst.nim
    rm -f $nimbleDir/compiler/sighashes.nim
    rm -f $nimbleDir/compiler/sigmatch.nim
    rm -f $nimbleDir/compiler/sinkparameter_inference.nim
    rm -f $nimbleDir/compiler/sizealignoffsetimpl.nim
    rm -f $nimbleDir/compiler/sourcemap.nim
    rm -f $nimbleDir/compiler/spawn.nim
    rm -f $nimbleDir/compiler/strutils2.nim
    rm -f $nimbleDir/compiler/suggest.nim
    rm -f $nimbleDir/compiler/syntaxes.nim
    rm -f $nimbleDir/compiler/tccgen.nim
    rm -f $nimbleDir/compiler/transf.nim
    rm -f $nimbleDir/compiler/trees.nim
    rm -f $nimbleDir/compiler/treetab.nim
    rm -f $nimbleDir/compiler/typeallowed.nim
    rm -f $nimbleDir/compiler/types.nim
    rm -f $nimbleDir/compiler/typesrenderer.nim
    rm -f $nimbleDir/compiler/varpartitions.nim
    rm -f $nimbleDir/compiler/vm.nim
    rm -f $nimbleDir/compiler/vmconv.nim
    rm -f $nimbleDir/compiler/vmdef.nim
    rm -f $nimbleDir/compiler/vmdeps.nim
    rm -f $nimbleDir/compiler/vmgen.nim
    rm -f $nimbleDir/compiler/vmhooks.nim
    rm -f $nimbleDir/compiler/vmmarshal.nim
    rm -f $nimbleDir/compiler/vmops.nim
    rm -f $nimbleDir/compiler/vmprofiler.nim
    rm -f $nimbleDir/compiler/wordrecg.nim
    rm -f $nimbleDir/doc/basicopt.txt
    rm -f $nimbleDir/doc/advopt.txt
    rm -f $nimbleDir/doc/nimdoc.css
  rm -f $nimbleDir/compiler.nimble

  echo "deinstallation successful"
else
  echo "Nim deinstallation script"
  echo "Usage: [sudo] sh deinstall.sh DIR"
  echo "Where DIR may be:"
  echo "  /usr/bin"
  echo "  /usr/local/bin"
  echo "  /opt"
  echo "  <some other dir> (treated similar '/opt')"
  exit 1
fi

