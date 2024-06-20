import ipv4utils/[types, utils, parsing]

export utils.binaryAddress, utils.parseSubnet
export parsing
export types.IPv4Address, types.InvalidAddress, types.address, types.subnet, types.network, types.broadcast


proc newIPv4Address*(host: string, subnet: string): IPv4Address =
  ## Create a new instance of IPAddress
  if not (matchAddress(host) and matchSubnet(subnet)):
    raise newException(InvalidAddress, "The IP Address/Subnetmask you provided does not match the regex")

  let network = getNetworkAddress(host, subnet)
  let broadcast = getBroadcastAddress(network, subnet)

  return newIPv4Address(host, subnet, network, broadcast)


when isMainModule:
  let ip1 = newIPv4Address("192.168.0.1", "255.255.255.0")
  let ip2 = newIPv4Address("192.168.0.2", "255.255.255.0")

  echo "Host address: ", ip1.address
  echo "Subnet mask: ", ip1.subnet
  echo "Network address: ", ip1.network
  echo "Broadcast address: ", ip1.broadcast
  echo "First host: ", ip1.firstHostAddress()
  echo "Last host: ", ip1.lastHostAddress()
  echo "Wildcard mask: ", ip1.wildcardMask()
  echo "CIDR notation: ", ip1.cidrMask()
  echo "CIDR notation (str): ", ip1.cidrMaskStr()
  echo "Can ip1 communicate with ip2: ", ip1.canCommunicate(ip2)

  echo "\n--------\n"

  echo "Binary host: ", binaryAddress("192.168.1.1")
  echo "Binary subnet: ", parseSubnet(32)
