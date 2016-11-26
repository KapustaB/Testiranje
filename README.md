# Testno upravljanje signalnim planovima  MATLAB - VISSIM

# Upute za korištenje

UPUTE
1. 


UPUTE za korištenje funkcije MatlabupravljaSignalnimplanom.m

1.	Funkcije za čitanje XMLa iz *.sig podataka su potrebne
2.	Za primjer korištenja služi upravljanjeizmatlaba.m skripta, koja će raditi samo dok unešeni signalni plan ima točno 4 faze
3.	Od iznimne je važnosti da se povratak upravljanja VISSIMU izvršava točno u switchpoint trenutku jer u suprotnom dolazi do problema ukoliko su provođene izmjene na signalnom planu. Preporuka: podesiti sve signalne planove da je switchpoint = 0
4.	Ukoliko VISSIM dobije naredbu za promjenu signalnog statusa attribut ContrByCOM automatski dobiva vrijednost true, no prilikom povrataka na VISSIM kontrolu potrebno je ručno prebaciti atribut na vrijednost false.
5.	Probna mreža ne sadrži vozila već služi samo za pregled ponašanja signalnih uređaja


