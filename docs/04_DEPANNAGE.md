# Dépannage LANCast

## Le Viewer ne démarre pas

Contrôler dans cet ordre :

1. PC01 a bien l'adresse IP prévue.
2. La carte réseau dédiée est bien active.
3. La tâche planifiée `LANCast SignalServer` existe.
4. Le port de signalisation n'est pas déjà utilisé.
5. Le serveur répond sur `/health`.

Cause fréquente : le serveur écoute sur une mauvaise IP. Cette version corrige le problème en utilisant l'IP choisie à l'installation.

## Une Source ne se connecte pas

Contrôler :

- l'IP de la Source ;
- l'IP du Viewer configurée côté Source ;
- le pare-feu Windows ;
- le nom de Source ;
- la connectivité réseau entre la Source et le Viewer.

Chaque Source doit avoir un identifiant unique. Deux postes avec le même `SourceId` peuvent provoquer des conflits.

## Le Viewer voit la room mais pas l'image

Cela indique souvent que la signalisation fonctionne, mais que le flux WebRTC ne s'établit pas correctement.

À vérifier :

- autorisation de capture d'écran dans le navigateur ;
- navigateur compatible ;
- pare-feu local ;
- mauvais choix d'écran ou de fenêtre ;
- réseau instable ou interface non dédiée.

## La page `/health` ne répond pas

Sur le Viewer :

- vérifier la tâche planifiée ;
- redémarrer la tâche ;
- vérifier que l'IP locale est bien celle attendue ;
- vérifier que le port configuré est libre.

## Mauvaise IP après installation

Vérifier la configuration de la carte `LAN-VIDEO`.

Si besoin :

1. désinstaller LANCast ;
2. remettre la carte réseau dans un état propre ;
3. relancer l'installation avec les bonnes valeurs.

## Deux Sources ont le même nom

Symptômes possibles :

- le Viewer affiche le mauvais poste ;
- le flux change de manière incohérente ;
- une Source répond à la place d'une autre.

Correction : attribuer un `SourceId` unique à chaque poste.

## Méthode de diagnostic recommandée

Toujours revenir à un test minimal :

1. PC01 Viewer seul ;
2. PC02 Source seule ;
3. validation de `PC02-ECRAN1` ;
4. ajout des autres Sources une par une.

Cela évite de chercher une panne globale alors qu'une seule Source est mal configurée.
