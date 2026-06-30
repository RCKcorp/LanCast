# Depannage LANCast

## Viewer

A verifier :

1. PC01 a la bonne adresse IP.
2. La carte LAN-VIDEO est active.
3. La tache planifiee `LANCast SignalServer` existe.
4. Le port `8080` est libre.
5. `/health` repond.

## Source

A verifier :

- IP de la Source ;
- IP du Viewer ;
- pare-feu Windows ;
- nom de Source ;
- connexion reseau entre la Source et le Viewer.

Chaque Source doit avoir un nom unique.

## Flux non visible

A verifier :

- navigateur compatible ;
- autorisation locale ;
- choix du bon ecran ;
- reseau stable ;
- interface dediee active.

## Test minimal

1. PC01 Viewer seul.
2. PC02 Source seule.
3. Validation de `PC02-ECRAN1`.
4. Ajout des autres postes un par un.
