#!/bin/bash

set -e  # Arrête le script en cas d'erreur

# Vérification des privilèges root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script en tant que root."
    exit 1
fi

# Fonction pour afficher un message informatif
function info {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

# Mise à jour des paquets système
info "Mise à jour des paquets système..."
apt update && apt upgrade -y

# Installation des dépendances requises
info "Installation des dépendances requises..."
apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Ajout de la clé GPG officielle de Docker
info "Ajout de la clé GPG officielle de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Vérification de l'empreinte de la clé GPG
DOCKER_GPG_FINGERPRINT="9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
RECEIVED_FINGERPRINT=$(gpg --show-keys /etc/apt/keyrings/docker.gpg | grep 'pub' -A 1 | tail -n 1 | awk '{print $1}')
if [ "$RECEIVED_FINGERPRINT" != "${DOCKER_GPG_FINGERPRINT// /}" ]; then
    echo "La clé GPG de Docker ne correspond pas à l'empreinte attendue."
    exit 1
fi

# Ajout du dépôt Docker
info "Ajout du dépôt Docker..."
ARCHITECTURE=$(dpkg --print-architecture)
CODENAME=$(lsb_release -cs)
echo \
  "deb [arch=${ARCHITECTURE} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list

# Installation de Docker Engine
info "Installation de Docker Engine..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Activation du service Docker
info "Activation et démarrage du service Docker..."
systemctl enable docker
systemctl start docker

# Vérification de l'installation de Docker
info "Vérification de l'installation de Docker..."
docker --version

# Installation de Portainer
info "Installation de Portainer..."
docker volume create portainer_data
docker run -d \
  -p 8000:8000 \
  -p 9000:9000 \
  --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

# Récupération de l'adresse IP de la machine
IP_MACHINE=$(hostname -I | awk '{print $1}')

info "Installation terminée avec succès !"
info "Portainer est disponible sur http://${IP_MACHINE}:9000"

