# Analyse econometrique des importations
#
# Relation entre les importations (M), le PIB, l'indice des prix a la
# consommation (IPC) et une variable de tendance, sur la periode 1960-2017.
#
# Execution : Rscript analyse_importations.R

packages <- c("lmtest", "car", "tseries")
for (p in packages) {
  if (!requireNamespace(p, quietly = TRUE)) install.packages(p, repos = "https://cloud.r-project.org")
}
library(lmtest)  # Breusch-Pagan, Durbin-Watson
library(car)     # VIF (multicolinearite)
library(tseries) # Jarque-Bera (normalite)

# ---- 1. Donnees ----
df <- read.csv("donnees_importations.csv")
df$trend <- df$annee - min(df$annee) + 1

# Transformation logarithmique (stabilise la variance, interpretation en elasticites)
df$log_M   <- log(df$importations_M)
df$log_PIB <- log(df$pib)
df$log_IPC <- log(df$ipc)

cat("Apercu des donnees :\n")
print(head(df))

# ---- 2. Estimation du modele ----
# log(M) = b0 + b1*log(PIB) + b2*log(IPC) + b3*trend + e
modele <- lm(log_M ~ log_PIB + log_IPC + trend, data = df)

cat("\n==== Resultats de la regression ====\n")
print(summary(modele))

# ---- 3. Tests de diagnostic ----
cat("\n==== Multicolinearite (VIF) ====\n")
print(vif(modele))
cat("Regle usuelle : VIF > 10 signale une colinearite problematique.\n")

cat("\n==== Heteroscedasticite (test de Breusch-Pagan) ====\n")
print(bptest(modele))
cat("H0 : homoscedasticite. p-value < 0.05 -> heteroscedasticite presente.\n")

cat("\n==== Autocorrelation (test de Durbin-Watson) ====\n")
print(dwtest(modele))
cat("Statistique proche de 2 -> pas d'autocorrelation des residus.\n")

cat("\n==== Normalite des residus (test de Jarque-Bera) ====\n")
print(jarque.bera.test(residuals(modele)))
cat("H0 : residus normaux. p-value < 0.05 -> rejet de la normalite.\n")

# ---- 4. Graphique ----
png("residus_vs_ajustees.png", width = 800, height = 600)
plot(fitted(modele), residuals(modele),
     xlab = "Valeurs ajustees", ylab = "Residus",
     main = "Residus vs valeurs ajustees")
abline(h = 0, col = "red", lty = 2)
dev.off()

cat("\nGraphique enregistre : residus_vs_ajustees.png\n")
