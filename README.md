# todo-script
# Script de Gestion des Tâches (TODO)

## Description

Ce projet est un script Bash interactif pour gérer une liste de tâches (TODO). Le script permet de créer, mettre à jour, supprimer, afficher et rechercher des tâches. Il propose également un menu interactif coloré pour une meilleure expérience utilisateur.

## Fonctionnalités

- **Créer une tâche** : Ajout d'une nouvelle tâche avec un identifiant unique, un titre, une description, un lieu, une date et une heure d'échéance, ainsi qu'un statut de complétion.
- **Mettre à jour une tâche** : Modification des détails d'une tâche existante en utilisant son identifiant unique.
- **Supprimer une tâche** : Suppression d'une tâche en utilisant son identifiant unique.
- **Afficher les informations d'une tâche** : Affichage des détails d'une tâche spécifique en utilisant son identifiant unique.
- **Lister les tâches d'un jour donné** : Affichage des tâches complétées et non complétées pour une date spécifique.
- **Rechercher une tâche par titre** : Recherche de tâches en utilisant un mot-clé dans le titre.
- **Afficher les tâches du jour** : Affichage des tâches complétées et non complétées pour la date actuelle.
- **Menu interactif** : Interface utilisateur colorée et interactive pour naviguer entre les différentes fonctionnalités.

## Choix de Conception

1. **Stockage des Données** : Les tâches sont stockées dans un fichier CSV (`tasks.csv`). Chaque ligne représente une tâche avec les champs suivants : ID, Titre, Description, Lieu, Date d'échéance, et Statut de complétion.

2. **Organisation du Code** : Le script est organisé en fonctions pour chaque fonctionnalité (création, mise à jour, suppression, etc.). Cela permet une meilleure lisibilité et maintenabilité du code.

3. **Validation des Entrées** : Des fonctions de validation sont utilisées pour s'assurer que les entrées de l'utilisateur sont correctes (par exemple, format de date, statut de complétion).

4. **Interface Utilisateur** : L'interface utilisateur utilise `figlet` et `lolcat` pour afficher un menu interactif et coloré, rendant l'utilisation du script plus agréable.

## Prérequis

- Bash
- `figlet` (pour les bannières textuelles)
- `lolcat` (pour les couleurs)

## Installation des Dépendances

Pour installer `figlet` et `lolcat`, utilisez les commandes suivantes :

```bash
sudo apt-get install figlet
sudo gem install lolcat

Utilisation

Pour exécuter le script, utilisez la commande suivante dans le terminal :
./todo.sh

Exemple d'Utilisation

Lorsque vous exécutez le script, un menu interactif apparaîtra avec les options suivantes :
=====================================
TODO Menu
=====================================
1. Create a new task
2. Update an existing task
3. Delete a task
4. Show information about a task
5. List tasks of a given day
6. Search for a task by title
7. Display today's tasks
8. Exit
=====================================
Choose an option [1-8]:

Auteurs

    HESSANI Youssef
