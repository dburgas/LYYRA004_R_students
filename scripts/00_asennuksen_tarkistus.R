# LYYRA-004 | 00 Asennuksen ja projektin tarkistus
# Avaa ensin LYYRA004_R.Rproj. Aja aluksi yksi rivi kerrallaan.
# Tämä skripti käyttää vain R:n mukana tulevia toimintoja.

print(1 + 1)                   # Odotettu tulos: 2
print(R.version.string)        # R:n versio; versionumerosi voi olla eri
print(getwd())                 # Projektin pääkansion polku

# TRUE tarkoittaa, että tiedosto löytyy tästä projektista.
polut <- c("data/seuranta.csv", "R/apufunktiot.R",
           "scripts/01_R_perusteet.R")
polkutarkistus <- data.frame(tiedosto = polut, loytyy = file.exists(polut))
print(polkutarkistus)

# Myös itse luodun projektin nimi saa olla toinen.
projekti_loytyy <- length(list.files(pattern = "[.]Rproj$")) > 0
print(projekti_loytyy)

if (!projekti_loytyy || !all(polkutarkistus$loytyy)) {
  stop("Avaa oikea .Rproj puretusta kansiosta. Tarkista kansiot ja aja uudelleen.",
       call. = FALSE)
}

dir.create("tulokset", showWarnings = FALSE)
raportti <- c("LYYRA-004 asennuksen ja projektin tarkistus",
              paste("R:", R.version.string),
              paste("Projektikansio:", getwd()),
              capture.output(print(polkutarkistus)),
              "", capture.output(sessionInfo()))
writeLines(raportti, "tulokset/asennustarkistus.txt", useBytes = TRUE)
message("Tarkistus onnistui. Raportti: tulokset/asennustarkistus.txt")

# Oma tarkistus:
# 1. Mikä on tämän projektin pääkansion nimi?
# 2. Missä data-kansio on suhteessa pääkansioon?
# Jos pysähdyt virheeseen, tuo tukikerralle virheviesti ja getwd()-tulos.
