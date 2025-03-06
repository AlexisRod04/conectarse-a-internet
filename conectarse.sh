#¡/bin/bash

#Este es un script para automatizar e implementar una "Intefaz" para conectarse a una red a traves de distintos metodos

#Mostrar interfaces de red
echo "Interfaces de red detectadas:" 
ip a

#Cambiar estado de interfaz (up, down)
echo "Interfaz que desea cambiar su estado:"
read intrface
echo "Desea activar (up) o desactivar (down)"
read estado
sudo ip link set "$intrface" "$estado"
echo "interfaz $intrface establecida a $estado con exito!"
if [[ "$estado" == "down" ]]; then
	exit 1
fi

#echo "Que accion desea realizar?"
#echo "1 - Conectarse a una red mediante cable o wifi"
#echo "2 - configurar red manualmente"
#read accion
#if [[ "$accion" == "1" ]]; then
echo "###################################"
echo "Iniciar Conexion a una Red"
echo "###################################"

echo "Desea conectarse mediante cable Ethernet o mediante Wi-Fi?"
echo "Wi-Fi = w"
echo "Cable = c"
read tipo
	
if [[ "$tipo" == "w" ]]; then
	echo "Redes disponibles"
	sudo iwlist "$intrface" scan | grep 'ESSID'
	echo "ingrese el ISSD (nombre) de la red Wi-Fi a la que desee conectarse"
	read ssid
	echo "Ingrese la contraseña de la red"
	read contra
	wpa_passphrase "$ssid" "$contra" | sudo tee /usr/sbin/confwifi.conf
	echo "configurando..."
	sleep 2
	echo "comparando contraseñas..."
	echo "finalizando procesos..."
	sudo wpa_supplicant -i "$intrface" -c /usr/sbin/confwifi.conf
	sudo dhclient wlp0s20f3
elif [[ "$tipo" == "c" ]]; then
	echo "Escriba el nombre de la interfaz de red cableada a encender:"
	ip a
	read intrface2
	echo "Conectando mediante red cableada..."
	sudo ip link set "$intrface2" up 
fi	
#	elif [[ "$accion" == "2" ]]; then
echo "##################################"
echo "Tipo de configiracion de red"
echo "##################################"
echo "¿Que tipo de conexion desea tener? estatica (e) o dinamica (d)"
read conex
if [[ "$conex" == "e" ]]; then
	echo "configurando conexion estatica..."
	ip addr show
	echo "escriba la direccion ip:"
	read ip
	echo "escriba la mascara de red."
	read mascara
	echo "escriba la puerta de enlace:"
	ip route show
	read puerta
	echo "escriba la direccion del servidor DNS"
	cat /etc/resolv.conf
	read dns
	echo "configurando conexion.."
	sudo echo "auto "$intrface" 
		iface "$intrface" inet static
		address "$ip"
		netmask "$mascara"
			gateway "$puerta"
			dns-nameservers "$dns"" > sudo nano +11 /etc/networking/interfaces	
	sudo systemctl restart networking
	echo "Conexion configurada correctamente"
fi
#fi
