# 🐚 VSH - Virtual Shell (Shell Virtuel en Bash)

Un environnement de ligne de commande interactif (Virtual Shell) écrit entièrement en **Bash**, permettant de manipuler, parcourir et sauvegarder une arborescence de fichiers virtuelle isolée du système hôte.

---

## 📌 Table des Matières

- [Fonctionnalités](#-fonctionnalités)
- [Architecture du Projet](#-architecture-du-projet)
- [Installation et Utilisation](#-installation-et-utilisation)
- [Exemple d'Arborescence](#-exemple-darborescence)
- [Auteurs](#-auteurs)

---

## ✨ Fonctionnalités

- 📁 **Gestion d'arborescence virtuelle** : Création, suppression et déplacement de dossiers et fichiers virtuels (`mkdir`, `touch`, etc.).
- 🗺️ **Navigation & Parcours** : Prise en charge des chemins absolus et relatifs (`cd`, `pwd`, `ls`).
- ✍️ **Édition & Consultation** : Lecture et modification du contenu des fichiers virtuels.
- 💾 **Sauvegarde & Extraction** : Persistance de l'état de l'arborescence virtuelle sous forme d'archives.
- 🧩 **Architecture modulaire** : Séparation claire de la logique métier dans des modules spécialisés.

---

## 📁 Architecture du Projet

Le projet repose sur une structure modulaire où chaque composant gère une responsabilité précise :

```text
Projet2/
├── vsh                     # Executable principal / Point d'entrée du Shell
├── libs/                   # Modules & bibliothèques de fonctions
│   ├── 00_common.sh        # Fonctions utilitaires et communes
│   ├── 10_list.sh          # Fonctions de listage (ex: ls)
│   ├── 20_create.sh        # Création d'éléments (mkdir, touch)
│   ├── 30_parse.sh         # Parser syntaxique des commandes CLI
│   ├── 40_paths.sh         # Gestion et résolution des chemins
│   ├── 50_commands_basic.sh# Commandes de base (cd, pwd, cat, etc.)
│   ├── 60_commands_edit.sh # Fonctions d'édition de fichiers
│   ├── 70_save.sh          # Module de sauvegarde de l'état
│   ├── 80_browse.sh        # Moteur de navigation dans l'arborescence
│   └── 90_extract.sh       # Import/Export et extraction d'archives
├── Exemple_arbo/           # Arborescence de test pour les démonstrations
└── archives/               # Emplacement des sauvegardes du système virtuel
