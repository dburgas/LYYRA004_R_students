# LYYRA-004 – R-harjoitukset

Tämä julkinen repositorio sisältää R:n aloitusoppaan, harjoitusskriptit ja opetusaineiston kurssille **Ympäristöratkaisujen menetelmät I**.

## Aloita näin

1. Asenna R ja RStudio Desktop, jos ne eivät vielä ole koneellasi.
2. Valitse GitHubissa **Code → Download ZIP** ja pura paketti kokonaan koneellesi. Gitin tai GitHub-tilin käyttö ei ole harjoitusten suorittamiseen tarpeen.
3. Avaa puretusta kansiosta `LYYRA004_R.Rproj` RStudiossa.
4. Avaa `ALOITA_TASTA.html` selaimessa ja etene oppaan mukaan. `ALOITA_TASTA.Rmd` on oppaan muokattava lähdetiedosto.
5. Aloita skriptistä `scripts/00_asennuksen_tarkistus.R` ja etene skripteihin 01–04.

Tallenna omat skriptikopiosi `omat/`-kansioon ja koodin tuottamat tiedostot `tulokset/`-kansioon. Säilytä alkuperäiset harjoitusskriptit ennallaan.

## Lisäpaketit

Ydinharjoitukset 00–04 toimivat R:n perustoiminnoilla eivätkä edellytä lisäpaketteja. Valinnaista ggplot2-harjoitusta ja kurssin myöhempiä tehtäviä varten voit asentaa paketit näin:

1. Avaa `scripts/install_packages.R`.
2. Suorita koko skripti RStudion **Source**-painikkeella. Se asentaa paketit `ggplot2`, `janitor`, `tidyverse` ja `lme4`, jos niitä ei vielä ole asennettu.
3. Aja `scripts/05_tutustuminen_R_paketeihin.R`.

Asennus tehdään tavallisesti vain kerran ja se vaatii verkkoyhteyden. Paketit ladataan käyttöön jokaisessa uudessa R-istunnossa niitä tarvitsevassa skriptissä.

## Kansioiden sisältö

- `scripts/`: harjoitukset 00–05 ja lisäpakettien asennusskripti.
- `R/`: yhteiset apufunktiot.
- `data/`: simuloitu seuranta-aineisto ja sen kuvaus.
- `omat/`: omat skriptikopiosi.
- `tulokset/`: harjoitusten tuottamat kuvat, taulukot ja tarkistusraportit.

Aineisto `data/seuranta.csv` on kokonaan simuloitu opetusta varten. Sitä ei pidä tulkita todellisen ennallistamishankkeen vaikutusarvioksi.