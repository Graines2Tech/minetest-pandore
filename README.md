# Minetest : Pandore

## Un peu d'histoire pour placer le contexte

*Pour plus d'infos sur le mythe, faites un saut sur [wikipédia](https://fr.wikipedia.org/wiki/Pandore) par exemple!*

La mythologie grecque nous raconte que Pandore était une femme fabriquée par les dieux de l'Olympe. Zeus lui remit une boîte, avec ordre de ne pas l'ouvrir.

Humaine comme pas deux, Pandore a ouvert la boîte, et là, c'est le drame! Parce que Zeus y avait enfermé tous les maux de l'humanité, qui purent donc joyeusement se répandre sur Terre. A nous la vieillesse, la mort, la famine, la misère, j'en passe et des meilleures. Au fond de la boîte, il y avait quand même un truc qui trainait et qu'on appel l'espoir... Bref, c'est pas gagné, mais on peut le faire, Just Do It comme dirait l'autre!

## Pandore et Minetest

Et c'est là qu'arrive Minetest.

Minetest étant un micro-monde, il est normal qu'il vive aussi ce fabuleux mythe de Pandore. Graines2Tech a donc initié un mod Pandore pour Minetest.

[Graines2Tech](http://graines2tech.com) propose de faire découvrir le numérique à tous ceux qui se sentent jeunes, par des activités ludiques et créatives, du pixel-art au stop-motion, de la programmation à la robotique, des jeux déconnectés à l'impression 3D.

Et quoi de mieux pour découvrir la programmation que de réalise son propre mod sous Minetest? Ben rien, je suis bien d'accord :) Graines2Tech a donc proposé à des participants, lors d'un stage, de créer des plaies pour une boîte de Pandore.

Et vous avez le résultat sous les yeux!

# Le mod Pandore

## Compatibilité

Le mod Pandore a été développé et testé pour minetest 0.4.17.1.

## Mode d'emploi

Ce repository comprend plusieurs mods:
- le mod principal **pandore**
- un répertoire pour chacune des plaies créées par les participants

Pour créer une plaie, il suffit de créer un mod! [Plus d'informations sur la création de mod minetest.](https://dev.minetest.net/Installing_Mods)

Vous aurez besoin du mod *pandore* pour initier la boîte de Pandore dans minetest.

Pour charger une plaie dans la boîte de Pandore, il suffit de faire appel à la méthode *pandore.register_plaie* ; cette méthode prend 3 paramètres:
1. le nom de la plaie
2. une fonction permettant d'exécuter la plaie sur un joueur; un paramètre sera passé à cette fonction qui contiendra un objet [player](https://dev.minetest.net/Player) correspondant à la victime de la plaie
3. *[optionnel, défaut = false]* un booléen indiquant que la plaie doit s'appliquer à tous les joueurs ; si la valeur est *false*, un joueur sera choisi au hasard parmi les joueurs connectés

## Fonctionnement

Lorsqu'un joueur se connecte dans le monde, après un délai (*pandore.delai_pop*) de quelques secondes, le mod *pandore* créé une boîte de Pandore (*pandore:boite*) a proximité du joueur s'il n'en existe pas déjà.

La boîte de Pandore s'ouvre automatiquement et libère une plaie au hasard au bout d'un certain délai (compris entre *pandore.delai_min* et *pandore.delai_max*). La boîte peut également être ouverte par un joueur via un clic droit. Un joueur ne pourra pas ré-ouvrir la boîte avant un certain délai (*pandore.delai_min*).

Lorsque la boîte s'ouvre, un message est affiché pour tous les joueurs si la plaie concerne tous les joueurs, ou pour le joueur concerné le cas échéant. Si la plaie ne concerne pas tous les joueurs, un joueur est choisi au hasard parmi les joueurs connectés. Après un certain délai (*pandore.delai_plaie*), la plaie est lancé sur la ou les vicitime.s.

# A votre écoute!

N'hésitez pas à nous faire part de tous vos commentaires, et à créer des tickets pour de nouvelles fonctionnalités sur le mod *pandore* ou des bugs que vous pourriez trouver.

Un grand merci à vous!

L'équipe Graines2Tech