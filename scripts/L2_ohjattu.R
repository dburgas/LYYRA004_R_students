# LYYRA-004 | 17.11.2026 | OHJATTU HARJOITUS
# Monimuotoisuusmittarit, kertymäkäyrät ja lajistokoostumus
# Versio 17.11.2026. Tämä tiedosto toimii uudessa R-istunnossa.
# Et tarvitse eilen ajettuja komentoja tai R/00_lue_aineisto.R-tiedostoa.
# Aineisto: alkuperäinen pilis-species-2025.csv. BCI tulee vegan-paketista.
#
# TYÖSKENTELY
# Aja rivejä järjestyksessä Ctrl+Enter (Mac: Cmd+Enter).
# Pysähdy TARKISTUS-kohtiin. Opettaja kertoo, milloin jatketaan.
# Jos olet valmis aikaisin, avaa 17_11_syventavat.R ja aloita tehtävä A.
# Jos jäit jälkeen, valitse tämän tiedoston alusta nykyisen vaiheen loppuun
# ja aja valitut rivit. Myöhemmät vaiheet rakentuvat tässä luoduille objekteille.

# 0. PAKETIT JA KUVIEN ASETUKSET ----------------------------------------
# Asenna puuttuvat paketit kerran. Poista seuraavan rivin alusta # vain
# tarvittaessa ja aja rivi. Asentaminen tarvitsee verkkoyhteyden.
# install.packages(c("dplyr", "ggplot2", "vegan"))

paketit <- c("dplyr", "ggplot2", "vegan")
puuttuvat <- paketit[!vapply(paketit, requireNamespace, logical(1), quietly = TRUE)]
if (length(puuttuvat)) {
  stop("Asenna ensin puuttuvat paketit: ", paste(puuttuvat, collapse = ", "),
       ". Asennuskomento on tämän vaiheen kommentissa.")
}
library(dplyr)
library(ggplot2)
theme_set(theme_minimal(base_size = 14))
varit <- c(C = "#273C36", G = "#16847A", P = "#6574B4",
           R = "#B36C33", CC = "#CB514A")
# TARKISTUS 0: library()-rivien jälkeen ei tule Error-virheilmoitusta.
# dplyrin ilmoitus peitetyistä funktioista (masked) on tavallinen latausviesti.

# 1. SAMA LAJIMÄÄRÄ, ERILAISET RUNSAUSSUHTEET ----------------------------
# Keinotekoinen opetusesimerkki. Rivi = yhteisö, sarake = laji.
# rbind() kokoaa kaksi lukujonoa saman matriisin riveiksi.
lelu <- rbind(Tasainen = c(10, 10, 10, 10),
              Dominoiva = c(37, 1, 1, 1))
colnames(lelu) <- c("Laji_1", "Laji_2", "Laji_3", "Laji_4")
lelu

# 1a. Kuinka monta yksilöä ja havaittua lajia on kummassakin yhteisössä?
N <- rowSums(lelu)
N
S <- vegan::specnumber(lelu)
S
# TARKISTUS 1a: N = 40 ja S = 4 molemmissa yhteisöissä.
# specnumber() laskee riviltä lajit, joiden yksilömäärä on suurempi kuin nolla.

# 1b. Shannonin H huomioi lajien suhteelliset runsaudet n_i / N.
# Laske ensin H, sitten muunna se efektiiviseksi lajimääräksi D1 = exp(H).
H <- vegan::diversity(lelu, index = "shannon")
H
D1 <- exp(H)
D1
# TARKISTUS 1b: Tasainen D1 = 4. Dominoiva D1 on noin 1.42.
# H on noin 1.386 ja 0.349. Käytämme luonnollista logaritmia.
# Dominoivassakin yhteisössä ON neljä lajia. D1 kertoo, kuinka monen
# yhtä runsaan lajin yhteisöä sen Shannon-monimuotoisuus vastaa.

lelu_tulos <- data.frame(Yhteiso = rownames(lelu), N, S, H, D1)
lelu_tulos
# KYSYMYS: Miksi sama S voi liittyä hyvin erilaiseen D1-arvoon?

