Commentaire sur article
=======================

Sujet
-----

Ce dossier contient les fichiers sources pour le contrôle continu de biométrie.
Il s'agit d'un commentaire libre sur l'article _A simple statistical guide for
the analysis of behaviour when data are constrained due to practical or ethical
reasons_ par Laszlo Garamszegie.

Ce commentaire prend la forme d'un article rédigé dans le futur et décrivant
l'utilisation des statistiques en écologie en 2016.
La revue, _Encyclopedia Galactica reviews_, est une revue fictive faisant
référence à l'univers du Cycle de Fondation par Isaac Asimov.


Compilation du document
-----------------------

### Avec `GNU make` (recommandé)

1. `make`
2. (facultatif) `make optimize`
3. `make view` (le viewer par défaut est `zathura`)


### Manuellement

1. Éxécuter le fichier `R/script.R` pour générer les graphiques
2. Compiler le fichier `latex/cr.tex` pour générer le document pdf (compiler 1
   fois avec pdfLaTeX puis une fois avec BibTeX et enfin une fois avec pdfLaTeX)
