Installation automatisée de Docker, Docker Compose et Portainer sur Ubuntu

Ce script Bash automatise l'installation de Docker Engine, Docker Compose et Portainer sur une machine Ubuntu. Il est conçu pour simplifier le déploiement de ces outils essentiels pour la gestion et l'orchestration de conteneurs.
Table des matières

    Prérequis
    Fonctionnalités
    Installation
    Utilisation
    Désinstallation
    Notes supplémentaires
    Licence

Prérequis

    Système d'exploitation : Ubuntu 18.04 ou supérieur.
    Accès root : Le script doit être exécuté avec des privilèges root.

Fonctionnalités

    Mise à jour automatique des paquets système.
    Installation des dépendances requises.
    Ajout du dépôt officiel de Docker et vérification de la clé GPG.
    Installation de Docker Engine et du plugin Docker Compose.
    Activation et démarrage du service Docker.
    Installation et déploiement de Portainer pour la gestion des conteneurs via une interface web.
    Détection automatique de l'adresse IP de la machine pour un accès facile à Portainer.

Installation
1. Téléchargement du script

Clonez le dépôt GitHub ou téléchargez directement le script :

git clone https://github.com/votre-utilisateur/votre-repo.git
cd votre-repo

2. Rendre le script exécutable

chmod +x install_docker_portainer.sh

3. Exécuter le script

Lancez le script en tant que root :

sudo ./install_docker_portainer.sh

Utilisation

Une fois le script exécuté avec succès, vous verrez un message indiquant que l'installation est terminée et l'adresse IP pour accéder à Portainer :

[INFO] Installation terminée avec succès !
[INFO] Portainer est disponible sur http://votre_adresse_ip:9000

Ouvrez votre navigateur web et accédez à l'URL fournie pour commencer à utiliser Portainer.
Désinstallation

Pour supprimer Docker, Docker Compose et Portainer de votre système, exécutez les commandes suivantes :

# Arrêter et supprimer le conteneur Portainer
docker stop portainer
docker rm portainer

# Supprimer le volume Portainer
docker volume rm portainer_data

# Désinstaller Docker et ses dépendances
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Nettoyer les paquets inutilisés
sudo apt autoremove -y

Notes supplémentaires

    Vérification de la clé GPG : Le script inclut une étape pour vérifier l'empreinte de la clé GPG de Docker afin de garantir l'intégrité des paquets téléchargés.
    Personnalisation : Si vous souhaitez modifier les ports ou les paramètres de Portainer, vous pouvez ajuster la section du script qui lance le conteneur Portainer.
    Mises à jour : Pour mettre à jour Docker ou Portainer à l'avenir, vous pouvez réexécuter le script ou utiliser les commandes apt et docker appropriées.

Licence

Ce projet est sous licence MIT. Veuillez consulter le fichier LICENSE pour plus d'informations.
