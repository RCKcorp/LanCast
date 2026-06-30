# Sécurité et limites

## Usage prévu

LANCast est prévu pour un réseau local maîtrisé. Il n'est pas conçu pour être exposé directement sur Internet.

## Points à connaître

Le serveur de signalisation est volontairement simple. Il permet aux pages Viewer et Source d'échanger les informations nécessaires à la connexion.

Dans une version terrain sur réseau fermé, cette simplicité est pratique. Sur un réseau partagé ou sensible, il faut ajouter des protections.

## Précautions recommandées

- Utiliser un réseau dédié aux flux vidéo.
- Limiter les postes autorisés avec le pare-feu Windows.
- Ne pas exposer le port de signalisation hors du LAN prévu.
- Garder une convention claire pour les noms de Sources.
- Éviter d'utiliser LANCast sur un réseau invité ou non maîtrisé.

## Limites actuelles

- Pas d'authentification utilisateur intégrée.
- Pas de gestion centralisée des droits par poste.
- Pas de chiffrement applicatif ajouté par le projet.
- Le bon fonctionnement dépend du navigateur et des autorisations de capture d'écran.

## Améliorations possibles

- Ajouter un jeton partagé entre Viewer et Sources.
- Restreindre les endpoints du SignalServer par plage IP.
- Ajouter un fichier de configuration unique.
- Ajouter un journal d'événements plus détaillé côté serveur.
- Ajouter une page d'administration locale.

## Règle simple

Si le réseau n'est pas maîtrisé, ne pas considérer LANCast comme sécurisé par défaut.
