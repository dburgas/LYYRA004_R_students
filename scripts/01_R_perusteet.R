# LYYRA-004 | 01 R:n perusteet
# Tallenna oma kopio: File > Save As > omat/01_R_perusteet_oma.R
# Aja rivejä ylhäältä alas. Ennusta tulos ennen ajamista.
# Harjoituskommentit eivät suorita mitään. Lisää omat vastauksesi omaan kopioon.

# A1 Objekti ja laskutoimitus -----------------------------------------------
pinta_ala_ha <- 4.5
lahopuu_m3_ha <- 12
lahopuu_yhteensa <- pinta_ala_ha * lahopuu_m3_ha
print(lahopuu_yhteensa)          # 54 m3

# TEHTÄVÄ A1: Vaihda pinta-alaksi 6 ja aja lasku uudelleen.
# Selitä miksi myös lahopuu_yhteensa-objektin luova rivi pitää ajaa uudelleen.
# Odotettu uusi tulos on 72 m3.

# A2 Vektori ja alkion valinta ---------------------------------------------
lajimaara <- c(4, 6, 0, 8, NA)
print(lajimaara)
print(length(lajimaara))
print(lajimaara[2])

# TEHTÄVÄ A2: Selvitä vektorin kolmas arvo ja suurin havaittu arvo.
# Vihje: [] valitsee alkion; max(..., na.rm = TRUE) hakee suurimman arvon.

# A3 Funktio ja argumentti -------------------------------------------------
print(mean(lajimaara))
print(mean(lajimaara, na.rm = TRUE))
print(sum(is.na(lajimaara)))

# TEHTÄVÄ A3: Miksi ensimmäinen keskiarvo on NA ja toinen 4.5?
# Miksi nolla jää laskuun? Mitä na.rm = TRUE tekee?

# A4 Muuta syötettä ja tulkitse --------------------------------------------
# TEHTÄVÄ A4: Luo oma vektori c(2, 4, 6, NA). Laske sen keskiarvo
# puuttuva arvo ohittaen ja selvitä puuttuvien arvojen määrä.
# Lisää oma laskusi tämän kommentin alle. Älä poista nollia yleisenä sääntönä.

# A5 Koodi ja selitys ------------------------------------------------------
ryhmat <- c("ennallistaminen", "vertailu")
print(ryhmat)
print(class(ryhmat))

# TEHTÄVÄ A5: Lisää omaan skriptiisi #-kommentti, joka kertoo mitä opit.
# Tarkista ratkaisut vasta oman yrityksen jälkeen: ratkaisut/01_ratkaisut.R
