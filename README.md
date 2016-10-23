# hmac-sha2-256-128

OK, so you're trying to get an old Cisco router to talk to your crappy IPsec VPN
(manual keyed most likely). For whatever reason, you've chosen to manually key
the beast — perhaps you hate yourself.

Let's say after 12 hours debug and wireshark hell you happen to notice this
would all work if only the effin `esp-sha256-hmac` would work … apparently the
loonix end is malfunctioning, what could be the problem??

Hrm, the IV is too short. What gives?

It seems loonix has mixed feelings about `RFC4868`. At one point circa 2.6.x they
switched the IV length to 128 bits, but then someone reverted it back to 96 bits
in a bug fix — prefering the 2001 era `draft-ietf-ipsec-ciph-sha-256-00` as
reference … you know, for the compatiblity.

Why they couldn't just add both algorithms as `hmac-sha2-256-96` and
`hmac-sha2-256-128` (as wireshark has done) is beyond me.

Whatever … this is my fix. Note that I do not know if this is a safe way to set
up a VPN, nor do I have any idea what safe is or how you want to define it.

-Paul

# INSTALL

If your sources happen to be located where mine are (archlinux packages `linux-ec2`
and `linux-ec2-headers`), then this will probably work fine:

`make install`

Then either reboot or try your luck with my shitty `./rmmod-xfrm_algo.sh` script
to remove the old module before you rekey your network and restart all the
tunnels.

# VPN Config BS

## ipsec.conf
```
add 10.1.2.3 123.4.5.6 esp 12345
    -E aes-cbc 0xffffffffffffffffffffffffffffffff
    -A hmac-sha256 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
add 123.4.5.6 10.1.2.3 esp 54321
    -E aes-cbc 0xffffffffffffffffffffffffffffffff
    -A hmac-sha256 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

spdadd 10.1.2.3 123.4.5.6 gre 10.254.254.4 -P out ipsec esp/transport//require;
spdadd 123.4.5.6 10.1.2.3 gre 10.254.254.4 -P in  ipsec esp/transport//require;

```

## Cisco
```
crypto pki token default removal timeout 0
crypto ipsec transform-set shitty-vpn esp-aes esp-sha256-hmac 
 mode transport require
crypto map shitty-vpn local-address GigabitEthernet0/0
crypto map shitty-vpn 10 ipsec-manual 
 set peer 456.7.8.9
 set session-key inbound esp 12345 cipher ffffffffffffffffffffffffffffffff authenticator ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
 set session-key outbound esp 54321 cipher ffffffffffffffffffffffffffffffff authenticator ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
 set transform-set shitty-vpn 
 match address shitty-vpn
int gi0/0
 crypto map shitty-vpn
interface Tunnel0
 description shitty-vpn tunnel
 ip address 10.254.254.6 255.255.255.252
 no ip redirects
 ip mtu 1400
 delay 1000
 tunnel source GigabitEthernet0/0
 tunnel destination 456.7.8.9
 tunnel key 184483332

```
