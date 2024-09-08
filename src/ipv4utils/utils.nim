import std/[strutils, sequtils, bitops]

import ./types


proc matchDecAddress*(address: string): bool =
  ## Check if the decimal address is valid
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


proc matchDecSubnet*(subnet: string): bool =
  ## Check if the decimal subnet mask is valid
  if not matchDecAddress(subnet):
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


proc matchBinAddress*(address: string): bool =
  ## Check if the binary address is valid
  let splittedAddress = address.split(".")
  if splittedAddress.len != 4:
    return false

  for part in splittedAddress:
    if part.len != 8:
      return false
    for bit in part:
      if bit notin @['1', '0']:
        return false

  return true


proc matchBinSubnet*(subnet: string): bool =
  ## Check if the binary subnet mask is valid
  if not matchBinAddress(subnet):
    return false
  
  var checkLater = false
  for bit in subnet.replace(".",  ""):
    if bit == '0':
      checkLater = true
    if checkLater and bit == '1':
      return false

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


proc toBinAddress*(address: string): string =
  ## Convert a decimal address to a binary address
  if not matchDecAddress(address):
    raise newException(InvalidAddress, "The IP Address you provided is invalid")

  for part in address.split(".").map(parseInt):
    result &= toBin(part, 8) & "."
  result = result[0..^2]


proc toDecAddress*(address: string): string =
  ## Convert a binary address to a decimal address
  if not matchBinAddress(address):
    raise newException(InvalidAddress, "The IP Address you provided is invalid")

  for part in address.split("."):
    result &= $fromBin[int](part) & "."
  result = result[0..^2]


proc toBinSubnet*(subnet: string): string =
  ## Convert a decimal subnet mask to a binary subnet mask
  if not matchDecSubnet(subnet):
    raise newException(InvalidAddress, "The Subnet mask you provided is invalid")

  return subnet.toBinAddress


proc toDecSubnet*(subnet: string): string =
  ## Convert a binary subnet mask to a decimal subnet mask
  if not matchBinSubnet(subnet):
    raise newException(InvalidAddress, "The Subnet mask you provided is invalid")

  return subnet.toDecAddress
