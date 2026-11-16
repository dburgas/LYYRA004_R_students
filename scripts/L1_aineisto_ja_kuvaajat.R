# LYYRA-004 | 16.11.2026 
# Avaa .Rproj. Aja valittu rivi Ctrl+Enter (Mac: Cmd+Enter).
source("scripts/L1_lue_aineisto.R")

# 1. ENSIMMÄINEN GGPLOT --------------------------------------------------
# Katsomme ensin kaikkia viittä käsittelyä vuonna 2018.
d18 <- filter(pilis, year == 2018)
p_eka <- ggplot(d18, aes(x = treatment, y = Aba.ate, colour = treatment)) +
  geom_jitter(width = 0.12, height = 0) +
  scale_colour_manual(values = varit) +
  labs(x = "Käsittely", y = "Abax, saalis / koeala / vuosi", colour = "Käsittely")
print(p_eka)
# ggplot(data, aes(...)) määrittää aineiston ja muuttujien kuvauksen.
# geom_jitter() siirtää pisteitä tässä VAIN vaakasuunnassa. 
# + lisää kuvaan kerroksen. Se on eri asia kuin aineiston putki |>.

# 2. MITÄ YKSI RIVI JA SARAKKEET TARKOITTAVAT? ----------------------------
head(pilis)
dim(pilis)                         # 150 riviä, 21 saraketta alustuksen jälkeen
str(pilis)
count(pilis, year, treatment)       # 6 riviä kussakin vuosi/käsittely-yhdistelmässä
length(unique(pilis$plot_id))       # 30 pysyvää koealaa
dplyr::select(pilis, year, block, treatment, Aba.ate) |> head()
# KYSYMYS: miksi sama plot_id esiintyy viitenä vuonna?

# 3. NOLLA, PUUTTUVA ARVO JA TARKISTUKSET ---------------------------------
colSums(is.na(pilis))
sum(pilis$Apt.bom == 0)
sum(is.na(pilis$Apt.bom))
all(rowSums(comm) == pilis$N)        # N on vain kahdeksan valitun lajin summa
esimerkki <- c(5, 0, NA)            # keinotekoinen opetusesimerkki
mean(esimerkki)
mean(esimerkki, na.rm = TRUE)       # 2.5, nolla on mukana
# NA = tuntematon havainto. 0 = ei pyydystetyja yjksilöitä näytteessä.
# Yksittäinen ei-havainto ei todista lajin puuttumista alueelta.

# 4. KUVAAN LISÄTÄÄN KERROKSIA ------------------------------------------
p_kaikki <- ggplot(d18, aes(x = treatment, y = Aba.ate, colour = treatment)) +
  geom_boxplot(outlier.shape = NA, width = 0.55) +
  geom_jitter(width = 0.12, height = 0, size = 2) +
  scale_colour_manual(values = varit) +
  labs(x = "Käsittely", y = "Pyydystettyjä Abax-yksilöitä / koeala (2018)", colour = "Käsittely")
print(p_kaikki)
# outlier.shape = NA piilottaa laatikkokuvan omat poikkeavien arvojen merkit.
# Kaikki havainnot näkyvät silti pistekerroksessa, kukin yhden kerran.
ggsave("tulokset/16_Abax_kaikki_kasittelyt.png", plot = p_kaikki,
       width = 9, height = 5, dpi = 150)

# 5. RAJATAAN VERTAILUMETSÄ C JA AVOHAKKUU CC -----------------------------
# Opetuksen fokusoitu vertailu on sovittu etukäteen ekologisen kysymyksen
# perusteella. Sitä ei valita kokeilemalla, mistä saadaan pienin p-arvo.
d18_cc <- d18 |>
  filter(treatment %in% c("C", "CC")) |>
  droplevels()
count(d18_cc, treatment)
nrow(d18_cc)                        # 12: 6 C-alaa ja 6 CC-alaa
stopifnot(nrow(d18_cc) == 12, all(table(d18_cc$treatment) == 6))
# %in% säilyttää rivit, joiden arvo on luettelossa. C ja CC ovat eri koodeja.
# |> siirtää edellisen vaiheen tuloksen seuraavan funktion aineistoksi.
# Alkuperäinen pilis ja kaikkien käsittelyjen d18 säilyvät käytössä.

