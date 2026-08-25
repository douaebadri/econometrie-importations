# Analyse économétrique des importations

Étude de la relation entre les **importations (M)**, le **PIB**, l'**indice
des prix à la consommation (IPC)** et une **variable de tendance**, sur la
période **1960–2017**.

## Méthodologie

1. Collecte et nettoyage des données (1960–2017)
2. Transformation logarithmique des variables (`log(M)`, `log(PIB)`, `log(IPC)`)
3. Estimation d'un modèle de régression linéaire multiple (MCO)
4. Tests économétriques de diagnostic :
   - Multicolinéarité (VIF)
   - Hétéroscédasticité (test de Breusch-Pagan)
   - Autocorrélation (test de Durbin-Watson)
   - Normalité des résidus (test de Jarque-Bera)
5. Interprétation économique des résultats

## Modèle estimé

```
log(M) = β0 + β1 · log(PIB) + β2 · log(IPC) + β3 · trend + ε
```

## Résultats

| Variable | Coefficient | Significativité |
|---|---|---|
| log(PIB) | 1,794 | *** (p < 0,001) |
| log(IPC) | −1,170 | *** (p < 0,01) |
| Tendance | 0,001 | non significatif (p = 0,89) |

**R² ajusté : 0,993** — le modèle explique 99,3% de la variance des importations.

**Élasticité PIB : 1,79** — une hausse de 1% du PIB est associée à une hausse
de 1,79% des importations (élasticité supérieure à 1, cohérent avec une
économie où les importations croissent plus vite que la production
domestique).

### Diagnostics

| Test | Résultat | Lecture |
|---|---|---|
| VIF (multicolinéarité) | 55 à 423 | Forte colinéarité entre PIB, IPC et tendance — attendu sur des séries macroéconomiques qui partagent une tendance commune |
| Breusch-Pagan (hétéroscédasticité) | p = 0,005 | Hétéroscédasticité présente |
| Durbin-Watson (autocorrélation) | DW = 0,66, p < 0,001 | Autocorrélation positive forte des résidus — signe de non-stationnarité des séries en niveau |
| Jarque-Bera (normalité) | p = 0,42 | Résidus normaux (non rejetée) |

**Limite assumée du modèle :** la colinéarité et l'autocorrélation détectées
sont typiques d'une régression MCO sur des séries temporelles macro non
stationnarisées (tendance commune). Une correction par cointégration
(Engle-Granger) ou un modèle à correction d'erreur (ECM) serait l'étape
suivante pour un travail de recherche plus poussé.

## Reproduire l'analyse

```bash
Rscript analyse_importations.R
```

Génère les résultats de régression, les tests de diagnostic, et
`residus_vs_ajustees.png`.

## Structure du repo

```
Projet-conom-trie/
├── donnees_importations.csv     # données nettoyées (58 lignes, 1960-2017)
├── analyse_importations.R       # script R reproductible (régression + tests)
├── residus_vs_ajustees.png      # graphique de diagnostic
└── sources/                     # fichiers de travail originaux (EViews, RData)
```

## Outils utilisés

R (`lmtest`, `car`, `tseries`) · EViews (analyse exploratoire initiale) · Excel

## Auteur

**Douae Badri**
