# SERVER
###### v1.2.1

Créée par @Tango

Update: 18/08/18

## Changelogs

v1.2.1
* Remplacement du `free-access` par `accès interdit` pour le serveur test

v1.2
* Ajout du hardcore
* Changement du daemon en `d`
* Changement du test en `0`
* Ajout du hardcore en `4`
* Ajout de la génération du cache au démarrage si absent
* Ajout du sed pour le changement de de bdd pour le hardcore
* Ajout du sed pour le changement du `free-access` en `white-list` pour le hardcore
* Ajout du sed pour la ressource `debug` pour le serveur TEST
* Deploiement du serveur 2 sur la branche `develop`
* Deploiement du serveur hardcore sur la branche `hardcore` 

v1.1.2
* Changement IP
* Changement nom de bannières

v1.1.1
* Changement des répertoires $root

v1.1
* Mise à jour pour la mise automatique des bannières en `echo >>` au lieu d'un `find sed`

## A faire

- [ ] Correction du nom de la fonction appeler pour les erreurs
- [X] Rajouter une entrée pour le git pull
- [ ] Log séparé pour le update
- [X] Automatisation des bannières
- [ ] Automatisation des keys

## Description

Script de gestion de screen et de serveurs.

Il permet de:
 1. __Démarrer__, __Arrêter__, __Redémarrer__ un serveur ou le daemon de veille anti-crash
 2. Accéder à la __console__ du serveur
 3. __Mettre à jour__ un serveur depuis Git
 4. __Deployer__ un serveur tout neuf depuis Git
 5. De convertir le serveur 2 (présent dans le repo Git) dans le format de serveur adapté.

Ce script contient 3 sous-scripts:
* server = gestion de serveur
* deploy = déploiement de serveur
* convert = converti un server
* update = mise à jour de serveur

 __Je déconseille de toucher à convert, il est gérer automatiquement par le deploy__

Le deploy supprime l'ancien serveur, crée un dossier dans `/var/gtarp/<serveur>`, puis clone dedans le repo git avec la clé SSH du serveur avant de convertir tous les noms et ports pour le serveur correspondant puis change les droits d'owner.

Faire un deploy revient à écraser les fichiers de l'ancien serveur par ceux de git.



:warning: __Attention de ne pas faire du deploy sur un serveur en marche, cela le fera crashé immédiatement. Pensez à l'éteindre impérativement__ :warning:

Priviliégé plutot le update pour faire une mise à jour.

Le update revient à faire une git pull

Contrairement à un pull, il met le serveur choisi à plat, y compris le cache et les fichiers temporaires.

Concernant le reach, vous pouvez éxécuter n'importe quelle commandes RCON directement dedans (sauf `exit` évidement)
Pour sortir, soit fermer la fenêtre de PuTTY, soit appuyez sur `Ctrl + A` puis `Ctrl + D`.

__Un `Ctrl + D` simple, ferme le screen__.


## Commandes

### Server

`server help` = Affiche l'aide

`server` ou `server list` ou `server ls` = Affiche les serveurs courants

Syntaxe: `server <action> <serveur>`

action:
* `start`
* `stop`
* `restart`
* `reach`

serveur:
* `0` ou `test`
* `1`
* `2`
* `3` ou `event`
* `4` ou `hc` ou 'hardcore'
* `d` ou `daemon`
* `all`

Start = Démarre le serveur.

Stop = Arrête le serveur

Restart = Redémarrage le serveur __en supprimant le cache__

Reach = Permet d'accéder à la console (équivalent d'un `screen -r`)

##### Exemples

`server start 1` = Démarre le serveur 1

`server stop 2` = Arrête le serveur 2

`server restart 3` = Redémarre le serveur event

`server stop event` = Arrête le serveur event

`server reach test` = Accéder à la console du serveur test

`server stop 4` = Arrête le serveur hardcore

`server reach 2` = Accéder à la console du serveur 2

`server reach 3` = Accéder à la console du serveur event

### Deploy

`deploy help` = Affiche l'aide

Syntaxe: `deploy <serveur>`

serveur:
* `0` ou `test`
* `1`
* `2`
* `3` ou `event`
* `4` ou `hc` ou 'hardcore'
* `d` ou `daemon`
* `all`

##### Exemples

`deploy 1` = Déploie le serveur 1

`deploy event` = Déploie le serveur event

`deploy 4` = Déploie le serveur hardcore

`deploy 3` = Déploie le serveur event


### Convert

`convert help` = Affiche l'aide

Syntaxe: `convert <ancien_serveur> <nouveau_serveur>`

serveur:
* `0` ou `test`
* `1`
* `2`
* `3` ou `event`
* `4` ou `hc` ou 'hardcore'
* `d` ou `daemon`
* `all`

##### Exemples

`convert 2 1` = Convertion du serveur 2 en serveur 1

`convert 1 4` = Convertion du serveur 1 en serveur test

### Update

`update help` = Affiche l'aide

Syntaxe: `update <server>`

serveur:
* `0` ou `test`
* `1`
* `2`
* `3` ou `event`
* `4` ou `hc` ou 'hardcore'
* `d` ou `daemon`
* `all`

##### Exemples

`update 1` = Met à jour le serveur 1

`update 3` = Met à jour le serveur event

## Configuration

Le script est conçu pour être très facilement modifiable:
 * Nom serveurs
 * Ports
 * Chemin serveurs
 * Repo Git
 * ...

Pour rendre son éxécution disponible depuis n'importe où, rajouter ces alias dans le fichier de configuration du shell:

```
server="/var/gtarp/bin/server.sh server"
deploy="/var/gtarp/bin/server.sh deploy"
convert="/var/gtarp/bin/server.sh convert"
update="/var/gtarp/bin/server.sh update"
```

Sinon simplement précéder le nom du script suivi de la commande comme ci dessus.

Ce script utilise le script discord.sh pour le webhook

Situé : `/var/gtarp/bin`

Log de status : `/var/gtarp/log/status.log`

Log de déploiement : `/var/gtarp/log/deploy.log`


## Fonctionnement

À venir.
