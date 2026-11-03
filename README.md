Serveur d'archives & Shell Virtuel (`vsh`)

# 🐚 VSH - Shell Virtuel Interactif & Système de Fichiers en Mémoire

Un interpréteur de ligne de commande interactif (**Virtual Shell**) développé en **Bash (Linux/UNIX)**. Il permet de parcourir, manipuler et sauvegarder une arborescence de fichiers virtuelle entièrement isolée en mémoire vive, garantissant une étanchéité complète vis-à-vis du système d'exploitation hôte.

---

## 📌 Table des Matières
- [Présentation Générale](#-présentation-générale)
- [Fonctionnalités Clés](#-fonctionnalités-clés)
- [Modèle Mémoire & Architecture Modulaire](#-modèle-mémoire--architecture-modulaire)
- [Rôle & Contributions Individuelles](#️-rôle--contributions-individuelles)
- [Tests & Validation des Cas Limites](#-tests--validation-des-cas-limites)
- [Structure du Projet](#-structure-du-projet)
- [Démonstration en Ligne de Commande](#-démonstration-en-ligne-de-commande)
- [Guide de Démarrage Rapide](#-guide-de-démarrage-rapide)
- [Auteurs](#-auteurs)
- [English Version](#-english-version)

---

## 🧭 Présentation Générale
`vsh` offre un environnement CLI autonome. Les commandes exécutées au sein de ce shell virtuel manipulent une arborescence dynamique en mémoire vive sans modifier le disque ou les fichiers du système d'exploitation sous-jacent, tout en reproduisant fidèlement le comportement des utilitaires standards POSIX.

---

## ✨ Fonctionnalités Clés
* 📁 **Opérations sur Système de Fichiers Virtuel** : Création, renommage, suppression et déplacement de dossiers et fichiers virtuels (`mkdir`, `touch`, `rm`).
* 🗺️ **Résolution Complète des Chemins** : Prise en charge des chemins absolus (`/var/log/demo`) et relatifs (`./`, `../`, `../../`).
* ✍️ **Consultation & Édition de Contenu** : Visualisation (`cat`), ajout et modification du contenu textuel des fichiers virtuels.
* 💾 **Persistance d'État par Instantanés** : Sérialisation complète de l'arborescence mémoire sous forme d'archives compressées pour sauvegarder et restaurer des sessions de travail.
* 🧩 **Architecture Découplée** : Séparation modulaire des fonctionnalités en bibliothèques de fonctions spécialisées sous `libs/`.

---

## ⚙️ Modèle Mémoire & Architecture Modulaire

```text
Système Hôte (Protégé & Isolé)
       │
   [ ./vsh ] ── Moteur d'exécution interactif principal
       ├── libs/00_common.sh     ── Variables d'environnement & utilitaires
       ├── libs/30_parse.sh      ── Moteur d'analyse syntaxique (tokenisation)
       ├── libs/40_paths.sh      ── Résolution des chemins & contrôle de franchissement
       ├── libs/80_browse.sh     ── Pointeur de navigation ($VIRTUAL_PWD)
       └── libs/70_save.sh       ── Sérialisation & persistance des instantanés

```

* **Moteur d'Analyse Syntaxique (`30_parse.sh`)** : Analyse les commandes utilisateur via des expressions régulières POSIX, gère l'extraction des drapeaux/options (`-l`, `-a`) et traite les chaînes avec guillemets et espaces.
* **Résolution Canonique des Chemins (`40_paths.sh`)** : Évalue les références relatives (`..`) par rapport à un pointeur virtuel interne, interdisant formellement toute fuite en dehors de la racine virtuelle (`/`).
* **Instantanés & Intégrité (`70_save.sh`, `90_extract.sh`)** : Exporte l'état mémoire sous forme d'archives avec vérification de sommes de contrôle (checksums SHA-256) pour garantir la fiabilité des restaurations.

---

## 🛠️ Rôle & Contributions Individuelles

* **Moteur d'Analyse Syntaxique (Parser)** : Conception de l'analyseur lexical (`30_parse.sh`) assurant la découpe des commandes, l'élimination des espaces superflus et le rejet des syntaxes invalides.
* **Contrôle de Franchissement & Sécurité de Parcours** : Développement de la bibliothèque de résolution canonique (`40_paths.sh`), empêchant les attaques de type *Path Traversal* en bloquant l'évasion au-delà de la racine virtuelle.
* **Gestionnaires CRUD en Mémoire** : Développement des modules de listage récursif (`10_list.sh`) et de manipulation des nœuds virtuels (`20_create.sh`, `60_commands_edit.sh`).
* **Suites de Tests Automatisées** : Rédaction de scripts de tests de régression validant la conformité POSIX, le chaînage complexe de commandes et la résistance aux entrées mal formées.

---

## 🧪 Tests & Validation des Cas Limites

La robustesse de `vsh` a été validée à travers plusieurs scénarios de tests automatisés :

* **Résistance aux Attaques par Traversée de Répertoire** : Injection de séquences de contournement (ex. `cd ../../../../../../`) pour certifier que le pointeur se verrouille strictement à la racine `/`.
* **Traitement des Entrées Malveillantes / Mal Formées** : Vérification de la gestion propre des guillemets non refermés, des caractères d'échappement et des arguments inattendus avec messages d'erreur explicites.
* **Intégrité Binaire des Sauvegardes** : Comparaison des empreintes cryptographiques (SHA-256) avant sauvegarde et après restauration d'une session.

---

## 📁 Structure du Projet

```text
Projet2/
├── vsh                  # Script exécutable principal / Point d'entrée
├── libs/                # Bibliothèques de fonctions modulaires
│   ├── 00_common.sh     # Utilitaires communs et initialisation
│   ├── 10_list.sh       # Fonctions d'affichage et listage (ls)
│   ├── 20_create.sh     # Fonctions de création (mkdir, touch)
│   ├── 30_parse.sh      # Analyseur syntaxique des commandes CLI
│   ├── 40_paths.sh      # Résolution et normalisation des chemins
│   ├── 50_commands_basic.sh # Commandes de base (cd, pwd, cat)
│   ├── 60_commands_edit.sh  # Fonctions d'édition de contenu
│   ├── 70_save.sh       # Module de sérialisation et sauvegarde
│   ├── 80_browse.sh     # Moteur de navigation et pointeurs mémoire
│   └── 90_extract.sh    # Module de restauration et d'extraction
├── Exemple_arbo/        # Arborescence de démonstration
└── archives/            # Dossier de stockage des instantanés

```

---

## 📸 Démonstration en Ligne de Commande

```text
[vsh: /]$ mkdir workspace && cd workspace
[vsh: /workspace]$ touch test.txt
[vsh: /workspace]$ echo "Execution isolee en memoire" > test.txt
[vsh: /workspace]$ ls -l
-rw-r--r--  1 vshuser  vshgroup    28B  test.txt
[vsh: /workspace]$ cd ../../../
[vsh: /]$ pwd
/
[vsh: /]$ save session_backup.vsh
[+] Etat virtuel serialise avec succes dans archives/session_backup.vsh

```

---

## 🚀 Guide de Démarrage Rapide

### Prérequis

* Système d'exploitation UNIX/Linux (Ubuntu, Debian, macOS ou WSL2 sous Windows)
* GNU Bash 4.4 ou supérieur

### Exécution

1. Cloner le dépôt :
```bash
git clone [https://github.com/mathieurdw/Serveur-d-archives-sous-Linux.git](https://github.com/mathieurdw/Serveur-d-archives-sous-Linux.git)
cd Serveur-d-archives-sous-Linux

```


2. Attribuer les permissions d'exécution :
```bash
chmod +x vsh libs/*.sh

```


3. Lancer le shell virtuel :
```bash
./vsh

```



---

## 👥 Auteurs

* **Mathieu Royer Dacre Wright** ([Profil GitHub](https://www.google.com/search?q=https://github.com/mathieurdw)) - Architecture, Parser & Gestion des Chemins
* Collaborateurs de projet académique (UTT)

---

---

# 🌐 English Version

# 🐚 VSH - Virtual Shell & In-Memory Filesystem Emulator

An interactive command-line environment (**Virtual Shell**) written in **Bash (Linux/UNIX)**. It enables users to navigate, manipulate, and persist an in-memory virtual file tree in complete isolation from the host operating system.

---

## 📌 Table of Contents

* [Overview](https://www.google.com/search?q=%23-overview)
* [Key Features](https://www.google.com/search?q=%23-key-features-1)
* [Memory Model & Technical Architecture](https://www.google.com/search?q=%23-memory-model--technical-architecture-1)
* [My Role & Individual Contributions](https://www.google.com/search?q=%23%EF%B8%8F-my-role--individual-contributions-1)
* [Testing & Edge-Case Validation](https://www.google.com/search?q=%23-testing--edge-case-validation-1)
* [Project Directory Structure](https://www.google.com/search?q=%23-project-directory-structure-1)
* [Terminal Execution Demo](https://www.google.com/search?q=%23-terminal-execution-demo)
* [Quickstart & Usage](https://www.google.com/search?q=%23-quickstart--usage-1)
* [Authors](https://www.google.com/search?q=%23-authors-1)

---

## 🧭 Overview

`vsh` operates as an isolated command-line layer. File tree modifications, directory navigation, and file reads/writes remain strictly within transient memory pointers. This guarantees zero unintended modifications to the underlying host filesystem while maintaining standard POSIX CLI behavior.

---

## ✨ Key Features

* 📁 **In-Memory Filesystem CRUD**: Create, rename, edit, and delete virtual nodes (`mkdir`, `touch`, `rm`).
* 🗺️ **Comprehensive Path Resolution**: Native support for absolute (`/var/log/demo`) and relative (`./`, `../`, `../../`) paths.
* ✍️ **File Viewing & Editing**: Read (`cat`), append, and modify textual content within virtual files.
* 💾 **Session State Persistence**: Serialize the in-memory tree state into compressed snapshots to backup and restore work sessions.
* 🧩 **Modular Architecture**: Decoupled execution model where logic is partitioned across specialized script modules under `libs/`.

---

## ⚙️ Memory Model & Technical Architecture

```text
Protected Host Operating System
       │
   [ ./vsh ] ── Interactive CLI Loop Engine
       ├── libs/00_common.sh     ── Shared variables & environment setup
       ├── libs/30_parse.sh      ── Command tokenizer & syntax analyzer
       ├── libs/40_paths.sh      ── Canonical path resolver & sandbox boundary
       ├── libs/80_browse.sh     ── In-memory pointer management ($VIRTUAL_PWD)
       └── libs/70_save.sh       ── Tree serialization & snapshot persistence

```

* **Syntax Parsing Engine (`30_parse.sh`)**: Tokenizes user input via POSIX regular expressions, isolating command flags (`-l`, `-a`), arguments, and handling quoted strings containing spaces.
* **Canonical Path Resolver (`40_paths.sh`)**: Evaluates parent directory references (`..`) against an internal pointer, strictly preventing sandbox breakout beyond the virtual root (`/`).
* **Snapshot Archiving (`70_save.sh`, `90_extract.sh`)**: Serializes virtual trees into compressed archives verified with cryptographic SHA-256 hashes to guarantee data integrity across sessions.

---

## 🛠️ My Role & Individual Contributions

* **Command Parser Implementation**: Authored the syntax analyzer (`30_parse.sh`), implementing whitespace normalization, escape character handling, and invalid command token filtering.
* **Sandbox Security & Path Traversal Mitigation**: Engineered the path resolution library (`40_paths.sh`), ensuring relative traversal sequences (`cd ../../`) cannot escape the virtual sandbox boundary.
* **In-Memory CRUD Handlers**: Built the core logic for recursive listing (`10_list.sh`) and virtual filesystem node manipulation (`20_create.sh`, `60_commands_edit.sh`).
* **Automated Regression Verification**: Authored test scripts validating POSIX compliance, chained commands, and system behavior under malformed inputs.

---

## 🧪 Testing & Edge-Case Validation

The engine was evaluated against critical operating constraints:

* **Directory Traversal Mitigation**: Injected deep traversal sequences (e.g., `cd ../../../../../`) to verify that pointer resolution clamps reliably at `/`.
* **Malformed Input Resilience**: Confirmed that unclosed quotes, special characters, and unsupported flags trigger graceful error messages without shell crashes.
* **Snapshot Consistency**: Verified bit-level integrity by comparing cryptographic hashes before archiving and after restoration.

---

## 📁 Project Directory Structure

```text
Projet2/
├── vsh                  # Main executable script / Entry point
├── libs/                # Modular function libraries
│   ├── 00_common.sh     # Utility functions and shared environment
│   ├── 10_list.sh       # Directory listing logic (ls)
│   ├── 20_create.sh     # Node creation logic (mkdir, touch)
│   ├── 30_parse.sh      # CLI syntax parser
│   ├── 40_paths.sh      # Path canonicalization & resolution
│   ├── 50_commands_basic.sh # Core commands (cd, pwd, cat)
│   ├── 60_commands_edit.sh  # In-memory file content editor
│   ├── 70_save.sh       # Serialization & snapshot module
│   ├── 80_browse.sh     # In-memory navigation engine
│   └── 90_extract.sh    # Snapshot extraction and restore
├── Exemple_arbo/        # Sample file tree for demos
└── archives/            # Persistent snapshot storage

```

---

## 📸 Terminal Execution Demo

```text
[vsh: /]$ mkdir workspace && cd workspace
[vsh: /workspace]$ touch test.txt
[vsh: /workspace]$ echo "Isolated execution in volatile memory" > test.txt
[vsh: /workspace]$ ls -l
-rw-r--r--  1 vshuser  vshgroup    38B  test.txt
[vsh: /workspace]$ cd ../../../
[vsh: /]$ pwd
/
[vsh: /]$ save session_backup.vsh
[+] Virtual tree state successfully serialized to archives/session_backup.vsh

```

---

## 🚀 Quickstart & Usage

### Prerequisites

* Linux/UNIX environment (Ubuntu, Debian, macOS, or WSL2 on Windows)
* GNU Bash 4.4+

### Execution

1. Clone the repository:
```bash
git clone [https://github.com/mathieurdw/Serveur-d-archives-sous-Linux.git](https://github.com/mathieurdw/Serveur-d-archives-sous-Linux.git)
cd Serveur-d-archives-sous-Linux

```


2. Grant execution permissions:
```bash
chmod +x vsh libs/*.sh

```


3. Start the virtual shell:
```bash
./vsh

```

## 👥 Authors

* **Mathieu Royer Dacre Wright** ([GitHub Profile](https://www.google.com/search?q=https://github.com/mathieurdw)) - Architecture, Parser & Path Logic
* Academic project team collaborators (UTT)
