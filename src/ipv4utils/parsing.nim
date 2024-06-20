import std/[strutils, sequtils]

import ./types
import ./utils


proc canCommunicate*(self: IPv4Address, other: IPv4Address): bool =
  ## Check whether two addresses can communicate
  return self.network == other.network and self.broadcast == other.broadcast and self.subnet == other.subnet


proc wildcardMask*(self: IPv4Address): string =
  ## Get the wildcard of the subnet mask
  ## The wildcard mask is the not version of the subnet mask
  for subnetPart in self.subnet.split(".").map(parseInt):
    result &= $notBits(subnetPart) & "."
  result = result[0..^2]


proc cidrMask*(self: IPv4Address): int =
  ## Get the CIDR notation of the subnet mask
  for subnetPart in self.subnet.split(".").map(parseInt):
    result += toBin(subnetPart, 8).count("1")


proc cidrMaskStr*(self: IPv4Address): string =
  ## Get the CIDR subnet mask as a string
  result = "/" & $self.cidrMask()


proc firstHostAddress*(self: IPv4Address): string =
  ## Calculate the first host address from the network address
  ## network + 1
  var splittedNetwork = self.network.split(".").map(parseInt)
  splittedNetwork[3] += 1
  result = splittedNetwork.join(".")


proc lastHostAddress*(self: IPv4Address): string =
  ## Calculate the last host address from the broadcast address
  ## broadcast - 1
  var splittedBroadcast = self.broadcast.split(".").map(parseInt)
  splittedBroadcast[3] -= 1
  result = splittedBroadcast.join(".")
