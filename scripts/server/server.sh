#!/bin/bash

# ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗
# ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
# ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
# ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
# ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
# v1.2.1
# by: TANGO - TriumRP
# Update: 19/08/18
# Warning: Always doubles quotes to variables who contains whitespaces in it (s0, s1, s2 ...)

### ALIAS ###
# deploy="/home/rpgtafivem/gtarp/bin/tools.sh deploy"
# server="/home/rpgtafivem/gtarp/bin/tools.sh server"
# convert="/home/rpgtafivem/gtarp/bin/tools.sh convert"
# update="/home/rpgtafivem/gtarp/bin/tools.sh update"

#SERVERS
s0="Serveur TEST"
s1="Serveur 1"
s2="Serveur 2"
s3="Serveur EVENT"
s4="Serveur HARDCORE"

#LOCATIONS
root="/home/rpgtafivem/gtarp"
l0=$root"/SERVEURTEST"
l1=$root"/SERVEUR1"
l2=$root"/SERVEUR2"
l3=$root"/SERVEUREVENT"
l4=$root"/SERVEURHC"

#PORTS
p0="0.0.0.0:30100"
p1="0.0.0.0:30110"
p2="0.0.0.0:30120"
p3="0.0.0.0:30130"
p4="0.0.0.0:30140"

#SHARPS
h0="#TEST"
h1="#1"
h2="#2"
h3="#EVENT"
h4="#HARDCORE"

#COLOR
def="\e[0m"
bld="\e[1m"
udr="\e[4m"
red="\e[31m"
grn="\e[32m"
yel="\e[33m"
blu="\e[34m"
pur="\e[35m"
cya="\e[36m"
eca="\e[91m"
nav="\e[94m"
mag="\e[95m"
trq="\e[96m"
red="\e[31m"
grn="\e[32m"
yel="\e[33m"
blu="\e[34m"

#FORMATING
tab="\t\t"
ok2=$def$tab"["$grn"OK"$def"]"
ok3=$def$tab"\t["$grn"OK"$def"]"
ok4=$def$tab$tab"["$grn"OK"$def"]"
ok5=$def$tab$tab"\t["$grn"OK"$def"]"

#MISC
repossh="git@git.triumfr.com:TriumFR/TriumRP.git"
repohttp="http://git.triumfr.com:56400/TriumFR/TriumRP.git"
run="bash run.sh +exec server.cfg"
grepex="{sed.sh,proot,*.png,*.jpg,*.ytd,*.ytf,*.oet,*.ogg;*.dll}"
time="$(date '+%a %d/%m/%y %T') > "
hours="*$(date '+%T')*"
discord=$root"/bin/discord.sh"
test="ACCÈS INTERDIT"
fa="FREE-ACCESS"
wl="WHITE-LIST"
debug1="#start debug"
debug2="start debug"
bdd="triumbddgta"
bddhc="triumbddhc"
#LOGS
slog=$root"/log/status.log"
dlog=$root"/log/deploy.log"

### HELPER ###
function help_tools
{
    echo -e $bld"Usage"$def": tools ["$nav"script"$def"]\n"
    echo -e $red"Trium Toolbox"$def" est un outil regroupant 3 scripts :\n"
    echo -e "\t- "$nav"deploy"$def"  : Déploiement de serveur"
    echo -e "\t- "$nav"server"$def"  : Contrôle de serveur"
    echo -e "\t- "$nav"convert"$def" : Conversion de serveur pour le déploiement\n"
    echo -e "Le script "$bld"convert"$def" est exécuté par le script "$bld"deploy"$def", peut être néanmoins\nutilisé indépendamment"
    echo -e "Pour consulter les helpers respectifs: tools ["$nav"script"$def"] help\n"
    exit 1
}

