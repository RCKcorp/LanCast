# Documentation LANCast

Cette documentation est organisée pour être utilisée sur le terrain par un technicien.

## Ordre de lecture conseillé

1. `01_INSTALLATION.md` : installer un Viewer ou une Source.
2. `02_ARCHITECTURE.md` : comprendre le fonctionnement général.
3. `03_EXPLOITATION.md` : utiliser LANCast après installation.
4. `04_DEPANNAGE.md` : diagnostiquer les problèmes fréquents.
5. `05_SECURITE.md` : connaître les limites et les précautions.

## Résumé en une phrase

LANCast permet de diffuser les écrans de plusieurs postes vers un poste Viewer sur un réseau local dédié.

## Vocabulaire

| Terme | Signification |
|---|---|
| Viewer | Poste qui affiche les flux vidéo. En général PC01. |
| Source | Poste qui partage son écran. En général PC02 à PC11. |
| SignalServer | Petit serveur HTTP utilisé pour échanger les informations de connexion. |
| Room | Nom logique d'un flux, par exemple `PC02-ECRAN1`. |
| LAN-VIDEO | Nom conseillé pour la carte réseau dédiée à LANCast. |
