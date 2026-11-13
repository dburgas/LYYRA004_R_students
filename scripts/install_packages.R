# LYYRA-004 | Lisäpakettien asennus
#
# Ydinharjoitukset 00–04 toimivat R:n perustoiminnoilla eivätkä tarvitse
# lisäpaketteja. Tämä skripti asentaa ggplot2-, janitor-, tidyverse- ja lme4-paketit
# valinnaiseen ggplot2-harjoitukseen ja kurssin myöhempiin harjoituksiin.
#
# Aja tämä skripti kerran ennen valinnaista ggplot2-harjoitusta.
# Paketteja ei tarvitse asentaa uudelleen jokaisella R-kerralla.
# Jos R kysyy henkilökohtaisen kirjaston luomisesta, vastaa Yes/Kyllä.
#
# Asennus vaatii internet-yhteyden. R asentaa paketin tavallisesti käyttäjän
# omaan R-kirjastoon; järjestelmänvalvojan oikeuksia ei yleensä tarvita.

paketit <- c("ggplot2", "janitor", "tidyverse", "lme4")

puuttuvat <- paketit[
  !vapply(paketit, requireNamespace, logical(1), quietly = TRUE)
]

if (length(puuttuvat) == 0L) {
  message("Kaikki tämän skriptin paketit ovat jo asennettuina.")
} else {
  message("Asennetaan: ", paste(puuttuvat, collapse = ", "))
  install.packages(puuttuvat, repos = "https://cloud.r-project.org")
}

asentamatta <- paketit[
  !vapply(paketit, requireNamespace, logical(1), quietly = TRUE)
]

if (length(asentamatta) > 0L) {
  stop(
    "Seuraavien pakettien asennus ei onnistunut: ",
    paste(asentamatta, collapse = ", "),
    ". Tarkista internet-yhteys ja yritä uudelleen."
  )
}

message("Valmista. Voit nyt ajaa skriptin scripts/05_tutustuminen_R_paketeihin.R.")
