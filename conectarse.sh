#!/bin/bash

#Este es un script para automatizar e implementar una "Intefaz" para conectarse a una red a traves de distintos metodos
echo "Bienvenido al script para agilizar la conexion a una red"

#Mostrar interfaces de red
echo "Interfaces de red detectadas:" 
ip a

#Cambiar estado de interfaz (up, down)
echo "Interfaz que desea cambiar su estado:"
read -r intrface
echo "Desea activar (up) o desactivar (down)"
read -r estado
sudo ip link set "$intrface" "$estado"
echo "interfaz $intrface establecida a $estado con exito!"
if [[ "$estado" == "down" ]]; then
	exit 1
fi

echo "Que accion desea realizar?"
echo "1 - conectarse mediante Wi-Fi o ethernet"
echo "2 - configurar red manualmente"
read -r accion
if [[ "$accion" == "1" ]]; then
echo "###################################"
echo "Iniciar Conexion a una Red"
echo "###################################"

echo "Seleccione la forma en la que desea conectarse"
echo "Wi-Fi = w"
echo "Cable = c"
read -r tipo
if [[ "$tipo" == "w" ]]; then
	echo "Redes disponibles"
	sudo iwlist "$intrface" scan | grep 'ESSID'
	echo "ingrese el ISSD (nombre) de la red Wi-Fi a la que desee conectarse"
	read -r  ssid
	echo "Ingrese la contraseña de la red (o deje en blanco y presione enter en caso de no tener)"
	read -r contra
	if [ -n "$password" ]; then
		wpa_passphrase "$ssid" "$contra" | sudo tee /usr/sbin/confwifi.conf
		echo "configurando..."
		sleep 2
		echo "comparando contraseñas..."
		echo "finalizando procesos..."
		wpa_supplicant -B -i "$intrface" -c /usr/sbin/confwifi.conf
	else
		iw dev "$intrface" connect "$ssid"
	fi
	echo "Espere mientras se termina de configurar la conexion..."
	echo "Conexion establecida. Configurando direccion ip..."
	dhclient "$intrface"
elif [[ "$tipo" == "c" ]]; then
	echo "Escriba el nombre de la interfaz de red cableada a encender:"
	ip a
	read -r intrface2
	echo "Conectando mediante red cableada..."
	sudo ip link set "$intrface2" up
	dhclient "intrface2" 
fi
exit 0
	
elif [[ "$accion" == "2" ]]; then
echo "##################################"
echo "Configuracion manual"
echo "##################################"
echo "Desea conectarse de forma estatica (e) o dinamica (d)?"
read -r conex
if [[ "$conex" == "e" ]]; then
	echo "configurando conexion estatica..."
	ip addr show
	echo "escriba la direccion ip:"
	read -r ip
	echo "escriba la mascara de red."
	read -r mascara
	echo "escriba la puerta de enlace:"
	ip route show
	read -r puerta
	echo "escriba la direccion del servidor DNS"
	cat /etc/resolv.conf
	read -r dns
	echo "configurando conexion.."
	
	echo "auto $intrface 
	iface $intrface inet static
	address $ip
	netmask $mascara
	gateway $puerta
	dns-nameservers $dns" > /etc/network/interfaces	
	echo "Conexion configurada correctamente"
elif [[ "$conex" == "d" ]]; then
	echo "Iniciando configuracion dinamica"
	echo "auto $intrface
	iface $intrface inet dhcp" > /etc/network/interfaces
fi
systemctl restart networking
echo "Configuracion finalizada"
fi
exit 0
