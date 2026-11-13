# LYYRA-004 | Valinnainen tutustuminen paketteihin
# Ennen tämän skriptin ajamista:
# 1. Avaa projektin scripts-kansiosta install_packages.R.
# 2. Aja koko skripti kerran Source-painikkeella. Se asentaa ggplot2-paketin, jos sitä ei ole vielä asennettu.
# 3. Palaa tähän skriptiin ja aja se.
# Paketteja ei tarvitse asentaa uudelleen jokaisella ajokerralla.
# Ydinharjoitukset 00–04 eivät tarvitse lisäpaketteja.
# Paketti asennetaan yleensä kerran kuhunkin käytettävään R-kirjastoon.
# Uuden R-version asentamisen jälkeen paketti voidaan joutua asentamaan uudelleen.
# Asenna halutessasi Consolessa (tarvitset verkkoyhteyden):
# install.packages("ggplot2", repos = "https://cloud.r-project.org")
# Tämä asennuskomento on kommentti eikä käynnisty skriptiä ajettaessa.

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  message("ggplot2 ei ole vielä asennettu. Aja scripts/install_packages.R ja kokeile sitten uudelleen.")
  message('Jos asennus ei onnistu, tarkista internet-yhteys tai asenna paketti Consolessa: install.packages("ggplot2")')
} else {
  library(ggplot2)
  seuranta <- read.csv("data/seuranta.csv", fileEncoding = "UTF-8",
                       na.strings = "NA", stringsAsFactors = FALSE)
  kuva <- ggplot(seuranta, aes(x = vesipinta_cm)) +
    geom_histogram(binwidth = 5, colour = "white", fill = "steelblue") +
    facet_wrap(~ jakso) +
    labs(x = "Vesipinta (cm)", y = "Mittausten lukumäärä") +
    theme_minimal()
  print(kuva)
  dir.create("tulokset", showWarnings = FALSE)
  ggsave("tulokset/vesipinta_ggplot2.pdf", kuva, width = 7, height = 4)
}
