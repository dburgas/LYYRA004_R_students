# LYYRA-004 | 03 Yhteiset funktiot ja skriptien riippuvuudet
# Tallenna oma kopio: omat/03_yhteiset_funktiot_oma.R
# Aloita uudesta R-istunnosta. Tämä skripti lataa itse tarvitsemansa toiminnot.

# C1 Lataa tiedostoon tallennetut funktiomäärittelyt -------------------------
source("R/apufunktiot.R", encoding = "UTF-8")

# source() suorittaa tiedoston koodin. Tässä se määrittelee kolme funktiota.
# Tiedoston avaaminen editoriin ei vielä suorita sen koodia.
# R-kansio ei lataudu automaattisesti projektia avattaessa.

# C2 Lue aineisto funktion palauttamaksi taulukoksi --------------------------
seuranta <- lue_seuranta("data/seuranta.csv")
print(puuttuvia(seuranta$rahkasammal_peitto))
print(cm_metreiksi(c(-30, -10, 0, NA)))

# TEHTÄVÄ C1: Avaa R/apufunktiot.R ja etsi puuttuvia-funktion määrittely.
# Mikä on sen syöte ja mitä se palauttaa?

# TEHTÄVÄ C2: Muunna 25 cm metreiksi käyttäen cm_metreiksi()-funktiota.
# Selitä miksi myös NA on mukana esimerkin tuloksessa.

# C3 Tarkastele riippuvuutta käytännössä -----------------------------------
# TEHTÄVÄ C3: Tallenna. Valitse Session > Restart R.
# Kokeile Consolessa: cm_metreiksi(25)
# Uudessa istunnossa odotat virhettä "could not find function".
# Aja sitten yllä oleva source()-rivi ja kokeile uudelleen.
# Virhe on tässä tarkoituksellinen kokeilu, ei osa ajettavaa skriptiä.

# VALINNAINEN: Tee omat/omat_funktiot.R ja määrittele sinne
# kaksinkertaista <- function(x) { 2 * x }
# Lataa se source("omat/omat_funktiot.R", encoding = "UTF-8") ja kokeile arvoa 7.
# Ratkaisut: ratkaisut/03_ratkaisut.R
