########### EXTRACTION IDENTIFIANTS COLLECTIVITES ET EPCI - DATACTIVIST ########### 

library(tidyverse)



#----------------------------------------- REGIONS


# Import comptes consolidés - data OFGL
OFGL_regions <- read_delim("https://data.ofgl.fr/explore/dataset/ofgl-base-regions-consolidee/download/?format=csv&disjunctive.reg_name=true&disjunctive.agregat=true&refine.agregat=D%C3%A9penses+totales&refine.exer=2020&timezone=Europe/Berlin&lang=fr&use_labels_for_header=true&csv_separator=%3B", ";")

# On garde les champs qui nous intéressent 
OFGL_regions <- OFGL_regions[,c(4:7)]

# On les renomme
OFGL_regions <- OFGL_regions %>% rename(COG = `Code Insee 2021 Région`,
                                        nom = `Nom 2021 Région`,
                                        type = `Catégorie`,
                                        SIREN = `Code Siren Collectivité`)
    
# On réordonne 
OFGL_regions <- OFGL_regions[,c(2,4,1,3)]

# On met au bon format les variables 
OFGL_regions$SIREN <- as.numeric(OFGL_regions$SIREN)
OFGL_regions$COG <- as.character(OFGL_regions$COG)

# On trie les observations avec COG par ordre croissant
OFGL_regions <- OFGL_regions %>% arrange(COG)





#----------------------------------------- DEPARTEMENTS


# Import comptes consolidés - data OFGL
OFGL_departements <- read_delim("https://data.ofgl.fr/explore/dataset/ofgl-base-departements-consolidee/download/?format=csv&disjunctive.reg_name=true&disjunctive.dep_tranche_population=true&disjunctive.dep_name=true&disjunctive.agregat=true&refine.exer=2020&refine.agregat=D%C3%A9penses+totales&timezone=Europe/Berlin&lang=fr&use_labels_for_header=true&csv_separator=%3B", ";")

# On garde les champs qui nous intéressent 
OFGL_departements <- OFGL_departements[,c(3,7:10)]

# On les renomme
OFGL_departements <- OFGL_departements %>% rename(COG = `Code Insee 2021 Département`,
                                                  nom = `Nom 2021 Département`,
                                                  type = `Catégorie`,
                                                  code_region = `Code Insee 2021 Région`,
                                                  SIREN = `Code Siren Collectivité`)

# On réordonne 
OFGL_departements <- OFGL_departements[,c(3,5,2,4,1)]

# On modifie le type "DEPT" par "DEP"
OFGL_departements$type <- "DEP"

# On met au bon format les variables 
OFGL_departements$SIREN <- as.numeric(OFGL_departements$SIREN)

# Pour le code de la région on ajoute un "0" pour les COG de 1 à 9
OFGL_departements$code_region <- sprintf("%02d", OFGL_departements$code_region)

# On trie les observations avec COG par ordre croissant
OFGL_departements <- OFGL_departements %>% arrange(COG) 

# On créé une autre colonne du COG du département en mettant cette fois 3 digits (pour permettre les jointures si le COG est entré avec 2 ou 3 digits)
OFGL_departements$COG_3digits <- OFGL_departements$COG
OFGL_departements[c(1:95),]$COG_3digits <- paste0("0", OFGL_departements[c(1:95),]$COG_3digits)

# On ajoute la Corse qui n'est pas présente dans les données
OFGL_departements <- OFGL_departements %>% add_row(nom = c("Corse-du-Sud","Haute-Corse"), SIREN = c(222000028,222000036), COG = c("2A","2B"), type = c("DEP","DEP"), code_region = c("94","94"), COG_3digits = c("02A","02B")) %>% arrange(COG) 





#----------------------------------------- COMMUNES


# Import jeu des comptes consolidés - data OFGL
OFGL_communes <- read_delim("https://data.ofgl.fr/explore/dataset/ofgl-base-communes-consolidee/download/?format=csv&disjunctive.reg_name=true&disjunctive.dep_name=true&disjunctive.epci_name=true&disjunctive.tranche_population=true&disjunctive.tranche_revenu_imposable_par_habitant=true&disjunctive.com_name=true&disjunctive.agregat=true&refine.exer=2020&refine.agregat=D%C3%A9penses+totales&timezone=Europe/Berlin&lang=fr&use_labels_for_header=true&csv_separator=%3B", ";")

# On garde les champs qui nous intéressent 
OFGL_communes <- OFGL_communes[,c(3,5,15:18)]

