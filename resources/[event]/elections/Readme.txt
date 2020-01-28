Avant l'installation de la resource :

ALTER TABLE `users` ADD `vote` INT(11) NOT NULL DEFAULT '0' AFTER `ban_reason`;


Pour réinitialiser tout les votes :

UPDATE `users` SET `vote`=0 WHERE `vote`!=0;


Avant que l'élection démarre, le script affiche quand elle démarre.
lorsqu'elle est terminée, il affiche le résultat