function help_convert
{
    echo -e $bld"Usage"$def": convert ["$cya"serveur à convertir"$def"] ["$pur"numéro"$def"]\n"
    echo -e "Convertit un serveur en un autre avec 2 usages possible: "$bld"sed"$def" ou "$bld"revsed"$def
    echo -e " - "$bld"sed"$def" remplace toutes les occurences du serveur 2"
    echo -e " - "$bld"revsed"$def" remplace toutes les occurences possibles"
    echo -e "revsed est 4x fois plus long que le simple sed mais utile quand\nles données ont été alterées ou pour remplacer un serveur par un autre"
    echo -e $bld"convert ?"$def" : Affiche le nom du serveur\n"
    echo -e "["$cya"serveur à convertir"$def"] = "$trq"1"$def" OU "$trq"2"$def" OU "$trq"3"$def" OU "$trq"4"$def"\n"
    echo -e $bld"sed"$def"\n["$pur"numéro"$def"] = "$trq"1"$def" OU "$trq"2"$def" OU "$trq"3"$def" OU "$trq"4"$def
    echo -e "\n"$bld"revsed"$def"\n["$pur"numéro"$def"] = "$trq"-1"$def" OU "$trq"-2"$def" OU "$trq"-3"$def" OU "$trq"-4"$def
    echo -e $trq"3"$def" = event\n"$trq"4"$def" = test\n"
    echo -e $udr"Ex"$def": Convertir le serveur "$trq"2"$def" en serveur "$trq"1"$def"\t    :"$tab"convert 2 1"
    echo -e $udr"Ex"$def": Convertir le serveur "$trq"2"$def" en serveur "$trq"test"$def"  :"$tab"convert 2 4"
    echo -e $udr"Ex"$def": Convertir le serveur "$trq"test"$def" en serveur "$trq"2"$def"  :"$tab"convert 4 -2"
    echo -e $udr"Ex"$def": Convertir le serveur "$trq"event"$def" en serveur "$trq"1"$def" :"$tab"convert 3 -1\n"
    exit 1
}

function help_server
{
    echo -e $bld"Usage"$def": server ["$cya"action"$def"] ["$mag"nom serveur"$def"]\n"
    echo -e "["$cya"action"$def"] = "$grn"start"$def" OU "$yel"restart"$def" OU "$red"stop"$def" OU "$nav"reach"$def" OU "$eca"list"$def
    echo -e "["$mag"nom server"$def"] = "$trq"1"$def", "$trq"2"$def", "$trq"test"$def", "$trq"event" $def
    echo -e $nav"reach"$def" permet d'accéder au serveur pour relancer des ressources"
    echo -e $eca"list"$def" affiche la liste des serveurs actifs\n"
    echo -e $udr"Ex"$def": "$yel"Redémarrer"$def" le serveur "$trq"1"$def"  :"$tab"server restart 1"
    echo -e $udr"Ex"$def": "$red"Stopper"$def" le serveur "$trq"event"$def" :"$tab"server stop event"
    echo -e $udr"Ex"$def": "$grn"Démarrer"$def" le serveur "$trq"test"$def" :"$tab"server start test"
    echo -e $udr"Ex"$def": "$nav"Accéder"$def" sur le serveur "$trq"2"$def" :"$tab"server reach 2\n"
    echo -e "Après avoir fait un "$nav"reach"$def" : restart ["$pur"ressource"$def"]"
    echo -e "["$pur"ressource"$def"] = le nom de la ressource a relancer"
    echo -e $udr"Ex"$def": Relancer mellotrainer :"$tab"restart mellotrainer\n"
    echo -e "Pour sortir de la fenêtre appuyez sur : "$bld"Ctrl+A"$def" puis la touche "$bld"D"$def
    echo -e "Priviligiez plutôt l'accès en "$bld"RCON"$def" pour relancer des ressources\n"
    exit 1
}

