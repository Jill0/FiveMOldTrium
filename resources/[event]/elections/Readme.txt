Avant l'installation de la resource :

ALTER TABLE `users` ADD `vote` INT(11) NOT NULL DEFAULT '0' AFTER `ban_reason`;


Pour r�initialiser tout les votes :

UPDATE `users` SET `vote`=0 WHERE `vote`!=0;


Avant que l'�lection d�marre, le script affiche quand elle d�marre.
lorsqu'elle est termin�e, il affiche le r�sultat