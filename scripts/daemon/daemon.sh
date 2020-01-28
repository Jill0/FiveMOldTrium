#!/bin/bash

# ██████╗  █████╗ ███████╗███╗   ███╗ ██████╗ ███╗   ██╗
# ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔═══██╗████╗  ██║
# ██║  ██║███████║█████╗  ██╔████╔██║██║   ██║██╔██╗ ██║
# ██║  ██║██╔══██║██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║
# ██████╔╝██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
# ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
# v1.0
# by: TANGO - TriumRP
# Update: 09/05/18

#SERVERS
s1="SERVER 1"
s2="SERVER 2"
s3="SERVER EVENT"
s4="SERVER TEST"

#PORTS
p1="30120"
p2="30110"
p3="30130"
p4="30100"

#LOCATIONS
root="/home/rpgtafivem/gtarp"
path=$root"/bin/server.sh"
log=$root"/log/daemon.log"
l0=$root"/SERVEURTMP"
l1=$root"/SERVEUR1"
l2=$root"/SERVEUR2"
l3=$root"/SERVEUREVENT"
l4=$root"/SERVEURTEST"

#OTHER
ip="149.202.216.162"
json="players.json"
sep="\n$(printf '_%.0s' {1..75})\n"
time="$(date '+%a %d/%m/%y %T')"
hours="*$(date '+%T')*"
discord="/var/gtarp/bin/discord.sh"

#DAEMON
PATH=/usr/sbin:/usr/bin:/sbin:/bin:/var/gtarp/bin
DESC="Daemon d'autoreboot après crash"
NAME=daemon
DAEMON=/usr/bin/$NAME
DAEMON_ARG="--options args"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

#[ -x "$DAEMON" ] || exit 0

#do_start()
##{
#	# 0 = daemon started / 1 = daemon was already running / 2 = daemon could not be started
#	start-stop-daemon --start --quiet --background --make-pidfile \
#	--pidfile $PIDFILE --exec $DAEMON --test > /dev/null || return 1
#	start-stop-daemon --start --quiet --background --make-pidfile \
#	--pidfile $PIDFILE --exec $DAEMON -- $DAEMON_ARGS || return 2
#}

#do_stop()
##{
#	start-stop-daemon --stop --signal 1 --quiet --pidfile $PIDFILE --name $NAME 
#}

function rmcache #server
{
	if [[ ( $1 == 1 ) ]]; then
		rm -rf $l1/cache
	elif [[ ( $1 == 2 ) ]]; then
		rm -rf $l2/cache
	elif [[ ( $1 == 3 ) ]]; then
		rm -rf $l3/cache
	elif [[ ( $1 == 4 ) ]]; then
		rm -rf $l4/cache
	fi
}

function restart #server
{
	echo -e "RESTART "$1 $time $sep >> $log
	rmcache $1
	$path server restart $1
	sleep 5s
	$path server restart $1
	sleep 5s
}

function daemon #server port number
{
	wget $ip:$2/$json >> $log 2> /dev/null #2>> $log
	if [ $? -ne 0 ]; then
		$discord :warning: Crash $1 $hours
		restart $3
		echo -e $1" OFFLINE "$time $sep >> $log
	#else
		#echo -e $1" ONLINE"$sep >> $log
	fi
	rm -f $json $json*
}

## MAIN ##
while true
do
	daemon "$s1" $p1 1
	daemon "$s2" $p2 2
	#daemon "$s3" $p3 3
	#daemon "$s4" $p4 4
	sleep 5s
done