# On les renomme
OFGL_communes <- OFGL_communes %>% rename(COG = `Code Insee 2021 Commune`,
                                          code_region = `Code Insee 2021 Région`,
                                          code_departement = `Code Insee 2021 Département`,
                                          nom = `Nom 2021 Commune`,
                                          type = `Catégorie`,
                                          SIREN = `Code Siren Collectivité`)

# On réordonne 
OFGL_communes <- OFGL_communes[,c(4,6,3,5,1,2)]

# On modifie le type "Commune" par "COM"
OFGL_communes$type <- "COM"

# On passe le numéro SIREN au format numérique
OFGL_communes$SIREN <- as.numeric(OFGL_communes$SIREN)

# On trie les observations avec COG par ordre croissant
OFGL_communes <- OFGL_communes %>% arrange(COG)

# On supprime le doublon
n_distinct(OFGL_communes)  #Les Trois Lacs en 2 fois
OFGL_communes <- OFGL_communes %>% unique()

# On créé aussi la colonne du COG de département avec 3 digits
OFGL_communes$code_departement_3digits <- OFGL_communes$code_departement
OFGL_communes[c(1:34808),]$code_departement_3digits <- paste0("0", OFGL_communes[c(1:34808),]$code_departement_3digits)





#------------------------------------------- TOUTES COLL


# On regroupe ces 3 niveaux de collectivités pour avoir toutes les informations en une seule base
infos_coll <- rbind(OFGL_regions, 
                    OFGL_departements[,c(1:4)], 
                    OFGL_communes[,c(1:4)])




#----------------------------------------- INTERCO (juste SIREN et noms)


# Import comptes consolidés - data OFGL 
OFGL_interco <- read_delim("https://data.ofgl.fr/explore/dataset/ofgl-base-gfp-consolidee/download/?format=csv&disjunctive.dep_name=true&disjunctive.gfp_tranche_population=true&disjunctive.nat_juridique=true&disjunctive.mode_financement=true&disjunctive.gfp_tranche_revenu_imposable_par_habitant=true&disjunctive.epci_name=true&disjunctive.agregat=true&refine.exer=2020&refine.agregat=D%C3%A9penses+totales&timezone=Europe/Berlin&lang=fr&use_labels_for_header=true&csv_separator=%3B", ";")

# On garde les champs qui nous intéressent 
OFGL_interco <- OFGL_interco[,c(3,5,8,12,13)]

# On les renomme
OFGL_interco <- OFGL_interco %>% rename(nom = `Nom 2021 EPCI`,
                                        type = `Nature juridique 2021 abrégée`,
                                        code_region = `Code Insee 2021 Région`,
                                        code_departement = `Code Insee 2021 Département`,
                                        SIREN = `Code Siren 2021 EPCI`)

# On réordonne 
OFGL_interco <- OFGL_interco[,c(5,4,3,1,2)]

# On modifie le type "M" par "MET"
OFGL_interco$type <- str_replace_all(OFGL_interco$type, c("MET69" = "M",  #cas spécifique pour la métropole de Lyon
                                                          "M" = "MET"))

# On passe le numéro SIREN au format numérique
OFGL_interco$SIREN <- as.numeric(OFGL_interco$SIREN)

# On trie les observations avec COG par ordre croissant
OFGL_interco <- OFGL_interco %>% arrange(nom)

# On créé aussi la colonne du COG de département avec 3 digits
OFGL_communes <- OFGL_communes %>% mutate(test = as.character(sprintf("%03d", as.integer(code_departement))))



#------------------------------------------- EXPORT


# On exporte toutes ces bases qui aideront pour croiser des variables de différents jeux quand les noms d'organisation ne sont pas exactement les mêmes
rio::export(OFGL_regions, paste("./Data/identifiants_regions_", format(Sys.Date(), "%Y"), ".csv", sep = ""))
rio::export(OFGL_departements, paste("./Data/identifiants_departements_", format(Sys.Date(), "%Y"), ".csv", sep = ""))
rio::export(OFGL_communes, paste("./Data/identifiants_communes_", format(Sys.Date(), "%Y"), ".csv", sep = ""))
rio::export(infos_coll, paste("./Data/identifiants_collectivites_", format(Sys.Date(), "%Y"), ".csv", sep = ""))
rio::export(OFGL_interco, paste("./Data/identifiants_epci_", format(Sys.Date(), "%Y"), ".csv", sep = ""))