function help_deploy
{
    echo -e $bld"Usage"$def": deploy ["$mag"nom serveur"$def"]\n"
    echo -e "["$mag"nom serveur"$def"] = "$trq"0"$def" OU "$trq"1"$def" OU "$trq"2"$def" OU "$trq"3"$def" OU "$trq"4"$def
    echo -e $trq"0"$def" = hc\n"$trq"3"$def" = event\n"$trq"4"$def" = test\n"
    echo -e $red$udr$bld"Attention"$def": deploy écrase de manière "$bld$udr"irréversible"$def"\n"
    echo -e $udr"Ex"$def": Déployer le serveur "$trq"1"$def"\t:"$tab"deploy 1"
    echo -e $udr"Ex"$def": Déployer le serveur "$trq"test"$def"\t:"$tab"deploy 4"
    echo -e $udr"Ex"$def": Déployer le serveur "$trq"hc"$def"\t:"$tab"deploy 0\n"
    exit 1
}

function help_update
{
    echo -e $bld"Usage"$def": update ["$mag"nom serveur"$def"]\n"
    echo -e "["$mag"nom serveur"$def"] = "$trq"0"$def" OU "$trq"1"$def" OU "$trq"2"$def" OU "$trq"3"$def" OU "$trq"4"$def
    echo -e $trq"0"$def" = hc\n"$trq"3"$def" = event\n"$trq"4"$def" = test\n"
    echo -e $udr"Ex"$def": Mettre à jour le serveur "$trq"1"$def":\t\tupdate 1"
    echo -e $udr"Ex"$def": Mettre à jour le serveur "$trq"test"$def":\tupdate 4"
    echo -e $udr"Ex"$def": Mettre à jour "$trq"tout"$def" les serveurs:\tupdate 0\n"
    exit 1
}

### ERRORS ###
function err_av #fct name
{
    echo -e $red"Erreur: Valeur d'argument incorrect pour "$1$def
    echo -e "Besoin d'aide ? "$1" help"
    exit 1
}

function err_ac #fct name
{
    echo -e $red"Erreur: Nombre d'argument incorrect pour "$1$def
    echo -e "Besoin d'aide ? "$1" help"
    exit 1
}


### CONVERT ###
function check #server_location
{
	  grep -nrwq $1 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$s0" -e $p0 -e $h0 --color=always
    grep -nrwq $1 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$s1" -e $p1 -e $h1 --color=always
    grep -nrwq $1 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$s2" -e $p2 -e $h2 --color=always
    grep -nrwq $1 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$s3" -e $p3 -e $h3 --color=always
    grep -nrwq $1 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$s4" -e $p4 -e $h4 --color=always
}

function revsed #s_new p_new h_new location
{
    echo -e $nav" REVERSE SED: Conversion to ["$1"]\n"$def
    echo -e $yel"Searching occurences"$ok4
    check
    echo -e $yel"Converting Server + Ports"$ok3
    find $4 ! -name 'sed.sh' -type f -exec sed -i "s/$s0/$1/g;s/$p0/$2/g;s/$h0/$3/g" {} +
    find $4 ! -name 'sed.sh' -type f -exec sed -i "s/$s1/$1/g;s/$p1/$2/g;s/$h1/$3/g" {} +
    find $4 ! -name 'sed.sh' -type f -exec sed -i "s/$s2/$1/g;s/$p2/$2/g;s/$h2/$3/g" {} +
    find $4 ! -name 'sed.sh' -type f -exec sed -i "s/$s3/$1/g;s/$p3/$2/g;s/$h3/$3/g" {} +
    find $4 ! -name 'sed.sh' -type f -exec sed -i "s/$s4/$1/g;s/$p4/$2/g;s/$h4/$3/g;s/$fa/$wl/g" {} +
    echo -e $yel"Checking result"$ok5
    grep -nrwq $4 --exclude-dir='.*' --exclude=$grepex -e "$1" -e $2 -e $3 --color=always
    echo -e $grn"Done converting"$ok5
}

