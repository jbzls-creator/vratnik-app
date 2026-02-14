Ahoj, toto je hlavny readme subor k aplikacii „vratnik“  kludne pozeraj adresare podla cisiel ktore som im pridelil co sa tyka postupnosti

Tento subor zip s adresarmi ako aj tento readme je vytvoreny na to aby som vedel v novom chate pokracovat v projekte tam kde som prestal, lebo som musel switchnut do noveho chatu lebo stary chat kvoli svojej velkosti zamrzal prilis casto a praca bola velmi spomalena...

Tu je logika aplikacia Vratnik:
Teoria:
Je to jednoducha aplikacia ktora sluzi na sledovanie navstev v areali. Vratnik ma dva mody, master a hosť.  Kazdy screen po nainstalovani vyzera ako host, v pravo hore je ikona zamku, na neho ked kliknem tak sa otvori ciselnik a ja tam napisem pin, a po potvrdeni sa dostavam do mastra. V hostovi je iba jeden screen, kde si uzivatel vie vyplnit vstupne udaje ako meno, auto, spz, farba auta, a za kym ide, ako nahle ulozi informacie, tak sa mu aktivuje moznost stlacit tlacidlo otvorit rampu , a po kliknuti odosle poziadavku do mastra, Ja ako master – po nainstalovani aplikacie sa lognem pomocou pinu do mastera a vidim tam hore „aktualne“ a „ historia“. V aktualnych vidim poziadavku v pripade ze na hostovi mi niekto klikne na otvorit rampu, mne vyskoci poziadavka, a info panel o navsteve, skladajuci sa prave z informacii ktore vyplna na zaciatku host. Kazdy mame pamet a po vypnuti apky a znovu zapnuti apky sa hostovi objavia pred tym ulozene informacia a masterovi sa ukaze historia. ta sa momentalne maze po 30 dnoch ale toto budeme prerabat potom rok historie.

Dalej prikladam: screenshoty z aplikacia, ktore podla nazvu zobrazuju urcite fazy aplikacie, to mas pre lepsiu orientaciu.

Root projektu v android studiu, teda jeho fotografie aby si videl akym sposobom to mame ulozene, vytvorené..

Vsetky subory .dart z android studia – tie si pozri, precitaj nech vies suvislosti


Fotografie z firebase su tiez pre tvoju rientaciu aby si videl ako mame urobene requesty


V pripade ze ti chybaju nejake casti alebo cokolvek co ti chyba mi napis a ja ti doplnim informacie

## Vývojový workflow
Aplikácia je funkčná.
Vývoj prebieha iteratívne formou upgradeov.

Postup:
1. Definuje sa konkrétny upgrade
2. Upravujú sa len dotknuté súbory
3. Zmena sa otestuje v aplikácii
4. Pokračuje sa ďalším krokom

Cieľ: stabilná, postupne vylepšovaná aplikácia

Cize chcem postupovat tak, ze si zadefinujeme upgrade alebo problem ktory chceme riesit a nasleddne si urcime ktorej casti kodu sa to tyka, ty mi povies nazov napr daj mi sem pubspec.yaml , ja ti ho vlozim ten kod mojho momentalnej aplikacie , teda ktualny kod a ty tam urobis zmenu a das mi kod na nakopirovanie jedna ku jednej.