# 2. PILIS-AINEISTO JA VUODEN 2018 RAJAUS -------------------------------
# Yksi CSV-rivi on yhden pysyvän koealan yhden vuoden yhteenlaskettu saalis.
# Neljä kuoppapyydystä ja kesä- sekä syyskuun pyyntijaksot on yhdistetty.
# Tiedosto sisältää vain kahdeksan valittua yleistä lajia.
# Kuoppapyydyssaalis riippuu yksilömäärästä ja eläinten liikkumisaktiivisuudesta.

# Avaa tuttu R-projekti, jos sinulla on se. Jos data/-polkua ei löydy,
# ohjelma pyytää valitsemaan alkuperäisen CSV:n omalta koneeltasi.
# Voit siis lisätä vain tämän R-tiedoston vanhaan R/-kansioosi.
aineistopolku <- "data/pilis-species-2025.csv"
if (!file.exists(aineistopolku)) {
  if (!interactive()) stop("CSV puuttuu: data/pilis-species-2025.csv")
  message("Valitse tiedosto pilis-species-2025.csv. Älä valitse ZIP-tiedostoa.")
  aineistopolku <- file.choose()
}
aineistopolku <- normalizePath(aineistopolku, winslash = "/", mustWork = TRUE)
pilis <- read.csv(aineistopolku, sep = ";", dec = ".")
# sep = ";" kertoo, että CSV:n sarakkeet erottaa puolipiste.
stopifnot(nrow(pilis) == 150, !anyNA(pilis))
pilis$treatment <- factor(pilis$treatment, levels = c("C", "G", "P", "R", "CC"))
pilis$block <- factor(pilis$block)
pilis$plot_id <- interaction(pilis$block, pilis$treatment, drop = TRUE)

d18 <- filter(pilis, year == 2018)
nrow(d18)
count(d18, treatment)
# TARKISTUS 2: 30 riviä. C, G, P, R ja CC: jokaisessa 6 koealaa.
# C = vertailumetsä, G = pienaukko, P = valmistava hakkuu,
# R = säästöpuuryhmä, CC = avohakkuu.

# 3. LAJIMATRIISI JA MITTARIT JOKAISELLE KOEALALLE -----------------------
# Lajimatriisiin kuuluvat vain kahdeksan lajin saalissarakkeet.
# year, block, N ja ominaisuusryhmien summat jätetään sen ulkopuolelle.
# Sarakenimet on annettu valmiina, eikä niitä tarvitse opetella ulkoa.
lajit <- c("Aba.ate", "Apt.bom", "Car.cor", "Car.hor",
           "Car.sch", "Car.ull", "Neb.bre", "Pte.mel")
comm18 <- as.matrix(dplyr::select(d18, all_of(lajit)))
dim(comm18)
head(comm18)
stopifnot(nrow(comm18) == 30, ncol(comm18) == 8,
          all(rowSums(comm18) > 0), all(comm18 >= 0), !anyNA(comm18))
# TARKISTUS 3a: 30 riviä ja 8 saraketta. Rivi = koeala, sarake = laji.
# Matriisin rivijärjestys vastaa d18-taulukkoa.

# mutate() lisää laskettuja sarakkeita taulukkoon.
# Laskemme mittarin kullekin koealalle erikseen. Kuusi alaa säilyy per käsittely.
m18 <- d18 |> mutate(S8 = vegan::specnumber(comm18))
m18 <- m18 |> mutate(H8 = vegan::diversity(comm18, index = "shannon"))
m18 <- m18 |> mutate(D1_8 = exp(H8))
dplyr::select(m18, block, treatment, S8, D1_8) |> head()
# S8 = havaitut lajit valitusta kahdeksikosta.
# D1_8 = näiden samojen kahdeksan lajin efektiivinen lajimäärä.
# TARKISTUS 3b: yksi tulosrivi per koeala. D1_8 on välillä 1 ... S8.
stopifnot(all(m18$D1_8 >= 1 - 1e-10), all(m18$D1_8 <= m18$S8 + 1e-10))

