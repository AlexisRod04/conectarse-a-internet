#Este es un script para conectarse a internet mediante la terminal de debian
Como usarlo:
la pantalla mostrara las interfaces de red detectadas
la primer opcion que se le da al usaurio es escribir el nombre de la interfaz que desea activar o desactivar para posteriormente escribir el estado en el que desea que se encuentre (up o down)
tras esto se entra a un pequeño menu donde se muestran 3 opciones
1 - conectarse a la red mediante wi-fi o mediante ethernet
2 - configurar la red manualmente
3 - salir del programa

opcion 1
se le preguntara si desea conectarse mediante wi-fi (w) o cable ethernet (c)
si elige la opcion w se le mostraran todas las redes wifi que se detectaron
a continuacion se solicita que escriba el ssid (nombre) y la contraseña de la red a la que se desea conectar
se guarda la configuracion en /usr/sbin/confwifi.conf
y se activa con wpa_supplicant
finalmente de usa dhclient para asignarle una ip a la interfaz de red

si elige la opcion c
se asume que eligio encender la interfaz ethernet, por lo que solo se le asigna ip mediante dhclient

opcion 2
se le preguntara si desea conectarse de manera estatica (e) o dinamica (d)
si elige la opcion e
se utiliza el comando ip addr show para que el usuario vea los campos que necesitara a continuacion.
se le solicitaran:
ip
mascara
puerta de enlace (gateway)
servidor DNS
una vez que el usuario ingreso estos campos, se guardan en el archivo /etc/network/interfaces.

si elige opcion d
simplemente se utilizara la interfaz que el usuario escribio al principio del script y se escribira en el archivo /etc/network/interfaces para conectarse dinamicamente
finalmente se reinicia el networknig 

opcion 3
el script muestra un mensaje de despedida y se cierra

