Dans ce repo j'utilise MkDocs et Docker pour mettre en place une documentation le plus simplement du monde !

MkDocs est un excellent moyen pour produire rapidement de la documentation.  
Sans trop rentrer dans les détails, c'est un générateur de site statique en Python. On écrit la documentation en MarkDown et la configuration tient dans un fichier YAML.


# Les éléments indispensables...

## Fichier Dockerfile

```
# On télécharge la dernière image
FROM squidfunk/mkdocs-material:latest

# Soit on installe les extensions 1 par 1...
RUN pip install mkdocs-mermaid2-plugin

# ...soit on installe les extension via un fichier requirements.txt.
ADD requirements.txt .

RUN pip install --upgrade pip && pip install -r requirements.txt
```

## Fichier requirements.txt

Si c'est l'option retenue, c'est là que doivent être ajoutées les extensions nécessaires (avec éventuellement la version pour éviter les surprises):

```txt
mkdocs-mermaid2-plugin==1.1.1
...
```

## Fichier mkdocs.yml

C'est l'unique fichier de configuration ! Version commentée en français [ici](https://github.com/ericECmorlaix/base_mkdocs_material/blob/main/mkdocs.yml)

Au minimum, il faut: 

```yml
site_name: Ma super doc !

theme:
  name: 'material'

...
```

## Dossier /docs

C'est le répertoire qui va accueillir les fichiers de la documentation.  
Par défaut, c'est dans le dossier `docs` mais comme toujours, on peut modifier ça...


# Rendre sa documentation accessible

Deux options sont possibles pour lire la documentation...

1. En local

C'est la solution rapide et pratique car on peut voir les changements en temps réel mais c'est complètement déconseillé de lancer le site en production de cette manière !  
A la racine du projet, voici la ligne qu'il faut lancer:

`docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material`

### Détail:

Les options de base: 

- `docker run` va pull l'image et démarrer le container. C'est la base !
- `--rm` indique que le container sera supprimé lorsqu'il ne sera arrêté
- `-it` pour les modes interactif et TTY
- `-p 8080:8000` pour rediriger ou pas sur un autre port (sortie:entrée). Car le port sera `8000` par défaut
- `-v ...` pour bind (lier) le volume

On peut aussi ajouter:

- `-d` pour le mode détaché (le container tourne même si on ferme le terminal)
- `--restart always` pour permettre au container de se relancer automatiquement si besoin. Mais pas compatible avec `--rm`, il faudra faire un choix !
- `--name 'mkdocs'` pour personnaliser le nom du container (quand on fait un docker ps, par exemple)
- `serve -a 0.0.0.0:1234` (à la suite de `squidfunk/mkdocs-material`) pour personnaliser le port 

Pour la doc officielle, c'est par [ici](https://docs.docker.com/reference/cli/docker/container/run/)

2. En production

A la différence de la ligne précédente, cette ligne va uniquement générer la version "statique" du site dans le dossier... `/site`.  
Ensuite, le contenu de ce dossier devra être copié sur le serveur de prod. Soit de manière "artisanale" (scp, ftp, sftp,...), soit de manière automatique (Script bash, Actions GitHub,...)

`docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build`


# Exemple de structure finale

```
.
├── Dockerfile
├── docs
│   └── index.md
├── mkdocs.yml
├── README.md
├── requirements.txt
└── site
    ├── 404.html
    ├── assets
    │   ├── images
    │   │   └── favicon.png
    │   ├── javascripts
    │   │   ├── bundle.8fd75fb4.min.js
    │   │   ├── bundle.8fd75fb4.min.js.map
    │   │   ├── lunr
    │   │   │   ├── min
    │   │   │   │   ├── lunr.ar.min.js
    │   │   │   │   │   ...
    │   │   │   │   └── lunr.zh.min.js
    │   │   │   ├── tinyseg.js
    │   │   │   └── wordcut.js
    │   │   └── workers
    │   │       ├── search.b8dbb3d2.min.js
    │   │       └── search.b8dbb3d2.min.js.map
    │   └── stylesheets
    │       ├── main.f2e4d321.min.css
    │       ├── main.f2e4d321.min.css.map
    │       ├── palette.06af60db.min.css
    │       └── palette.06af60db.min.css.map
    ├── index.html
    ├── search
    │   └── search_index.json
    ├── sitemap.xml
    └── sitemap.xml.gz
```

Et voilà !
