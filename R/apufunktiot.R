# LYYRA-004 | Yhteiset apufunktiot
# Tämä tiedosto määrittelee funktiot. Se ei lue aineistoa automaattisesti.
# Lataa määrittelyt analyysiskriptin alussa näin:
# source("R/apufunktiot.R", encoding = "UTF-8")

# Puuttuvien arvojen lukumäärä annetussa vektorissa.
puuttuvia <- function(x) {
  sum(is.na(x))
}

# Muuntaa senttimetrit metreiksi. Myös NA säilyy puuttuvana.
cm_metreiksi <- function(x) {
  x / 100
}

# Lukee annetun CSV-tiedoston. Funktio palauttaa taulukon kutsujalle.
# Polku on suhteessa projektin pääkansioon.
lue_seuranta <- function(tiedosto = "data/seuranta.csv") {
  if (!file.exists(tiedosto)) {
    stop(paste("Tiedostoa ei löydy:", tiedosto,
               "Avaa projektin .Rproj ja tarkista tiedoston sijainti."),
         call. = FALSE)
  }
  read.csv(tiedosto, fileEncoding = "UTF-8", na.strings = "NA",
           stringsAsFactors = FALSE)
}
