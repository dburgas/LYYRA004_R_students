# LYYRA-004 | 02 Aineiston lukeminen, tarkistus ja ensimmäinen kuva
# Tallenna oma kopio: omat/02_aineisto_ja_kuva_oma.R
# Tämä skripti toimii uudessa R-istunnossa avaamalla projektin ja ajamalla alusta.
# Aineisto on simuloitu opetukseen. Yksi rivi = yhden ruudun yksi käynti.

# B1 Lue alkuperäinen CSV --------------------------------------------------
seuranta <- read.csv("data/seuranta.csv", fileEncoding = "UTF-8",
                     na.strings = "NA", stringsAsFactors = FALSE)
print(head(seuranta))
str(seuranta)
print(dim(seuranta))
print(names(seuranta))

# TEHTÄVÄ B1: Montako riviä ja saraketta on? Mitä yksi rivi tarkoittaa?
# Lue myös data/aineistokuvaus.md.

# B2 Tunnisteet, ryhmät ja puuttuvat arvot ----------------------------------
print(length(unique(seuranta$kohde_id)))
print(length(unique(seuranta$ruutu_id)))
print(table(seuranta$ryhma, seuranta$jakso))
print(sum(is.na(seuranta$rahkasammal_peitto)))

# TEHTÄVÄ B2: Montako kohdetta ja pysyvää ruutua on?
# Montako peittävyysarvoa puuttuu? Miksi 144 riviä ei tarkoita 144 kohdetta?

# B3 Valitse sarake, laske tunnusluku ja rajaa rivejä ------------------------
print(mean(seuranta$rahkasammal_peitto, na.rm = TRUE))
ennen <- subset(seuranta, jakso == "ennen")
print(nrow(ennen))
print(mean(ennen$vesipinta_cm))

# TEHTÄVÄ B3: Rajaa vastaavasti jalkeen-jakso ja laske sen rivimäärä.
# Huomaa: luokan nimi on aineistossa "jalkeen" ilman ääkkösiä.
# == vertailee arvoja. <- tallentaa arvon objektiksi.

# B4 Piirrä jakauma --------------------------------------------------------
hist(ennen$vesipinta_cm,
     main = "Vesipinta ennen",
     xlab = "Vesipinta suhteessa maanpintaan (cm)",
     ylab = "Mittausten lukumäärä",
     col = "lightblue", border = "white")

# TEHTÄVÄ B4: Tee omaan kopioosi vastaava kuva jalkeen-jaksolle.
# Vaihda otsikko vastaamaan valitsemaasi ajanjaksoa.
# Histogrammi kuvaa jakaumaa; se ei yksin osoita toimenpiteen vaikutusta.

# B5 Tallenna kuva ja taulukko ---------------------------------------------
dir.create("tulokset", showWarnings = FALSE)
pdf("tulokset/vesipinta_ennen.pdf", width = 7, height = 5)
hist(ennen$vesipinta_cm,
     main = "Vesipinta ennen",
     xlab = "Vesipinta suhteessa maanpintaan (cm)",
     ylab = "Mittausten lukumäärä",
     col = "lightblue", border = "white")
dev.off()

tarkistus <- data.frame(
  mittari = c("riveja", "sarakkeita", "kohteita", "ruutuja", "puuttuvia_peitto"),
  arvo = c(nrow(seuranta), ncol(seuranta),
           length(unique(seuranta$kohde_id)),
           length(unique(seuranta$ruutu_id)),
           sum(is.na(seuranta$rahkasammal_peitto)))
)
write.csv(tarkistus, "tulokset/aineiston_tarkistus.csv", row.names = FALSE,
          fileEncoding = "UTF-8")
message("Tallennettu: tulokset/vesipinta_ennen.pdf ja aineiston_tarkistus.csv")

# TEHTÄVÄ B5: Tallenna oma jalkeen-kuvasi nimellä vesipinta_jalkeen.pdf.
# Avaa tiedostot ja varmista, että ne sisältävät odottamasi tulokset.
# Lopuksi: tallenna skripti, Session > Restart R, ja aja oma skripti alusta.
# Ratkaisut: ratkaisut/02_ratkaisut.R
