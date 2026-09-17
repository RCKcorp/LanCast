# Sécurité

LANCast est conçu pour un réseau local maîtrisé. Il ne doit pas être exposé directement sur Internet.

## Modèle de confiance

- le Viewer et les Sources sont supposés appartenir au même environnement de confiance ;
- le serveur de signalisation n'intègre pas d'authentification ;
- les pages WebRTC et le serveur doivent être limités au LAN prévu ;
- les adresses `10.10.10.x` présentes dans la documentation sont des exemples de laboratoire et ne décrivent aucune infrastructure réelle.

## Modifications effectuées par l'installateur

Le script d'installation peut :

- renommer l'interface réseau sélectionnée en `LAN-VIDEO` ;
- configurer une IPv4 statique ;
- ajouter une route de faible priorité utilisée par le scénario de laboratoire ;
- ajouter une règle de pare-feu Windows pour le sous-réseau configuré ;
- modifier la stratégie Edge `WebRtcLocalIpsAllowedUrls` ;
- créer une tâche planifiée `LANCast SignalServer` exécutée sous `SYSTEM` sur le Viewer.

Ces changements doivent être compris et testés avant utilisation sur un poste important.

## Bonnes pratiques

- tester d'abord sur une VM ou un poste de laboratoire ;
- utiliser une interface réseau dédiée lorsque c'est possible ;
- limiter le pare-feu au sous-réseau réellement utilisé ;
- ne pas ouvrir le port du serveur de signalisation vers Internet ;
- ne pas utiliser LANCast sur un Wi-Fi public ou non maîtrisé ;
- vérifier les stratégies navigateur existantes avant installation ;
- utiliser `Desinstaller.cmd` pour retirer les éléments installés ;
- sauvegarder les réglages réseau importants avant les essais.

## Secrets et données internes

Ne jamais versionner :

- identifiants ou mots de passe ;
- clés privées ou certificats privés ;
- noms DNS ou adresses propres à une infrastructure sensible ;
- captures contenant des informations d'entreprise ;
- journaux d'exploitation réels.

Le dépôt inclut un scan Gitleaks de l'historique Git pour détecter les secrets ajoutés accidentellement.
