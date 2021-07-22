# Identifiants des collectivités territoriales et leurs établissements


### → Motivations pour la création du jeu de données
L’analyse et la visualisation de données à l'échelle des collectivités et EPCI peuvent être entravées par le manque d’harmonisation des noms d’organisation entre les jeux de données provenant de différentes sources. Quelques exemples de variantes :
- “Saône-et-Loire” versus “SAONE ET LOIRE”
- “CA DE CH LONS-EN-CHAMPAGNE" versus “CHALONS EN CHAMPAGNE AGGLOMERATION”

Ainsi, lorsque l’on cherche à croiser des données territoriales de provenances différentes, la mise en correspondance n’est pas possible puisque les noms ne sont pas identiquement les mêmes. La solution consiste donc à utiliser, pour la jointure, des identifiants uniques : les numéros COG (Code Officiel Géographique) et/ou SIREN (Système national d'identification et du répertoire des entreprises et de leurs établissements). Le numéro SIREN est d’autant plus important qu’il est utilisé par l’INSEE pour identifier les EPCI, ces derniers n’ayant pas de COG. Cette correspondance, parfois difficile à produire, est essentielle pour limiter les frictions lors des croisements de données portant sur des territoires, c’est pourquoi nous avons décidé de publier ces jeux de données.

### → Composition du jeu de données
Les bases de données ci-dessous reprennent, pour chaque type d’organisation (régions, départements, communes et intercommunalités), les informations qui permettent de l’identifier. On retrouve ainsi les champs suivants ;
- **nom** : nom de l’organisation
- **COG** : code officiel géographique de l’INSEE (pour les collectivités uniquement)
- **SIREN** : numéro de SIREN (pour les collectivités et les EPCI)
- **type** : type d’organisation
    - _REG=régions,_
    - _CTU=collectivités territoriales uniques,_
    - _DEP=départements,_
    - _COM=communes,_ 
    - _MET=métropoles,_ 
    - _EPT=établissements publics territoriaux,_ 
    - _CA=communautés d’agglomérations,_ 
    - _CU=communautés urbaines,_ 
    - _CC=communautés de communes_
- **code_region** : COG de la région dans laquelle se trouve l’organisation (départements, communes ou EPCI) 
- **code_departement** : COG du département dans lequel se trouve l’organisation (communes ou EPCI) 

Ces différents champs sont disponibles pour les 4 niveaux géographiques, on a donc 5 fichiers:
- **identifiants_regions_YYYY** : informations pour les régions 
- **identifiants_departements_YYYY** : informations pour les départements
- **identifiants_communes_YYYY** : informations pour les communes
- **identifiants_collectivites_YYYY** : informations pour les 3 niveaux de collectivités à savoir : régions + départements + communes
- **identifiants_epci_YYYY** : informations pour les EPCI

Les fichiers sont disponibles au format CSV encodés en UTF-8, avec un séparateur virgule.

### → Processus de collecte des données
Les données sont extraites des comptes consolidés, collectés par l’observatoire des finances et de la gestion publique locales (OFGL) et mis à disposition sur leur [portail data](https://data.ofgl.fr/explore/?exclude.theme=INTERNE&sort=title).
Dans les jeux de données des comptes consolidés chaque organisation est identifiée par son nom, ses identifiants COG et/ou SIREN ainsi que son type. 
Pour limiter la taille de la base à l’import, seule 1 année (2020) et 1 agrégat (celui des dépenses totales) ont été sélectionnées, le but étant uniquement de récupérer les identifiants des organisations. Bien que les données des comptes consolidés récupérées concernent l’année 2020, les informations qui nous intéressent, c’est-à-dire celles qui permettent d’identifier les collectivités et EPCI, sont elles à jour de l’année 2021, c’est pourquoi les différents fichiers sont datés de cette année. 
Le processus de collecte a été réalisé en juin 2021.

### → Pré-traitement des données
Comme visible sur le script d’extraction, les données ont été importées puis traitées avant d’être exportées. Les manipulations consistent à garder les champs utiles énumérés ci-dessus, les renommer, les réordonner, trier les observations par COG croissant et mettre au bon format les variables. La standardisation du type d’organisation a aussi été faite pour garder 3 lettres pour les collectivités (REG, COM, DEP). 
Toutes les manipulations ont été réalisées sous R avec les packages tidyverse pour l’import et les manipulations, et rio pour l’export.

### → Diffusion des jeux de données
Les jeux de données sont publiés sur le [portail data.gouv.fr](http://data.gouv.fr/) avec le compte Datactivist sous Licence ouverte comme les fichiers des comptes consolidés de l’OFGL.
Pour citer ce jeu de données, indiquer : source Datactivist (2021-07-20) 

### → Maintenance des jeux de données
Idéalement, la mise à jour devrait être annuelle pour intégrer les modifications du découpage administratif (fusions de communes, modification des compositions d'EPCI...). [Datactivist](http://datactivist.coop/) ne s'engage pas à réaliser cette mise à jour, mais met à disposition les scripts permettant de générer de nouvelles versions..
En cas de question ou de problème, il sera possible de contacter diane@datactivist.coop ou de poster un commentaire ci-dessous.

### → Considérations légales et éthiques
Le jeu de données d’origine a été publié par l’OFGL sous licence ouverte, les informations qu’il contient peuvent donc être utilisées par toute personne, physique ou morale, qui le souhaite. Les données, de nature administrative et géographique, portent sur des collectivités territoriales et leurs établissements, c’est pourquoi leur collecte, ainsi que leur diffusion ne pose aucun problème éthique. 

