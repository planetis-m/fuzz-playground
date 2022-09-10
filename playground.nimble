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
    exec "./" & name & " -max_total_time=3600 " & args

task test, "Run all tests":
  test "test1", args = "-error_exitcode=0"
