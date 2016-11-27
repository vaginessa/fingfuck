#!/bin/bash
# Crea un android device aleatorio , crea el fichero /etc/hostname con él y lo actualiza en el fichero /etc/host
# Consigue que el pc responda como si fuera un movil android, mas o menos XDDD

function randomid(){
hexchars="0123456789abcdef"
end=$( for i in {1..14} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/\1/g' )
MAC=00$end
}


randomid

echo "android-"$MAC

cp /etc/hosts.template /etc/hosts
sed -i 's/HOST/'android-$MAC'/g' /etc/hosts

# Create a new hostname file
echo "android-$MAC" > /etc/hostname
