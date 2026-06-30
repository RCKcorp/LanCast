# Installation LANCast

## Avant de commencer

Prévoir une carte réseau dédiée ou clairement identifiée sur chaque poste. L'idéal est de réserver une interface au réseau vidéo.

Configuration recommandée :

| Poste | Rôle | Adresse IP |
|---|---|---:|
| PC01 | Viewer | 10.10.10.10 |
| PC02 | Source | 10.10.10.11 |
| PC03 | Source | 10.10.10.12 |
| PC04 | Source | 10.10.10.13 |

## Installer le Viewer

Le Viewer est le poste central. Il affiche les flux et héberge le serveur de signalisation.

Étapes :

1. Copier le dépôt sur PC01.
2. Lancer `Demarrer_ici.cmd`.
3. Choisir le rôle `Viewer`.
4. Sélectionner la carte réseau dédiée.
5. Renseigner l'IP locale du Viewer, par exemple `10.10.10.10`.
6. Laisser le port par défaut `8080`, sauf contrainte particulière.

Après installation, vérifier que le serveur répond sur `/health`.

## Installer une Source

Une Source est un poste qui partage son écran ou une fenêtre vers le Viewer.

Étapes :

1. Copier le dépôt sur le poste Source.
2. Lancer `Demarrer_ici.cmd`.
3. Choisir le rôle `Source`.
4. Sélectionner la carte réseau dédiée.
5. Renseigner l'IP locale de la Source.
6. Renseigner l'IP du Viewer.
7. Renseigner le nom de la Source, par exemple `PC02`.

Attention : chaque Source doit avoir un nom différent.

## Points de contrôle après installation

Sur le Viewer :

- La carte réseau dédiée doit porter l'IP prévue.
- La tâche planifiée `LANCast SignalServer` doit exister.
- Le serveur doit répondre sur le port configuré.

Sur une Source :

- Le poste doit joindre l'IP du Viewer.
- Le navigateur doit pouvoir ouvrir la page Source.
- Le nom de la Source doit correspondre au poste réel.

## Désinstallation

Lancer `Desinstaller.cmd` en administrateur.

Le désinstalleur retire les éléments LANCast connus. Le nom de la carte réseau peut rester `LAN-VIDEO`, car le renommer automatiquement peut casser une configuration locale existante.
