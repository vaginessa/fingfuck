# Desbloquea red , limpia reglas iptables, restaura ARP y las MAC originales

sudo iptables -F
sudo arptables -P INPUT ACCEPT
sudo arptables --flush

ifconfig eth0 down
macchanger -p  eth0
ifconfig eth0 up


ifconfig wlan0 down
macchanger -p  wlan0
ifconfig wlan0 up
