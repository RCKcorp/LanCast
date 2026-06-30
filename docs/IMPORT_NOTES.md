# Notes d'import LANCast

Import réalisé depuis `Livraison_LANCast_v2.zip`.

## Corrections appliquées

- Suppression du bind IP codé en dur dans `SignalServer.ps1`.
- Ajout des paramètres `-BindIp` et `-InterfaceAlias` au serveur de signalisation.
- Correction du test `/health` pour utiliser l'IP réelle du Viewer.
- Installation Viewer avec tâche planifiée qui démarre le serveur sur l'IP locale choisie.
- Préparation du rollback via `install-state.json`.
- Nettoyage du paquet : suppression du doublon de dossier et exclusion de `.obsidian`.

## Attention

Les deux pages HTML complètes du ZIP original ont été gardées dans le paquet corrigé local fourni par ChatGPT. Dans le dépôt GitHub, des placeholders ont été posés pour éviter un blocage d'import automatique sur les gros fichiers HTML. Pour un déploiement terrain, remplacer :

- `fichiers/LANCast_Viewer_PC01.html`
- `fichiers/LANCast_Source_MultiFlux.html`

par les versions complètes du paquet `LanCast_corrige.zip`.
