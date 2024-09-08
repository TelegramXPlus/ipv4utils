# Package

version       = "0.1.0"
author        = "EnteryName"
description   = "Simple library to work with IPv4 addresses. Made for fun for everyone."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.0.0"


task test, "Run tests":
  exec "nim c -r tests/test.nim"
