# Seuranta aineistokuvaus

Aineisto on kokonaan simuloitu tämän aloituspaketin opetuskäyttöön.
Se ei ole empiirinen tutkimusaineisto eikä osoita todellisen hankkeen vaikutuksia.

Kuvitteellinen tapaus on suon ennallistamisen seuranta. Mukana on 12 kohdetta:
6 ennallistettavaa kohdetta ja 6 vertailukohdetta. Jokaisella kohteella on kolme
pysyvää ruutua. Samat ruudut mitataan neljällä käynnillä: vuosina 2022 ja 2023
ennen toimenpidettä sekä vuosina 2025 ja 2026 sen jälkeen. Toimenpide sijoittuu
vuosien 2023 ja 2025 väliin. Tiedostossa on 144 riviä ja 9 saraketta.

Yksi rivi on yhden ruudun yksi mittauskäynti. Havaintoja kertyy
12 kohdetta × 3 ruutua × 4 käyntiä = 144 riviä.
Toimenpiteen yksikkö on kohde. Ruudut ja toistetut käynnit eivät lisää
toisistaan riippumattomien toimenpidekohteiden määrää.

| Muuttuja | Merkitys | Yksikkö tai arvot |
| --- | --- | --- |
| kohde_id | Kohteen tunniste | K01–K12 |
| ruutu_id | Pysyvän ruudun yksilöllinen tunniste | esim. K01_R01 |
| ryhma | Kohteen ryhmä | ennallistaminen tai vertailu |
| jakso | Ajanjakso suhteessa toimenpiteeseen | ennen tai jalkeen |
| vuosi | Mittausvuosi | 2022, 2023, 2025, 2026 |
| kaynti | Käynnin numero koko seurannassa | 1–4 |
| vesipinta_cm | Vedenpinnan korkeus suhteessa maanpintaan | cm; negatiivinen = maanpinnan alapuolella |
| rahkasammal_peitto | Rahkasammalten peittävyys | 0–100 prosenttia; kaksi puuttuvaa arvoa |
| lajimaara | Ruudussa havaittu lajimäärä | ei-negatiivinen kokonaisluku |

CSV on UTF-8-tekstiä. Sarake-erotin on pilkku, desimaalierotin piste ja puuttuvan
arvon merkintä NA. Sarakenimet ja luokkien arvot on kirjoitettu ilman ääkkösiä.
R lukee ryhmä- ja jaksomuuttujat tässä merkkijonoina. Numeerinen tunniste tai
käyntinumero ei itsessään ole jatkuva ekologinen mittari.

Säilytä tämä alkuperäinen CSV muuttamattomana. Tee muokkaukset R-skriptissä.
