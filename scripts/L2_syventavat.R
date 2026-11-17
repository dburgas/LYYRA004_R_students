# LYYRA-004 | 17.11.2026 | SYVENTÄVÄT TEHTÄVÄT
# Aloita näistä, kun yhteisen vaiheen tarkistus täsmää. Valitse yksi tehtävä.
# Tiedosto toimii myös uudessa R-istunnossa. Se ei aja ohjattua skriptiä.
# A ja B tarvitsevat vain tämän tiedoston. C käyttää veganin BCI-aineistoa.
# D tarvitsee alkuperäisen Pilis-CSV:n.
# Aja valitsemasi tehtävän aloituskoodi ja lisää omat laskusi kommenttien alle.

# 0. PAKETIT -----------------------------------------------------------
# Tarvittaessa asenna kerran: install.packages(c("dplyr", "ggplot2", "vegan"))
paketit <- c("dplyr", "ggplot2", "vegan")
puuttuvat <- paketit[!vapply(paketit, requireNamespace, logical(1), quietly = TRUE)]
if (length(puuttuvat)) stop("Asenna paketit: ", paste(puuttuvat, collapse = ", "))
library(dplyr)
library(ggplot2)
theme_set(theme_minimal(base_size = 14))

# A. RUNSAUS JA DOMINANSSI (10–15 min) ----------------------------------
# KYSYMYS: Voiko yksilömäärä kasvaa, vaikka efektiivinen lajimäärä pienenee?
# LÄHTÖ: kolme keinotekoista yhteisöä, samat neljä lajia sarakkeina.
a <- rbind(Tasainen = c(10, 10, 10, 10),
           Kaikki_runsastuvat = c(20, 20, 20, 20),
           Yksi_runsastuu = c(70, 10, 10, 10))
a

# 1. Laske kaikille riveille N, S, D1 ja D2.
#    Vihjeet: rowSums(), vegan::specnumber(),
#    exp(vegan::diversity(a, index = "shannon")) ja
#    vegan::diversity(a, index = "invsimpson").
# 2. Kokoa tulokset data.frame()-taulukkoon, yksi rivi yhteisöä kohti.
# 3. Selitä, miksi kaikkien lajien runsastuminen samassa suhteessa säilyttää D1:n.
# 4. Selitä, miksi yhden lajin runsastuminen muuttaa D1:tä ja D2:ta eri tavoin.
# LOPPUTULOS: kolmirivinen taulukko ja kolme perusteltua tulkintalausetta.
# TARKISTUS: kaikissa S = 4. Ensimmäisissä kahdessa D1 = D2 = 4.
# D2 painottaa runsaimpia lajeja D1:tä voimakkaammin.
# "simpson" tarkoittaa veganissa 1 - sum(p_i^2), "invsimpson" 1/sum(p_i^2).

# Omat laskut ja tulkinta tähän:


# B. SAMAT INDEKSIT, ERI LAJIT (10 min) ---------------------------------
# KYSYMYS: Voiko lajisto muuttua kokonaan, vaikka S ja D1 säilyvät samoina?
# LÄHTÖ: keinotekoinen esimerkki, ei Pilis-tutkimuksen havainto.
# Ensimmäiset kaksi saraketta ovat metsälajeja, viimeiset kaksi yleislajeja.
b <- rbind(Alue_A = c(10, 10, 0, 0),
           Alue_B = c(0, 0, 10, 10))
colnames(b) <- c("Metsalaji_1", "Metsalaji_2", "Yleislaji_1", "Yleislaji_2")
b

# 1. Laske molempien alueiden S, D1 ja D2.
# 2. Tarkista lajisarakkeista, onko alueilla yhteisiä lajeja.
# 3. Laske lajistokoostumuksen erilaisuus:
vegan::vegdist(b, method = "bray")
# 4. Kirjoita, miksi samat indeksit eivät tässä takaa samaa suojeluarvoa.
# LOPPUTULOS: kahden alueen mittarit, yhteisten lajien määrä ja kaksi lausetta.
# TARKISTUS: S = D1 = D2 = 2 molemmissa, yhteisiä lajeja 0, Bray–Curtis = 1.
# Bray–Curtis = 1 tarkoittaa tässä täysin erillisiä lajistoja.

# Omat laskut ja tulkinta tähän:


# C. HARVINAISTAMINEN JA KERTYMÄKÄYRÄN VAIHTELU (15–20 min) --------------
# KYSYMYS: Miten lajimäärän vertailu muuttuu, kun vertaamme samalla
# yksilömäärällä emmekä vain samalla koeala-alalla?
data("BCI", package = "vegan")
N_bci <- rowSums(BCI)
S_bci <- vegan::specnumber(BCI)
n_vakio <- min(N_bci)
n_vakio
S_vakio <- vegan::rarefy(BCI, sample = n_vakio)
vertailu <- data.frame(ruutu = seq_len(nrow(BCI)), N = N_bci,
                       S_havaittu = S_bci, S_sama_N = as.numeric(S_vakio))
head(vertailu)

