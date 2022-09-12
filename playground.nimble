mode = ScriptMode.Verbose

version = "0.1.0"
author = "drchaos Team"
description = "Run tests and benchmarks"
license = "MIT"
srcDir = "."
skipDirs = @["tests", "benchmarks", "examples", "experiments"]

requires "nim >= 1.7.1"
requires "drchaos >= 0.1.8"

proc buildBinary(name: string, srcDir = "./", params = "", lang = "c") =
  if not dirExists "build":
    mkDir "build"
  var extra_params = params
  when compiles(commandLineParams):
    for param in commandLineParams:
      extra_params &= " " & param
  else:
    for i in 2..<paramCount():
      extra_params &= " " & paramStr(i)

  exec "nim " & lang & " --out:build/" & name & " " & extra_params & " " & srcDir & name & ".nim"

proc test(name: string, srcDir = "tests/", args = "", lang = "c") =
  buildBinary name, srcDir, "--cc:clang --mm:arc -d:danger --threads:off --panics:on -d:useMalloc -t:\"-fsanitize=fuzzer,address,undefined\" -l:\"-fsanitize=fuzzer,address,undefined\" -d:nosignalhandler --nomain:on -g -f "
  withDir("build/"):
    if not dirExists name & "_corpus":
      mkDir name & "_corpus"
    exec "./" & name & " -max_total_time=21600 " & name & "_corpus/ " & args

proc cov(name: string, srcDir = "tests/", target = "fuzzTarget", lang = "c") =
  buildBinary name, srcDir, "--cc:clang --mm:arc -d:danger --threads:off --panics:on -d:useMalloc -t:\"-fprofile-instr-generate -fcoverage-mapping\" -l:\"-fprofile-instr-generate -fcoverage-mapping\" -g -f --path:../../nim-drchaos/ -d:fuzzerStandalone"
  withDir("build/"):
    if not dirExists name & "_corpus":
      mkDir name & "_corpus"
    exec "LLVM_PROFILE_FILE=\"" & name & ".profraw\" ./" & name & " " & name & "_corpus/* "
    exec "llvm-profdata merge -sparse " & name & ".profraw -o " & name & ".profdata"
    exec "llvm-cov show -instr-profile=" & name & ".profdata -name=" & target & " ./" & name

task test, "Run all tests":
  test "test1", args = "-error_exitcode=0"

task cov, "Produce coverage reports":
  cov "test1"
