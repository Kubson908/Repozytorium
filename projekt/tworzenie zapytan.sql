# 1. ilosc dostaw miedzy 10 a 20 grudnia
SELECT COUNT(idDostawy) AS ilosc_dostaw_miedzy_10_a_20_grudnia
FROM dostawa WHERE data_dostawy 
BETWEEN '2020-12-10' AND '2020-12-20';

# 2. cena powyzej 5 
SELECT nazwa, rodzaj, cena 
FROM asortyment 
WHERE cena > 5;

# 3. liczba pracownikow na poszczegolnych stanowiskach 
SELECT stanowisko, COUNT(idPracownika) AS liczba_pracownikow 
FROM pracownik
GROUP BY stanowisko;

# 4. zamowienia i ich koszty, sortowanie wzgledem daty
SELECT a.nazwa, z.data_zamowienia, z.ilosc, a.cena*z.ilosc AS koszt
FROM zamowienie z JOIN asortyment a ON z.idProduktu = a.idProduktu 
ORDER BY z.data_zamowienia;

# 5. suma kwot zamowien poszczegolnych klientow
SELECT CONCAT(k.imie, ' ', k.nazwisko) AS dane_klienta, SUM(z.ilosc*a.cena) AS przychod
FROM klient k JOIN (zamowienie z JOIN asortyment a ON a.idProduktu = z.idProduktu) 
ON k.idKlienta = z.idKlienta 
GROUP BY dane_klienta
ORDER BY dane_klienta;

# 6. dostawy i nazwy dostarczonych produktow
SELECT idDostawy, data_dostawy, dostawa.ilosc, nazwa 
FROM dostawa LEFT OUTER JOIN asortyment 
ON asortyment.idProduktu = dostawa.idProduktu

# 7. nazwy i ceny produktow oraz ich roznice wzgledem sredniej ceny wszystkich produktow
SELECT idProduktu, nazwa, rodzaj, cena, 
(SELECT ROUND(AVG(cena), 2) FROM asortyment) AS srednia_cena, 
ABS(cena - (SELECT ROUND(AVG(cena), 2) FROM asortyment)) AS roznica 
FROM asortyment;

# 8. podsumowanie wszystkich zamowien (dane klienta, co i ile zamawial, koszt, obslugujacy pracownik, data)
SELECT CONCAT(k.imie,' ',k.nazwisko) AS klient, a.nazwa, z.ilosc, 
z.ilosc*a.cena AS koszt, CONCAT(p.imie,' ',p.nazwisko) AS obsluga, 
data_zamowienia FROM (klient k JOIN zamowienie z ON z.idKlienta = k.idKlienta) 
JOIN asortyment a ON a.idProduktu = z.idProduktu JOIN pracownik p ON p.idPracownika = z.idPracownika 
ORDER BY data_zamowienia;

# 9. ilosc sprzedanych produktow
SELECT a.nazwa, a.rodzaj, SUM(z.ilosc) AS lacznie_sprzedano
FROM asortyment a JOIN zamowienie z ON z.idProduktu = a.idProduktu 
GROUP BY z.idProduktu 
ORDER BY lacznie_sprzedano DESC;

# 10. pracownicy, liczba ich klientow oraz ich imiona i nazwiska wypisane w jednej linii
SELECT p.idPracownika, p.imie, p.nazwisko, stanowisko, 
COUNT(z.idKlienta) AS liczba_klientow, 
GROUP_CONCAT(' ', k.imie,' ',k.nazwisko) AS klienci
FROM pracownik p JOIN (zamowienie z JOIN klient k ON z.idKlienta = k.idKlienta) 
ON p.idPracownika = z.idPracownika 
GROUP BY p.idPracownika 
ORDER BY liczba_klientow DESC;
