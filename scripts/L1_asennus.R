# Aja kerran ennen harjoituksia. Asennus tarvitsee verkkoyhteyden.
# Koko tidyverseä ei tarvita. Käytämme dplyriä, ggplot2:ta ja vegania.
tarvittavat <- c("dplyr", "ggplot2", "vegan")
puuttuvat <- tarvittavat[!vapply(tarvittavat, requireNamespace,
                                logical(1), quietly = TRUE)]
if (length(puuttuvat)) install.packages(puuttuvat, repos = "https://cloud.r-project.org")

# MYÖHEMMIN GLM/GLMM-osioon. Poista tarvittaessa seuraavat #-merkit.
# tarvittavat <- c("MASS", "glmmTMB", "emmeans", "DHARMa")
# puuttuvat <- tarvittavat[!vapply(tarvittavat, requireNamespace,
#                                 logical(1), quietly = TRUE)]
# if (length(puuttuvat)) install.packages(puuttuvat,
#                                       repos = "https://cloud.r-project.org")
