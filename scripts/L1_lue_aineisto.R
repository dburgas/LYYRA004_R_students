# Yhteinen alustus. Jokainen opetuskerran skripti lukee tämän source()-rivillä.
# Se varmistaa, että tiedot ja muuttujat ovat samat myös uudessa R-istunnossa.
if (!file.exists("data/pilis-species-2025.csv")) {
  stop(paste("Avaa LYYRA004_R.Rproj projektikansiosta.",
             "Valitse tarvittaessa Session > Set Working Directory > To Project Directory.",
             "getwd() näyttää nykyisen työkansion."))
}
tarvittavat <- c("dplyr", "ggplot2", "vegan")
puuttuvat <- tarvittavat[!vapply(tarvittavat, requireNamespace,
                                logical(1), quietly = TRUE)]
if (length(puuttuvat)) stop("Aja ensin scriptis/00_asennus.R. Puuttuu: ",
                           paste(puuttuvat, collapse = ", "))
library(dplyr)
library(ggplot2)
theme_set(theme_minimal(base_size = 13))
dir.create("tulokset", showWarnings = FALSE)

# Tiedostossa erotin on puolipiste ja desimaalierotin piste.
# read.csv2() käyttää oletuksena desimaalipilkkua, joten käytämme read.csv().
pilis <- read.csv("data/pilis-species-2025.csv", sep = ";", dec = ".")
lajit <- c("Aba.ate", "Apt.bom", "Car.cor", "Car.hor",
           "Car.sch", "Car.ull", "Neb.bre", "Pte.mel")
pilis$treatment <- factor(pilis$treatment, levels = c("C", "G", "P", "R", "CC"))
pilis$block <- factor(pilis$block)
pilis$year_f <- factor(pilis$year, levels = 2014:2018)
pilis$plot_id <- interaction(pilis$block, pilis$treatment, drop = TRUE)
comm <- as.matrix(dplyr::select(pilis, all_of(lajit)))
rownames(comm) <- paste(pilis$plot_id, pilis$year, sep = "_")
stopifnot(nrow(pilis) == 150, ncol(comm) == 8,
          !anyNA(pilis), all(comm >= 0), all(comm == round(comm)),
          !anyDuplicated(pilis[c("year", "block", "treatment")]),
          all(rowSums(comm) == pilis$N))

varit <- c(C = "#273C36", G = "#16847A", P = "#6574B4",
           R = "#B36C33", CC = "#CB514A")
selitteet <- c(C = "Vertailumetsä", G = "Pienaukko", P = "Valmistava hakkuu",
              R = "Säästöpuuryhmä", CC = "Avohakkuu")
# Valmiit värit pysyvät samoina myös C/CC-rajauksen jälkeen.
# Opetuksen periaate: tutki kaikki käsittelyt, rajaa sen jälkeen ennalta
# määritelty vertailu C (vertailumetsä) ja CC (avohakkuu).