# 4. ENSIMMÄINEN KUVA RAKENNETAAN VAIHEITTAIN ----------------------------
# 4a. Määritä aineisto ja akselit. Kuvassa näkyvät vasta akselit.
pohja <- ggplot(m18, aes(x = treatment, y = D1_8, colour = treatment))
print(pohja)

# 4b. Lisää havaintopisteet. Jokainen piste on yhden koealan D1_8.
pisteet <- pohja + geom_jitter(width = 0.12, height = 0, size = 2.5)
print(pisteet)

# 4c. Lisää tutut käsittelyvärit ja akselien nimet.
p_kaikki <- pisteet +
  scale_colour_manual(values = varit) +
  labs(x = "Metsänkäsittely", y = "D1, kahdeksan valittua lajia",
       colour = "Käsittely")
print(p_kaikki)
# TARKISTUS 4: kuvassa näkyvät kaikki viisi käsittelyä ja kuusi alaa per ryhmä.
# Pisteet voivat yhä osua päällekkäin. height = 0 säilyttää D1-arvon.

# 5. YDINTEHTÄVÄ 1: RAJAUS C- JA CC-ALOIHIN (5–8 min) --------------------
# LÄHTÖ: m18 sisältää vuoden 2018 kaikki 30 koealaa ja niiden mittarit.
# TAVOITE: tee samasta D1-mittarista kuva vain vertailumetsälle ja avohakkuulle.
# Aja ensin rajaus. %in% valitsee rivit, joiden käsittely löytyy luettelosta.
m18_cc <- m18 |>
  filter(treatment %in% c("C", "CC")) |>
  droplevels()
count(m18_cc, treatment)
nrow(m18_cc)
# TARKISTUS 5: C = 6, CC = 6 ja yhteensä 12 riviä.
stopifnot(nrow(m18_cc) == 12, all(table(m18_cc$treatment) == 6))

# Piirrä rajattu aineisto. Muutos aiempaan kuvaan on aineisto m18_cc.
p_cc <- ggplot(m18_cc, aes(treatment, D1_8, colour = treatment)) +
  geom_jitter(width = 0.08, height = 0, size = 2.5) +
  scale_colour_manual(values = varit) +
  labs(x = "Metsänkäsittely", y = "D1, kahdeksan valittua lajia",
       colour = "Käsittely")
print(p_cc)

# OMA MUUTOS:
# Kopioi p_cc-kuvan koodi uudelle riviryhmälle. Vaihda y-muuttujaksi S8.
# Vaihda myös y-akselin nimeksi "Lajeja kahdeksasta valitusta".
# Kirjoita kaksi lausetta: mitä D1-kuva kertoo ja mitä S8-kuva kertoo?
# Lopputulos: C/CC-kuva D1:stä, oma C/CC-kuva S8:sta ja kaksi lausetta.
# Yhden vuoden kuvaileva ero ei vielä huomioi ennen-mittausta eikä lohkoja.
# Jos olet valmis aikaisin: syventävien tehtävien A tai B.

# 6. LAJIKERTYMÄ: MITÄ LISÄKOEALA TUO? ----------------------------------
# Uusi opetusaineisto, BCI: 50 yhden hehtaarin ruutua Panamassa.
# Sarakkeina on 225 puulajia. Mukana ovat vuoden 1982 puut, joiden
# rinnankorkeusläpimitta on vähintään 10 cm. Lähde: Condit ym. (2002).
# Aineisto tulee veganin mukana. Uutta CSV:tä ei tarvitse ladata.
data("BCI", package = "vegan")
dim(BCI)
# TARKISTUS 6a: 50 riviä ja 225 lajisaraketta.

# specaccum() yhdistää koealojen lajilistoja. Sama laji lasketaan vain kerran.
# method = "random" lisää koealat satunnaisissa järjestyksissä.
# 499 järjestystä tuottaa keskimääräisen käyrän. set.seed tekee sen toistettavaksi.
set.seed(1702)
acc_bci <- vegan::specaccum(BCI, method = "random", permutations = 499)

