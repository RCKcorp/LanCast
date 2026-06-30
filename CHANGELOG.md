# Changelog

## v3.1 - Documentation GitHub claire

- Réécriture complète du `README.md` pour expliquer le projet rapidement.
- Ajout d'une documentation découpée par usage : installation, architecture, exploitation, dépannage et sécurité.
- Clarification des rôles Viewer, Source et SignalServer.
- Ajout d'une convention de nommage simple pour les postes et les rooms.
- Ajout d'une section dédiée aux limites de sécurité et aux précautions réseau.

## v3 - Import GitHub corrigé

- Import propre du paquet LANCast dans le dépôt GitHub.
- Nettoyage des doublons présents dans le ZIP de livraison.
- Suppression du dossier `.obsidian` de la livraison.
- Correction du bind IP du serveur de signalisation.
- Correction du test `/health` côté installeur Viewer.
- Préconfiguration automatique du `SourceId` dans la page Source.
- Prise en compte du préfixe CIDR pour l'IP statique.
- Écriture anticipée de `install-state.json` pour faciliter le rollback.
