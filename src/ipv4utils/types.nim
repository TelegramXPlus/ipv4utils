type
  IPv4Address* = object
    address: string
    subnet: string
    network: string
    broadcast: string

  InvalidAddress* = object of CatchableError


proc address*(self: IPv4Address): string =
  self.address


proc subnet*(self: IPv4Address): string =
  self.subnet


proc network*(self: IPv4Address): string =
  self.network


proc broadcast*(self: IPv4Address): string =
  self.broadcast


proc newIPv4Address*(host, subnet, network, broadcast: string): IPv4Address =
  return IPv4Address(address: host, subnet: subnet, network: network, broadcast: broadcast)