# Muunna laskelman tulos ggplotille sopivaksi taulukoksi.
acc_df <- data.frame(aloja = acc_bci$sites, S = acc_bci$richness,
                     sd = acc_bci$sd)
head(acc_df)

# Vaaka-akseli: yhdistettyjen ruutujen määrä.
# Pystyakseli: näissä ruuduissa yhteensä havaittujen eri lajien määrä.
p_bci <- ggplot(acc_df, aes(x = aloja, y = S)) +
  geom_line(linewidth = 1, colour = "#16847A") +
  labs(x = "Yhdistettyjä 1 ha ruutuja", y = "Yhteensä havaittuja puulajeja")
print(p_bci)
# TARKISTUS 6b: käyrä päättyy kohtaan 50 ruutua ja 225 havaittua lajia.
# Alkupiste on keskiarvo eri ensimmäisistä ruuduista satunnaisissa järjestyksissä.
# Se ei ole yhden tietyn ruudun lajimäärä eikä kaikkien ruutujen keskiarvon aikasarja.

# Pilis-käyrän vertailu: vuosi pidetään samana, yhdistetään 2018 koealoja.
set.seed(1701)
acc8 <- vegan::specaccum(comm18, method = "random", permutations = 499)
acc8_df <- data.frame(aloja = acc8$sites, S = acc8$richness, sd = acc8$sd)
p_pilis <- ggplot(acc8_df, aes(aloja, S)) +
  geom_line(linewidth = 1, colour = "#16847A") +
  labs(x = "Yhdistettyjä vuoden 2018 koealoja", y = "Lajeja kahdeksasta valitusta")
print(p_pilis)
# TARKISTUS 6c: käyrä päättyy 30 koealaan ja enintään kahdeksaan lajiin.
# Aineistosta puuttuvat harvinaiset lajit. Tasaantuminen ei osoita koko
# maakiitäjäislajiston otannan riittävyyttä.

# YDINTEHTÄVÄ 2 (3–5 min):
# Kirjoita BCI-kuvasta, mitä x-akseli ja y-akseli tarkoittavat.
# Selitä, miksi Pilis-käyrän nopea tasaantuminen on tässä odotettavaa.
# Valitse ryhmätyösi näkökulmasta yksi asia, johon kertymäkäyrä auttaa
# vastaamaan, ja yksi asia, jonka ratkaisemiseen tarvitset muuta tietoa.
# Lisätehtävä valmiille: syventävä C, yksilöpohjainen harvinaistaminen.

# 7. LAJISTOKOOSTUMUS JA NMDS: VALMIS LASKENTALOHKO -----------------------
# Opetuskerralla painotamme tämän kuvan tulkintaa. Alla oleva laskenta on
# annettu valmiina. Sitä voi ajaa kokonaisena lohkona opettajan ohjeella.
# Kaikki 150 koeala–vuosi-riviä sovitetaan YHTEEN koordinaatistoon.
# Näytämme siitä vuodet 2014 ja 2018. Kuvailemme kaikki käsittelyt ensin.
comm <- as.matrix(dplyr::select(pilis, all_of(lajit)))
comm_h <- vegan::decostand(comm, method = "hellinger")
set.seed(1703)
nmds <- vegan::metaMDS(comm_h, distance = "bray", k = 2,
                       autotransform = FALSE, trymax = 100, trace = FALSE)
nmds$stress
# TARKISTUS 7a: stress on noin 0.190. Stress kuvaa tiivistämisen virhettä.

ord <- bind_cols(dplyr::select(pilis, year, block, treatment, plot_id),
                  as.data.frame(vegan::scores(nmds, display = "sites")))
