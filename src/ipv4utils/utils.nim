import std/[strutils, sequtils, bitops]

import ./types


proc matchAddress*(address: string): bool =
  ## Check if the address is valid
  var splittedAddress: seq[int]
  try:
    splittedAddress = address.split(".").map(parseInt)
  except ValueError:
    return false

  if splittedAddress.len != 4:
    return false
  for part in splittedAddress:
    if part < 0 or part > 255:
      return false

  return true


proc matchSubnet*(subnet: string): bool =
  ## Check if the subnetmask is valid
  if not matchAddress(subnet):
    return false

  var checkLater = false
  
  for subnetPart in subnet.split("."):
    if subnetPart notin @["0", "128", "192", "224", "240", "248", "252", "254", "255"]:
      return false
    if checkLater and subnetPart != "0":
      return false
    if subnetPart != "255":
      checkLater = true

  return true


proc notBits*(bits: int): int =
  ## Not a block of bits
  (bits and 0xFF) xor 0xFF


proc getNetworkAddress*(host: string, subnet: string): string =
  ## Calculate the network address from the host address and subnet mask
  ## host AND subnet mask = network
  let splittedHost = host.split(".").map(parseInt)
  let splittedSubnet = subnet.split(".").map(parseInt)

  for _, (addressPart, subnetPart) in zip(splittedHost, splittedSubnet):
    result &= $bitand(addressPart, subnetPart) & "."
  result = result[0..^2]


proc getBroadcastAddress*(network: string, subnet: string): string =
  ## Calculate the broadcast address from the network address and subnet mask
  ## network OR (NOT subnet mask) = broadcast
  let splittedNetwork = network.split(".").map(parseInt)
  let splittedSubnet = subnet.split(".").map(parseInt)

  for _, (addressPart, subnetPart) in zip(splittedNetwork, splittedSubnet):
    result &= $bitor(addressPart, notBits(subnetPart)) & "."
  result = result[0..^2]


proc parseSubnet*(subnetBits: int): string =
  ## Given the network bits, return a binary representation of the subnet mask
  if subnetBits < 0 or subnetBits > 32:
    raise newException(ValueError, "Invalid CIDR value for subnet mask")

  for i in 1 .. 32:
    if i <= subnetBits:
      result &= "1"
    else:
      result &= "0"
    if i mod 8 == 0:
      result &= "."
  
  result = result[0..^2]


proc binaryAddress*(address: string): string =
  ## Convert a decimal address to a binary address
  if not matchAddress(address):
    raise newException(InvalidAddress, "The IP Address you provided does not match the regex")

  for subnetPart in address.split(".").map(parseInt):
    result &= toBin(subnetPart, 8) & "."
  result = result[0..^2]
