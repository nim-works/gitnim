/* Generated by the Nim Compiler v0.1.0-dev.21221 */
var framePtr = null;
var excHandler = 0;
var lastJSError = null;

function system_33557940() {
    excHandler = 0;
    lastJSError = null;
    if (!Math.trunc) {
  Math.trunc = function(v) {
    v = +v;
    if (!isFinite(v)) return v;
    return (v - v % 1) || (v < 0 ? -0 : v === 0 ? v : 0);
  };
}


  
}

function assertions_234881120() {
  var F = {procname: "module assertions", prev: framePtr, filename: "/home/adavidoff/.asdf/installs/nimskull/0.1.0-dev.21221/lib/system/assertions.nim", line: 0};
  framePtr = F;
  framePtr = F.prev;

  
}

function io_486539791() {
  var F = {procname: "module io", prev: framePtr, filename: "/home/adavidoff/.asdf/installs/nimskull/0.1.0-dev.21221/lib/system/io.nim", line: 0};
  framePtr = F;
  framePtr = F.prev;

  
}

function macros_503318123() {
  var F = {procname: "module macros", prev: framePtr, filename: "/home/adavidoff/.asdf/installs/nimskull/0.1.0-dev.21221/lib/core/macros.nim", line: 0};
  framePtr = F;
  framePtr = F.prev;

  
}
system_33557940();
assertions_234881120();
io_486539791();
macros_503318123();