ord_kuva <- filter(ord, year %in% c(2014, 2018))
p_nmds <- ggplot(ord_kuva, aes(NMDS1, NMDS2, colour = treatment)) +
  geom_point(size = 2.5) + facet_wrap(~ year) +
  scale_colour_manual(values = varit) +
  coord_equal(xlim = range(ord$NMDS1), ylim = range(ord$NMDS2)) +
  labs(colour = "Käsittely")
print(p_nmds)

# C/CC-kuva käyttää täsmälleen samoja koordinaatteja ja akselirajoja.
ord_cc <- filter(ord_kuva, treatment %in% c("C", "CC"))
p_nmds_cc <- ggplot(ord_cc, aes(NMDS1, NMDS2, colour = treatment)) +
  geom_point(size = 2.5) + facet_wrap(~ year) +
  scale_colour_manual(values = varit) +
  coord_equal(xlim = range(ord$NMDS1), ylim = range(ord$NMDS2)) +
  labs(colour = "Käsittely")
print(p_nmds_cc)
# TARKISTUS 7b: kummassakin vuosipaneelissa on 6 C- ja 6 CC-havaintoa.
# Lähekkäiset pisteet kuvaavat samankaltaisempaa lajistokoostumusta.
# Akselien suunta ja etumerkki ovat ratkaisuun liittyviä, eivät lajien ominaisuuksia.
# Kuvan erottuminen ei ole käsittelyn vaikutustesti. Lohkot ja samojen koealojen
# toistomittaus pitää huomioida myöhemmässä testauksessa.

# 8. TALLENNUS JA OMA TULKINTA -----------------------------------------
# Kuvat ja taulukko tallentuvat alkuperäisen CSV:n projektikansioon.
aineistokansio <- dirname(aineistopolku)
projektikansio <- if (basename(aineistokansio) == "data") {
  dirname(aineistokansio)
} else {
  aineistokansio
}
tuloskansio <- file.path(projektikansio, "tulokset_L2_17_11")
dir.create(tuloskansio, recursive = TRUE, showWarnings = FALSE)
ggsave(file.path(tuloskansio, "17_D1_kaikki.png"), p_kaikki, width = 9, height = 5, dpi = 150)
ggsave(file.path(tuloskansio, "17_D1_C_CC.png"), p_cc, width = 7, height = 5, dpi = 150)
ggsave(file.path(tuloskansio, "17_BCI_kertymakayra.png"), p_bci, width = 9, height = 5, dpi = 150)
ggsave(file.path(tuloskansio, "17_Pilis_kertymakayra.png"), p_pilis, width = 9, height = 5, dpi = 150)
ggsave(file.path(tuloskansio, "17_NMDS_kaikki.png"), p_nmds, width = 11, height = 5, dpi = 150)
ggsave(file.path(tuloskansio, "17_NMDS_C_CC.png"), p_nmds_cc, width = 11, height = 5, dpi = 150)
write.csv(dplyr::select(m18, year, block, treatment, plot_id, S8, H8, D1_8),
          file.path(tuloskansio, "17_mittarit_2018.csv"), row.names = FALSE)
message("Kuvat ja taulukko tallentuivat: ", normalizePath(tuloskansio, winslash = "/"))

# OMA TULKINTA (2–3 lausetta):
# 1. Nimeä yksi ryhmätyösi ekologinen tavoite.
# 2. Valitse sille mittari ja perustele, mitä mittari kertoo.
# 3. Kerro yksi tavoitteen kannalta tärkeä asia, jonka mittari jättää näkymättä.
# Esimerkiksi lajimäärä voi kasvaa yleislajien runsastuessa, vaikka tavoitellut
# metsälajit vähenisivät. Mittari tarvitsee ekologisen tavoitteen ja vertailukohdan.

# LÄHTEET
# Růžičková ym. (2025): https://doi.org/10.1111/icad.12849
# Pilis-aineisto: https://doi.org/10.5061/dryad.wdbrv15zv
# BCI: Condit ym. (2002), https://doi.org/10.1126/science.1066854
# vegan: https://vegandevs.github.io/vegan/reference/diversity.html
# https://vegandevs.github.io/vegan/reference/specaccum.html