function sed #s_old s_new p_old p_new h_old h_new location letter_banner
{
    echo -e "Debug:" $1 $2 $3 $4
    echo -e $nav" SED: Conversion ["$1"] to ["$2"]\n"$def
    #echo -e $yel"Searching occurences"$ok4
    #grep -nrwq $7 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$1" -e $3 -e $5 --color=always
    echo -e $yel"Converting Server + Ports"$ok3
    find $7/server.cfg -type f -exec sed -i "s/$1/$2/g;s/$3/$4/g;s/$5/$6/g" {} +
    if [[ ( $2 == "Serveur HARDCORE" ) ]]; then
      find $7/server.cfg -type f -exec sed -i "s/$fa/$wl/g;s/triumbddgta/triumbddhc/g" {} + # whitelist + bdd
    fi
    if [[ ( $2 == "Serveur TEST") ]]; then
      find $7/resources/resources.cfg -type f -exec sed -i "s/$debug1/$debug2/g" {} + # activation debug
      find $7/server.cfg -type f -exec sed -i "s/$fa/$test/g" {} + # acces interdit
    fi
    #echo -e $yel"Checking result"$ok5
    #grep -nrwq $7 --exclude-dir='.*' --exclude=$grepex --exclude-dir="alpine" -e "$2" -e $4 -e $6 --color=always
    echo -e $grn"Done converting"$ok5
    echo "sets banner_connecting \"http://app.triumfr.com/Town_"$8"XL.jpg\"" >> $7/server.cfg
    echo "sets banner_detail \"http://app.triumfr.com/Town_"$8"XL_desc.jpg\"" >> $7/server.cfg
    echo -e $grn"Setting banner"$ok5
    #find $7/server.cfg -type f -exec sed -i "s/#sets $banner_connecting\"http://app.triumfr.com/Town_2XL.jpg\"/lol.jpg/g" {} +
    #find $7/server.cfg -type f -exec sed -i "s/#sets_desc.jpg\"/lel.jpg/g" {} +
}

function convert #old_server_location new_server
{
	if [[ ( $2 == 0 ) ]]; then
	   sed "$s0" "$s0" $p0 $p0 $h0 $h0 $1 T
    elif [[ ( $2 == 1 ) ]]; then
	   sed "$s0" "$s1" $p0 $p1 $h0 $h1 $1 1
    elif [[ ( $2 == 2 ) ]]; then
       sed "$s0" "$s2" $p0 $p2 $h0 $h2 $1 2
    elif [[ ( $2 == 3 ) ]]; then
       sed "$s0" "$s3" $p0 $p3 $h0 $h3 $1 E
    elif [[ ( $2 == 4 ) ]]; then
       sed "$s0" "$s4" $p0 $p4 $h0 $h4 $1 H
    elif [[ ( $2 == 0 ) ]]; then
       revsed "$s0" $p0 $h0 $1
    elif [[ ( $2 == -1 ) ]]; then
       revsed "$s1" $p1 $h1 $1
    elif [[ ( $2 == -2 ) ]]; then
       revsed "$s2" $p2 $h2 $1
    elif [[ ( $2 == -3 ) ]]; then
       revsed "$s3" $p3 $h3 $1
    elif [[ ( $2 == -4 ) ]]; then
       revsed "$s4" $p4 $h4 $1
    else
       err_av "convert"
    fi
}

### SERVER ###
function server #action server location screen_name
{
    if [[ ( $1 = "start" ) ]]; then
      echo -e $grn"Démarrage du ["$2"]"$def
      if [ ! -d $3"/cache" ]; then
        echo "Pas de cache, génération..."
        screen -S $4 -dm bash -c "cd $3; $run"
        sleep 5
        screen -S $4 -X quit
      fi
      screen -S $4 -dm bash -c "cd $3; $run"
	    echo -e $time "start" $2 >> $slog
      $discord :arrow_forward: $2 $1 $hours
    elif [[ ( $1 = "restart" ) ]]; then
      echo -e $yel"Redémarrage du ["$2"]"$def
      screen -S $4 -X quit
      screen -S $4 -dm bash -c "cd $3; $run"
      sleep 5
      screen -S $4 -X quit
      screen -S $4 -dm bash -c "cd $3; $run"
	    echo -e $time "restart" $2 >> $slog
      $discord :arrows_counterclockwise: $2 $1 $hours
    elif [[ ( $1 = "stop" ) ]]; then
	   echo -e $red"Arrêt du ["$2"]"$def
      screen -S $4 -X quit
	   echo -e $time "stop" $2 >> $slog
      $discord :stop_button: $2 $1 $hours
    elif [[ ( $1 = "reach" ) ]]; then
	    screen -r $4
	    echo -e $time "reach" $2 >> $slog
    fi
}

