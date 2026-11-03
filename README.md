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

```

# 🐚 VSH - Virtual Shell (Bash-based Virtual Shell)

An interactive command-line environment (Virtual Shell) written entirely in **Bash**, designed to manipulate, navigate, and save an isolated virtual file tree completely detached from the host system.

---

## 📌 Table of Contents

* [Features](https://www.google.com/search?q=%23-features)
* [Project Architecture](https://www.google.com/search?q=%23-project-architecture)
* [Installation and Usage](https://www.google.com/search?q=%23-installation-and-usage)
* [Sample Directory Tree](https://www.google.com/search?q=%23-sample-directory-tree)
* [Authors](https://www.google.com/search?q=%23-authors)

---

## ✨ Features

* 📁 **Virtual File Tree Management**: Create, delete, and move virtual directories and files (`mkdir`, `touch`, etc.).
* 🗺️ **Navigation & Directory Traversal**: Full support for absolute and relative paths (`cd`, `pwd`, `ls`).
* ✍️ **File Viewing & Editing**: Read and modify content within virtual files.
* 💾 **Save & Extract**: Persist the state of the virtual tree using archive files.
* 🧩 **Modular Architecture**: Clean separation of core application logic across dedicated shell modules.

---

## 📁 Project Architecture

The project is built on a modular structure where each component manages a specific responsibility:

```text
Projet2/
├── vsh                     # Main executable / Shell entry point
├── libs/                   # Modules & function libraries
│   ├── 00_common.sh        # Shared helper and utility functions
│   ├── 10_list.sh          # Directory listing functions (e.g., ls)
│   ├── 20_create.sh        # Node creation utilities (mkdir, touch)
│   ├── 30_parse.sh         # CLI command syntax parser
│   ├── 40_paths.sh         # Path resolution and management
│   ├── 50_commands_basic.sh# Basic shell commands (cd, pwd, cat, etc.)
│   ├── 60_commands_edit.sh # File content editing functions
│   ├── 70_save.sh          # System state persistence module
│   ├── 80_browse.sh        # File system navigation engine
│   └── 90_extract.sh       # Archive import/export and extraction
├── Exemple_arbo/           # Sample test directory tree for demos
└── archives/               # Storage directory for virtual system snapshots

```
