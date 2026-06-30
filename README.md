# LANCast

LANCast est un projet de diffusion d'écrans en réseau local. Il sert à afficher les écrans de plusieurs postes Source sur un poste Viewer, sans dépendre d'un service cloud.

Le projet est prévu pour un réseau isolé ou maîtrisé, par exemple une salle de supervision, une salle de démonstration ou un banc de test.

## Objectif simple

- Un poste Viewer reçoit et affiche les flux.
- Les postes Source partagent leur écran ou une fenêtre.
- Un petit serveur de signalisation fait le lien entre le Viewer et les Sources.
- Les échanges passent par le réseau local dédié.

## Rôles des machines

| Rôle | Exemple | Fonction |
|---|---:|---|
| Viewer | PC01 | Affiche les flux vidéo et héberge le serveur de signalisation. |
| Source | PC02 à PC11 | Capture l'écran ou une fenêtre et l'envoie au Viewer. |
| Réseau vidéo | 10.10.10.0/24 | Réseau local dédié aux flux LANCast. |

## Arborescence du dépôt

| Chemin | Description |
|---|---|
| `Demarrer_ici.cmd` | Lance l'installation avec élévation administrateur. |
| `Desinstaller.cmd` | Lance la désinstallation. |
| `install/Install-LANCast.ps1` | Script principal d'installation Viewer ou Source. |
| `install/Uninstall-LANCast.ps1` | Script de nettoyage du poste. |
| `fichiers/SignalServer.ps1` | Serveur de signalisation utilisé par WebRTC. |
| `fichiers/LANCast_Viewer_PC01.html` | Page utilisée sur le poste Viewer. |
| `fichiers/LANCast_Source_MultiFlux.html` | Page utilisée sur les postes Source. |
| `docs/` | Documentation terrain : installation, architecture, dépannage, sécurité. |

## Installation rapide

1. Télécharger ou cloner le dépôt sur le poste concerné.
2. Lancer `Demarrer_ici.cmd` en administrateur.
3. Choisir le rôle : `Viewer` pour PC01 ou `Source` pour PC02 à PC11.
4. Renseigner la carte réseau dédiée et les adresses IP demandées.
5. Ouvrir le raccourci créé pour lancer le Viewer ou la Source.

Configuration type :

| Poste | Rôle | IP |
|---|---|---:|
| PC01 | Viewer | 10.10.10.10 |
| PC02 | Source | 10.10.10.11 |
| PC03 | Source | 10.10.10.12 |

## Ce qui a été corrigé dans cette version

- Le serveur de signalisation n'utilise plus un préfixe IP codé en dur.
- Le Viewer démarre le serveur sur l'IP choisie pendant l'installation.
- Le test de santé utilise l'adresse réelle du Viewer.
- Le CIDR réseau est mieux pris en compte.
- L'état d'installation est écrit plus tôt pour faciliter la désinstallation en cas d'erreur.
- Le dépôt est organisé pour être compréhensible par un technicien qui découvre le projet.

## Documentation conseillée

- `docs/README.md` : point d'entrée de la documentation.
- `docs/01_INSTALLATION.md` : procédure d'installation claire.
- `docs/02_ARCHITECTURE.md` : explication technique simple.
- `docs/03_EXPLOITATION.md` : utilisation terrain.
- `docs/04_DEPANNAGE.md` : pannes fréquentes et contrôles.
- `docs/05_SECURITE.md` : limites et précautions.

## Statut

Le dépôt contient la structure propre et les scripts corrigés. Les pages HTML Viewer et Source doivent rester alignées avec la dernière livraison validée avant un déploiement terrain.