### DEPLOY ###
function deploy #server loca numer
{
    echo -e $nav" DEPLOY ["$1"]"$def
    echo -e $yel"Erasing existing server"$ok4
    rm -rf $2
    echo -e $yel"Creating new directory"$ok4
    mkdir -p $2
    echo -e $yel"Cloning git repository..."$ok3
    if [[ ( $3 = 2 )]]; then
      git clone --single-branch -b develop $repossh $2
    elif [[ ( $3 = 4 ) ]]; then
      git clone --single-branch -b hardcore $repossh $2
    else
      git clone $repossh $2
    fi
    echo -e $yel"Erasing old ServerFX artifacts"$ok3
    convert $2 $3
    #echo -e $yel"Extracting ServerFX artifacts"$ok3
    #tar -xJf $root/fx.tar.xz -C $2
    #mv $2/fx/* ..
    echo -e $yel"Changing owner"$ok5
    chown -Rf rpgtafivem $2
    #echo -e $yel"Changing access permissions"$ok3
    #chmod -Rf 777 $2
    echo -e $grn"Done deploying"$ok5
    echo $time "deploy" $3 $1 >> $dlog
    $discord :arrows_clockwise: Déploiement du $1 $hours
}

### DAEMON ###
function daemon #action
{
    if [[ ( $1 = "start" ) ]]; then
        echo -e $grn"Démarrage du [DEAMON]"$def
        screen -S DAEMON -dm bash -c $root"/bin/daemon.sh"
        echo -e $time "start" DAEMON >> $slog
        $discord :arrow_forward: Daemon start $hours
    elif [[ ( $1 = "stop" ) ]]; then
        echo -e $red"Arrêt du [DAEMON]"$def
        screen -S DAEMON -X quit
        echo -e $time "stop" DAEMON >> $slog
        $discord :stop_button: Daemon stop $hours
    elif [[ ( $1 = "restart" ) ]]; then
        echo -e $yel"Redémarrage du [DAEMON]"$def
        screen -S DAEMON -X quit
        screen -S DAEMON -dm bash -c $root"/bin/daemon.sh"
        echo -e $time "restart DAEMON" >> $slog
        $discord :arrows_counterclockwise: Daemon retart $hours
    elif [[ ( $1 = "reach" ) ]]; then
        screen -r DAEMON
        echo -e $time "reach" DAEMON >> $slog
    fi
}

### UPDATE ###
function update #server location
{
	echo "debug" $1 $2 $3
    echo -e $nav" UPDATE ["$1"]"$def
    cd $2
    git pull
    echo $time "update" $3 $1 >> $dlog
    $discord :asterisk: Mise à jour du $1 $hours
}

### ARG FUNCTIONS ###
function arg_convert #old_server #new_server
{
    echo "arg_>: oldserv:"$1 "newserv:"$2
    if [[ ( $1 = "--help" ) || $1 = "help" ]]; then
	   help_convert
	elif [[ ( $2 == 0 ) || ( $1 = "test" ) ]]; then
	   convert $l0 $2
    elif [[ ( $2 == 1 ) ]]; then
	   convert $l1 $2
    elif [[ ( $2 == 2 ) ]]; then
	   convert $l2 $2
    elif [[ ( $2 == 3 ) || ( $2 = "event" ) ]]; then
	   convert $l3 $2
    elif [[ ( $2 == 4 ) || ( $2 = "hc" ) || ( $2 = "hardcore" ) ]]; then
	   convert $l4 $2
    else
	   err_av "arg_convert"
    fi
}

