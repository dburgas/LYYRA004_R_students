# LYYRA-004 | 04 Tekninen valmiustarkistus
# Aja, kun olet tehnyt skriptit 00–03. Voit aloittaa uudesta R-istunnosta.
# Skripti tarkistaa tiedostoja ja toimintoja. Se ei arvioi ymmärrystäsi.

source("R/apufunktiot.R", encoding = "UTF-8")
seuranta <- lue_seuranta()

asiat <- c("Projektitiedosto löytyy", "Aineistossa on 144 riviä ja 9 saraketta",
           "Yhteinen funktio toimii", "Kuvatiedosto on tallennettu",
           "Tarkistustaulukko on tallennettu")
onnistuu <- c(length(list.files(pattern = "[.]Rproj$")) > 0,
              nrow(seuranta) == 144 && ncol(seuranta) == 9,
              puuttuvia(seuranta$rahkasammal_peitto) == 2,
              file.exists("tulokset/vesipinta_ennen.pdf"),
              file.exists("tulokset/aineiston_tarkistus.csv"))
valmius <- data.frame(asia = asiat, onnistuu = onnistuu)
print(valmius, row.names = FALSE)
dir.create("tulokset", showWarnings = FALSE)
writeLines(c("LYYRA-004 tekninen valmiustarkistus",
             capture.output(print(valmius, row.names = FALSE))),
           "tulokset/valmiustarkistus.txt", useBytes = TRUE)
if (all(onnistuu)) {
  message("Tekninen tarkistus onnistui. Tee vielä oppaan itsearviointi.")
} else {
  message("Tarkista FALSE-rivit. Kuva ja taulukko syntyvät skriptillä 02.")
}

# Vastaa lisäksi omin sanoin:
# 1. Mitä yksi aineiston rivi tarkoittaa?
# 2. Mitä eroa on NA-arvolla ja nollalla?
# 3. Miksi source()-rivi on skriptin alussa?
# 4. Pystytkö muuttamaan skriptiä ja ajamaan sen uudelleen?
# Ota tukikerralle mukaan se kohta, johon kaipaat vielä apua.
