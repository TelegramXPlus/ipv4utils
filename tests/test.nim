import unittest
import ipv4utils


suite "ipv4utils":
  let
    ip1 = newIPv4Address("192.168.0.1", "255.255.255.0")
    ip2 = newIPv4Address("192.168.0.2", "255.255.255.0")

  test "Host address":
    check ip1.address == "192.168.0.1"
    check ip2.address == "192.168.0.2"

  test "Netmask":
    check ip1.subnet == "255.255.255.0"
    check ip2.subnet == "255.255.255.0"

  test "Network address":
    check ip1.network == "192.168.0.0"
    check ip2.network == "192.168.0.0"

  test "Broadcast address":
    check ip1.broadcast == "192.168.0.255"
    check ip2.broadcast == "192.168.0.255"

  test "First host address":
    check ip1.firstHostAddress == "192.168.0.1"
    check ip2.firstHostAddress == "192.168.0.1"

  test "Last host address":
    check ip1.lastHostAddress == "192.168.0.254"
    check ip2.lastHostAddress == "192.168.0.254"

  test "Wildcard mask":
    check ip1.wildcardMask == "0.0.0.255"
    check ip2.wildcardMask == "0.0.0.255"

  test "CIDR notation":
    check ip1.cidrMask == 24
    check ip2.cidrMask == 24
    check ip1.cidrMaskStr == "/24"
    check ip2.cidrMaskStr == "/24"

  test "Commuication":
    check ip1.canCommunicate(ip2) == true

  test "Host Convertion":
    check "192.168.1.1".toBinAddress == "11000000.10101000.00000001.00000001"
    check "11000000.10101000.00000001.00000001".toDecAddress == "192.168.1.1"

  test "Subnet Convertion":
    check "255.255.255.0".toBinSubnet == "11111111.11111111.11111111.00000000"
    check "11111111.11111111.11111111.00000000".toDecSubnet == "255.255.255.0"
    check parseSubnet(24) == "11111111.11111111.11111111.00000000"
