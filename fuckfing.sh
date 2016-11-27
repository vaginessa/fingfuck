echo 'Evita que nos encuentren en la red con la app Fing, que usa ARQ'

# Ademas de bloquear el trafico ARQ , usa iptables para aislar nuestro pc del resto de dispositivos en la red

ifconfig eth0 down

macchanger --mac 2C:0E:3D:......  eth0

	
ifconfig eth0 up



ROUTERIP="192.168.1.1"
GATEWAYIP="192.168.1.103"
MACROUTER="00:26:5a:-------"

# ASL 26555     "d0:ae:ec------"
# RTL 871 OBSERVA "f8:fb:56:-----" Wps Pin: 12345670 


iptables -F

#iptables --policy INPUT DROP

iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -s $ROUTERIP -j ACCEPT
iptables -A INPUT -s $GATEWAYIP -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -j DROP

iptables -A OUTPUT -d $ROUTERIP -j ACCEPT
iptables -A OUTPUT -d $GATEWAYIP -j ACCEPT
iptables -A OUTPUT -d 192.168.1.0/24 -j DROP

iptables -A FORWARD -j DROP


# Reject spoofed packets
# These adresses are mostly used for LAN's, so if these would come to a WAN-only server, drop them.
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP

#Multicast-adresses.
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -d 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -d 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -d 0.0.0.0/8 -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255 -j DROP

# Drop all invalid packets
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP


# Drop excessive RST packets to avoid smurf attacks
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# Don't allow pings through
iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -j REJECT
iptables -A OUTPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j REJECT

# only allow our router to exchange ARP packets.

arptables --flush
arptables -P INPUT DROP
arptables -A INPUT --source-mac $MACROUTER -j ACCEPT


#If we want to allow traffic again:

#arptables -P INPUT ACCEPT

#arptables --flush

#Flushing the full ARP cache can be done with ip utility:

#ip -s neighbour flush all