# 1. Valitse kaksi ruutua, joiden yksilömäärät eroavat selvästi.
# 2. Vertaa niiden havaittuja ja samalla yksilömäärällä vakioituja lajimääriä.
# 3. Tee pistekuva: x = S_havaittu, y = S_sama_N.
# 4. Selitä, mitä rarefy() vakioi ja mitä ekologista tietoa vakiointi sivuuttaa.
# LOPPUTULOS: kahden ruudun vertailutaulukko, pistekuva ja kaksi lausetta.
# TARKISTUS: n_vakio = 340. S_sama_N ei ylitä saman ruudun S_havaittu-arvoa.
# Pienimmän näytteen lajimäärä pysyy ennallaan.
# rarefy() laskee odotetun lajimäärän, joten tulos voi olla desimaaliluku.
# Se ei arvo yhtä harvennettua aineistoa eikä muuta alkuperäistä BCI-taulukkoa.
# Käytä aitoja kokonaislukumääräisiä yksilölukuja, älä Hellinger-muunnosta.
# Kaikki BCI-ruudut ovat 1 ha: sama yksilömäärä vastaa eri kysymykseen kuin
# lajimäärä samalla pinta-alalla. Sama N ei takaa samaa kattavuutta.
# Pilisin kahdeksaan yleiseen lajiin rajattua aineistoa ei käytetä tässä
# koko maakiitäjäislajiston rikkauden tai kattavuuden arvioimiseen.

# Omat kuvat ja tulkinta tähän:

# Lisähaaste: ±2 SD:n varjostus satunnaisten lisäysjärjestysten vaihtelulle.
set.seed(1702)
acc <- vegan::specaccum(BCI, method = "random", permutations = 499)
kayra <- data.frame(aloja = acc$sites, S = acc$richness, sd = acc$sd)
p_sd <- ggplot(kayra, aes(aloja, S)) +
  geom_ribbon(aes(ymin = S - 2 * sd, ymax = S + 2 * sd), fill = "#D6ECE9") +
  geom_line(colour = "#16847A", linewidth = 1) +
  labs(x = "Yhdistettyjä 1 ha ruutuja", y = "Havaittuja puulajeja",
       caption = "Varjostus: keskiarvo +/- 2 SD lisäysjärjestyksistä")
print(p_sd)
# Miksi sd lähestyy nollaa, kun kaikki 50 ruutua ovat mukana?
# Vastaa myös: miksi tämä ei osoita, että koko metsän lajimäärä olisi tunnettu?

# D. NMDS:N TULKINTA JA SAMAN RATKAISUN RAJAUS (15 min) -------------------
# KYSYMYS: Voiko pisteitä rajata uudelleen sovittamatta ordinaatiota?
# LÄHTÖ: kaikki 150 koeala–vuosi-havaintoa samasta Pilis-CSV:stä.
polku <- "data/pilis-species-2025.csv"
if (!file.exists(polku)) {
  if (!interactive()) stop("CSV puuttuu: data/pilis-species-2025.csv")
  message("Valitse alkuperäinen pilis-species-2025.csv.")
  polku <- file.choose()
}
pilis_d <- read.csv(polku, sep = ";", dec = ".")
pilis_d$treatment <- factor(pilis_d$treatment, levels = c("C", "G", "P", "R", "CC"))
lajit_d <- c("Aba.ate", "Apt.bom", "Car.cor", "Car.hor",
             "Car.sch", "Car.ull", "Neb.bre", "Pte.mel")
comm_d <- as.matrix(dplyr::select(pilis_d, all_of(lajit_d)))
comm_h_d <- vegan::decostand(comm_d, method = "hellinger")
set.seed(1703)
nmds_d <- vegan::metaMDS(comm_h_d, distance = "bray", k = 2,
                         autotransform = FALSE, trymax = 100, trace = FALSE)
ord_d <- bind_cols(dplyr::select(pilis_d, year, block, treatment),
                    as.data.frame(vegan::scores(nmds_d, display = "sites")))

# 1. Piirrä kaikkien käsittelyjen vuodet 2014 ja 2018 samaan koordinaatistoon.
#    Vihje: filter(), facet_wrap(~ year) ja coord_equal().
# 2. Tee uusi kuva C- ja CC-aloista käyttämällä saman ord_d-taulukon rivejä.
#    Käytä molemmissa kuvissa samoja x- ja y-rajoja, jotka saat koko ord_d:stä.
# 3. Kirjoita, mikä muuttui kuvassa ja mikä laskennassa säilyi samana.
# 4. Tarkastele ratkaisun diagnostiikkaa:
vegan::stressplot(nmds_d)
nmds_d$stress
# LOPPUTULOS: kaksi kuvaa, stress-arvo ja kaksi tulkintalausetta.
# TARKISTUS: yhteisessä sovituksessa 150 pistettä, stress noin 0.190.
# Stress ei ole p-arvo. Akselien etumerkit voivat kääntyä.
# Älä testaa koko pitkittäisaineistoa vapailla permutaatioilla: samat koealat
# toistuvat ja käsittelyt ovat kuuden lohkon sisällä.

# Omat kuvat ja tulkinta tähän:

# LÄHTEET
# vegan: diversity.html, specaccum.html, rarefy.html ja metaMDS.html
# https://vegandevs.github.io/vegan/reference/index.html
# Chao & Jost (2012): https://doi.org/10.1890/11-1952.1
# Jost (2006): https://doi.org/10.1111/j.2006.0030-1299.14714.x
