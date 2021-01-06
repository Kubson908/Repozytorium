# trigger dodajacy ilosc produktow z dostawy do asortymentu
DELIMITER // 
CREATE TRIGGER ai_dostawa 
AFTER INSERT ON dostawa
FOR EACH ROW 
BEGIN
    UPDATE asortyment 
    SET ilosc = ilosc + NEW.ilosc 
    WHERE idProduktu = NEW.idProduktu;
END //
DELIMITER ;

# trigger odejmujacy zamowiona ilosc z asortymentu 
DELIMITER $$
CREATE TRIGGER ai_zamowienie 
AFTER INSERT ON zamowienie
FOR EACH ROW
BEGIN
	UPDATE asortyment 
    SET ilosc = ilosc - NEW.ilosc 
    WHERE idProduktu = NEW.idProduktu;
END $$
DELIMITER ;

# trigger sprawdzajacy czy osoba chcaca kupic alkohol ma ukonczone 18 lat
DROP TRIGGER IF EXISTS bi_zamowienie;
DELIMITER // 
CREATE TRIGGER bi_zamowienie 
BEFORE INSERT ON zamowienie 
FOR EACH ROW 
BEGIN 
	DECLARE wiek INT;
    DECLARE alkohol VARCHAR(8);
    SET wiek := (SELECT DATEDIFF(NEW.data_zamowienia, dataUr) FROM klient WHERE idKlienta = NEW.idKlienta);
    SET alkohol := (SELECT rodzaj FROM asortyment WHERE idProduktu = NEW.idProduktu);
	IF (wiek < 6750 AND alkohol = 'alkohol')
    THEN SIGNAL SQLSTATE '45000' SET message_text = 'Osoba niepelnoletnia';
    END IF;
END //
DELIMITER ;

# procedura zwiekszajaca ceny slodzonych napojow
DELIMITER //
CREATE PROCEDURE podwyzka_cen_slodkich_napojow() 
BEGIN
	UPDATE asortyment SET cena = cena + 2 
    WHERE rodzaj = 'napoj' AND nazwa <> 'woda_mineralna';
END //
DELIMITER ;

# funkcja obliczajaca wysokosc pensji pracownika po podwyzce
DELIMITER //
CREATE FUNCTION podwyzka(pensja FLOAT, podwyzka FLOAT) 
RETURNS FLOAT
BEGIN
	DECLARE po_podwyzce FLOAT;
    SET po_podwyzce = pensja * podwyzka;
    RETURN po_podwyzce;
END //
DELIMITER ;