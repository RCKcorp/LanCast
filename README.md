# LANCast

LANCast est un proof of concept de diffusion d'écran sur un réseau local dédié avec WebRTC et un petit serveur de signalisation PowerShell.

Le projet distingue deux rôles :

- **Viewer** : poste central qui affiche les flux et héberge le serveur de signalisation ;
- **Source** : poste qui partage un écran ou une fenêtre vers le Viewer.

## Cas d'usage

LANCast est prévu pour un LAN maîtrisé, sans exposition Internet. La configuration d'exemple utilise le réseau privé `10.10.10.0/24`, uniquement comme valeur de démonstration.

## Démarrage

Sous Windows, lancer :

```text
Demarrer_ici.cmd
```

L'assistant appelle `install/Install-LANCast.ps1` et permet de choisir le rôle, l'interface réseau, l'adresse IP et le port.

Exemple de laboratoire :

| Rôle | Adresse d'exemple |
|---|---|
| Viewer | `10.10.10.10` |
| Source 1 | `10.10.10.11` |
| Source 2 | `10.10.10.12` |

Port de signalisation par défaut : `8080`.

## Structure

```text
install/     scripts d'installation et de désinstallation
fichiers/    pages Viewer/Source et serveur de signalisation
docs/        installation, architecture, exploitation et sécurité
```

## Sécurité

Le serveur de signalisation n'implémente pas d'authentification. Il doit rester sur un réseau local de confiance et ne doit pas être publié directement sur Internet.

L'installateur applique également des réglages réseau, pare-feu et navigateur. Lisez [`docs/05_SECURITE.md`](docs/05_SECURITE.md) avant utilisation et testez d'abord sur une machine ou une VM de laboratoire.

Aucun identifiant, secret, certificat ou paramètre propre à une infrastructure réelle ne doit être ajouté au dépôt.

## Documentation

- [`docs/01_INSTALLATION.md`](docs/01_INSTALLATION.md)
- [`docs/02_ARCHITECTURE.md`](docs/02_ARCHITECTURE.md)
- [`docs/03_EXPLOITATION.md`](docs/03_EXPLOITATION.md)
- [`docs/04_DEPANNAGE.md`](docs/04_DEPANNAGE.md)
- [`docs/05_SECURITE.md`](docs/05_SECURITE.md)

## Désinstallation

Lancer `Desinstaller.cmd` en administrateur.
