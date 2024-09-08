# ipv4utils

Simple library for ipv4 parsing

## Installation

```
nimble install ipv4utils
```

or

```
nimle install https://github.com/TelegramXPlus/ipv4utils
```

## Usage

All the things covered here can be seen in `tests/test.nim`

> Create an instance

```nim
import ipv4utils

let ip = newIPv4Address("192.168.0.1", "255.255.255.0")
```

> From now on you can access multiple attributes of the `IPv4Address` object

```nim
ip.address   # get the address
ip.subnet    # get the subnet mask
ip.network   # get the network address (192.168.0.0)
ip.broadcast # get the broadcast address (192.168.0.255)

ip.firstHostAddress # 12.168.0.1
ip.lastHostAddress  # 192.168.0.254

ip.wildCardMask # complement of subnet mask
ip.cidrMask     # CIDR value as an int
ip.cidrMaskStr  # CIDR value with appending /

ip.canCommunicate(otherIP) # check whether two adddresses are on the same network
```

> And some other utilities

```nim
"192.168.1.1".toBinAddress                         # decimal to binary
"11111111.11111111.11111111.11111101".toDecAddress # binary to decimal
"255.255.255.0".toBinSubnet                        # decimal subnet to binary subnet
"11111111.11111111.11111111.11111111".toDecSubnet  # binary subnet to decimal subnet
```