p_cc <- ggplot(d18_cc, aes(x = treatment, y = Aba.ate, colour = treatment)) +
  geom_jitter(width = 0.08, height = 0, size = 2.5) +
  scale_colour_manual(values = varit) +
  labs(x = "Käsittely", y = "Pyydystettyjä Abax-yksilöitä / koeala", colour = "Käsittely")
print(p_cc)
ggsave("tulokset/16_Abax_C_CC.png", plot = p_cc, width = 7, height = 5, dpi = 150)
# TÄNÄÄN: opettelemme rajaamista ja kuvailevaa vertailua.
# Yhden vuoden kuva ei vielä käytä ennen-mittausta eikä ole BACI-vaikutusarvio.

# 6. RYHMITTELY JA KAIKKIEN KÄSITTELYJEN AIKASARJA ------------------------
vuosikeski <- pilis |>
  group_by(year, treatment) |>
  summarise(Aba.ate = mean(Aba.ate), n = n(), .groups = "drop")
vuosikeski
p_aika <- ggplot(vuosikeski, aes(year, Aba.ate, colour = treatment,
                               group = treatment)) +
  geom_line() + geom_point(size = 2) +
  geom_vline(xintercept = 2014.5, linetype = 3) +
  scale_colour_manual(values = varit) +
  scale_x_continuous(breaks = 2014:2018) +
  labs(x = "Vuosi", y = "Abax, keskimääräinen saalis", colour = "Käsittely")
print(p_aika)
ggsave("tulokset/16_Abax_aikasarja.png", plot = p_aika,
       width = 10, height = 6, dpi = 150)
write.csv(vuosikeski, "tulokset/16_Abax_vuosikeskiarvot.csv", row.names = FALSE)
# group_by() määrittää ryhmät. summarise() tekee yhden rivin ryhmää kohti.
# Viivojen välissä ei ole uusia mittauksia. Emme tasoita havaittuja vuosiarvoja.

# SYVENTÄVÄ: jakauma ja saman kuvan jakaminen vuosittaisiin paneeleihin.
p_hist <- ggplot(pilis, aes(Aba.ate)) +
  geom_histogram(binwidth = 10, boundary = 0, closed = "right", fill = "#16847A") +
  labs(x = "Abax, saalis", y = "Rivien määrä")
print(p_hist)
p_vuodet <- ggplot(pilis, aes(treatment, Aba.ate, colour = treatment)) +
  geom_jitter(width = 0.12, height = 0) + facet_wrap(~ year) +
  scale_colour_manual(values = varit) +
  labs(x = "Käsittely", y = "Abax, saalis", colour = "Käsittely")
print(p_vuodet)

# OMA TEHTÄVÄ (15 min) ---------------------------------------------------
# Tavoite: harjoittele vasteen vaihtamista, aineiston rajaamista ja
# rajauksen tarkistamista.

# Car.sch tarkoittaa lajia Carabus scheidleri.

# 1. Tee pistekuva Car.sch-lajin vuoden 2018 saaliista.
#    Käytä aineistoa d18 ja näytä kuvassa kaikki viisi käsittelyä.
#
#    VINKKI: kopioi aikaisempi Abax-kuvan ggplot-koodi ja vaihda
#    y-muuttujaksi Aba.ate-muuttujan tilalle Car.sch.

# 2. Tee uusi aineisto, jossa ovat mukana vain:
#    C  = käsittelemätön vertailumetsä
#    CC = avohakkuu
#
#    Tee sen jälkeen Car.sch-lajin saaliista uusi pistekuva käyttäen
#    tätä rajattua aineistoa.

# 3. Tarkista, että rajaus onnistui:
#    - count()-tuloksessa pitää olla 6 C-koealaa ja 6 CC-koealaa
#    - nrow()-tuloksen pitää olla 12

# 4. Vertaa kuvia ja mietti yksi kuvaileva havainto:
#    Kummassa käsittelyssä Car.sch-saaliit näyttävät olevan suurempia?
#    Muista: pelkkä vuoden 2018 kuva ei vielä osoita hakkuiden vaikutusta.