function arg_server #action server
{
    if [[ ( $1 = "--help" ) || $1 = "help" ]]; then
	   help_server
    elif [[ ( $1 = "list" ) || ( $1 = "ls" ) || ( $1 = "" ) ]]; then
	   echo -e $grn"Liste des serveurs actifs:"$def
	   screen -ls
    elif [[ ( $2 == "d" ) || ( $2 = "daemon" ) ]]; then
       daemon $1
       screen -ls
    elif [[ ( $2 == 0 ) || ( $2 = "test" ) ]]; then
	   server $1 "$s0" $l0 "SERVEURTEST"
	   screen -ls
    elif [[ ( $2 == 1 ) ]]; then
	   server $1 "$s1" $l1 "SERVEUR1"
	   screen -ls
    elif [[ ( $2 == 2 ) ]]; then
	   server $1 "$s2" $l2 "SERVEUR2"
	   screen -ls
    elif [[ ( $2 == 3 ) || ( $2 = "event" ) ]]; then
	   server $1 "$s3" $l3 "SERVEUREVENT"
	   screen -ls
    elif [[ ( $2 == 4 ) || ( $2 = "hc" ) || ( $2 = "hardcore" ) ]]; then
	   server $1 "$s4" $l4 "SERVEURHC"
	   screen -ls
    else
	   err_av "arg_server"
    fi
}

function arg_deploy #server
{
    if [[ ( $1 = "--help" ) || $1 = "help" ]]; then
	   help_deploy
    elif [[ ( $1 = "all" ) ]]; then
	   echo -e $red"Peut-être long ..."$def
	   deploy "$s0" $l0 0
	   deploy "$s1" $l1 1
	   deploy "$s2" $l2 2
	   deploy "$s3" $l3 3
	   deploy "$s4" $l4 4
	elif [[ ( $1 == 0 ) || ( $1 = "test" ) ]]; then
	   deploy "$s0" $l0 0
    elif [[ ( $1 == 1 ) ]]; then
	   deploy "$s1" $l1 1
    elif [[ ( $1 == 2 ) ]]; then
	   deploy "$s2" $l2 2
    elif [[ ( $1 == 3 ) || ( $1 = "event" ) ]]; then
	   deploy "$s3" $l3 3
    elif [[ ( $1 == 4 ) || ( $1 = "hardcore" ) || ( $1 = "hc" )  ]]; then
	   deploy "$s4" $l4 4
    else
	   err_av "arg_deploy"
    fi
}

function arg_update #server
{
    if [[ ( $1 = "--help" ) || $1 = "help" ]]; then
        help_update
    elif [[ ( $1 = "all" ) ]]; then
        update "$s0" $l0
        update "$s1" $l1
        update "$s2" $l2
        update "$s3" $l3
        update "$s4" $l4
    elif [[ ( $1 == 0 ) || ( $1 = "test" ) ]]; then
        update "$s0" $l0
    elif [[ ( $1 == 1 ) ]]; then
        update "$s1" $l1
    elif [[ ( $1 == 2 ) ]]; then
        update "$s2" $l2
    elif [[ ( $1 == 3 ) || ( $1 = "event" ) ]]; then
        update "$s3" $l3
    elif [[ ( $1 == 4 ) || ( $1 = "hardcore" ) || ( $1 = "hc" )  ]]; then
        update "$s4" $l4
    else
        err_av "arg_update"
    fi
}

### MAIN ###
if [[ ( $1 = "--help" ) || $1 = "help" ]]; then
    help_tools
else
    if [[ ( $1 == "deploy" ) ]]; then
	   arg_deploy $2
    elif [[ ( $1 == "server" ) ]]; then
	   arg_server $2 $3
    elif [[ ( $1 == "convert" ) ]]; then
	   arg_convert $2 $3
    elif [[ ( $1 == "update" ) || ( $1 = "up" ) ]]; then
        arg_update $2
    else
	   err_av "tools"
    fi
fi
