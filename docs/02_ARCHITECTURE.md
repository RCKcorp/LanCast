# Architecture LANCast

## Vue d'ensemble

LANCast repose sur trois blocs :

1. le Viewer ;
2. les Sources ;
3. le serveur de signalisation.

Le Viewer demande un flux. La Source reçoit la demande et répond. Le serveur de signalisation sert uniquement à échanger les informations nécessaires à la connexion.

## Schéma logique

```text
PC02 Source  ----\
PC03 Source  -----+---- réseau LAN-VIDEO ---- PC01 Viewer
PC04 Source  ----/                         SignalServer
```

## Rôle du Viewer

Le Viewer est le poste de visualisation. Il permet de choisir les flux à afficher, par exemple :

- `PC02-ECRAN1` ;
- `PC03-ECRAN1` ;
- `PC04-ECRAN2`.

Le Viewer héberge aussi le serveur de signalisation. C'est pour cela qu'il doit être joignable par toutes les Sources.

## Rôle d'une Source

Une Source capture un écran ou une fenêtre et l'envoie au Viewer demandé. Une Source doit avoir un identifiant unique, comme `PC02`.

Le nom de flux est construit avec :

```text
NomSource-NomEcran
```

Exemple :

```text
PC02-ECRAN1
```

## Rôle du SignalServer

`SignalServer.ps1` est un petit serveur HTTP local. Il ne transporte pas le flux vidéo lui-même. Il sert seulement à échanger les offres et réponses WebRTC.

Points importants :

- il tourne sur le Viewer ;
- il écoute sur l'IP choisie pendant l'installation ;
- le port par défaut est `8080` ;
- les endpoints utiles sont `/health`, `/rooms`, `/signal` et `/clear`.

## Réseau conseillé

Utiliser un réseau dédié évite de mélanger les flux vidéo avec le réseau bureautique.

Exemple recommandé :

| Élément | Valeur |
|---|---|
| Nom interface | LAN-VIDEO |
| Réseau | 10.10.10.0/24 |
| Viewer | 10.10.10.10 |
| Sources | 10.10.10.11 à 10.10.10.30 |
| Port signalisation | 8080 |

## Pourquoi le bind IP a été corrigé

L'ancienne version pouvait contenir un préfixe IP codé en dur. Cela rendait le serveur dépendant d'un réseau précis et pouvait empêcher le Viewer de démarrer correctement.

La version corrigée utilise maintenant l'IP choisie pendant l'installation.
