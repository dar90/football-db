-- Generated by Oracle SQL Developer Data Modeler 20.2.0.167.1538
--   at:        2020-07-18 14:15:44 CEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



DROP VIEW Ekstrakl_rank_strzelcow_19_20 CASCADE CONSTRAINTS 
;

DROP VIEW Ekstraklasa_tabela_19_20 CASCADE CONSTRAINTS 
;

DROP VIEW Ekstraklasa_terminarz_19_20 CASCADE CONSTRAINTS 
;

DROP VIEW Ranking_goli_w_jednym_meczu CASCADE CONSTRAINTS 
;

DROP TABLE gole CASCADE CONSTRAINTS;

DROP TABLE kartki CASCADE CONSTRAINTS;

DROP TABLE kluby CASCADE CONSTRAINTS;

DROP TABLE ligi CASCADE CONSTRAINTS;

DROP TABLE sezony CASCADE CONSTRAINTS;

DROP TABLE sklady CASCADE CONSTRAINTS;

DROP TABLE spotkania CASCADE CONSTRAINTS;

DROP TABLE zawodnicy CASCADE CONSTRAINTS;

DROP SEQUENCE seq_id_zaw;

DROP SEQUENCE seq_id_gola;

DROP SEQUENCE seq_id_kartki;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE gole (
    id_gola       NUMBER NOT NULL,
    minuta        NUMBER(2) NOT NULL,
    id_zawodnika  NUMBER NOT NULL,
    id_spotkania  NUMBER NOT NULL,
    samobojczy    VARCHAR2(3 CHAR) DEFAULT 'NIE' NOT NULL
);

ALTER TABLE gole
    ADD CONSTRAINT gole_minuta_ch CHECK ( minuta BETWEEN 0 AND 90 );

ALTER TABLE gole
    ADD CONSTRAINT gole_samobojczy_ch CHECK ( samobojczy IN ( 'NIE', 'TAK' ) );

ALTER TABLE gole ADD CONSTRAINT gole_pk PRIMARY KEY ( id_gola );

CREATE TABLE kartki (
    id_kartki     NUMBER NOT NULL,
    kolor         VARCHAR2(8 CHAR) NOT NULL,
    minuta        NUMBER(2) NOT NULL,
    id_spotkania  NUMBER NOT NULL,
    id_zawodnika  NUMBER NOT NULL
);

ALTER TABLE kartki
    ADD CONSTRAINT kartki_kolor_ch CHECK ( kolor IN ( 'CZERWONA', 'ŻÓŁTA' ) );

ALTER TABLE kartki
    ADD CONSTRAINT kartki_minuta_ch CHECK ( minuta BETWEEN 0 AND 90 );

ALTER TABLE kartki ADD CONSTRAINT kartki_pk PRIMARY KEY ( id_kartki );

CREATE TABLE kluby (
    id_klubu        NUMBER NOT NULL,
    nazwa           VARCHAR2(100 CHAR) NOT NULL,
    kraj            VARCHAR2(50 CHAR) NOT NULL,
    data_zalozenia  DATE,
    id_ligi         NUMBER NOT NULL
);

ALTER TABLE kluby
    ADD CONSTRAINT kluby_data_zalozenia_ch CHECK ( data_zalozenia BETWEEN TO_DATE('24.10.1857', 'DD.MM.YYYY') AND TO_DATE('01.01.2020',
    'DD.MM.YYYY') );

ALTER TABLE kluby ADD CONSTRAINT kluby_pk PRIMARY KEY ( id_klubu );

CREATE TABLE ligi (
    id_ligi        NUMBER NOT NULL,
    nazwa          VARCHAR2(50 CHAR) NOT NULL,
    kraj           VARCHAR2(50 CHAR),
    liczba_druzyn  NUMBER(3) NOT NULL,
    rok_zalozenia  NUMBER(4)
);

ALTER TABLE ligi ADD CONSTRAINT ligi_liczba_druzyn_ch CHECK ( liczba_druzyn > 1 );

ALTER TABLE ligi ADD CONSTRAINT ligi_pk PRIMARY KEY ( id_ligi );

CREATE TABLE sezony (
    id_sezonu  NUMBER NOT NULL,
    nazwa      VARCHAR2(9 CHAR) NOT NULL,
    poczatek   DATE NOT NULL,
    koniec     DATE NOT NULL,
    id_ligi    NUMBER NOT NULL
);

ALTER TABLE sezony ADD CONSTRAINT sezony_koniec_ch CHECK ( koniec > poczatek );

ALTER TABLE sezony ADD CONSTRAINT sezony_pk PRIMARY KEY ( id_sezonu );

CREATE TABLE sklady (
    id_spotkania  NUMBER NOT NULL,
    id_zawodnika  NUMBER NOT NULL,
    wejscie       NUMBER(2) NOT NULL,
    zejscie       NUMBER(2) NOT NULL,
        czas_gry      NUMBER(2) AS ( zejscie - wejscie + 1 ) VIRTUAL
);

ALTER TABLE sklady
    ADD CONSTRAINT sklady_wejscie_ch CHECK ( wejscie BETWEEN 1 AND 90 );

ALTER TABLE sklady
    ADD CONSTRAINT sklady_zejscie_ch CHECK ( zejscie BETWEEN wejscie AND 90 );

ALTER TABLE sklady ADD CONSTRAINT sklady_pk PRIMARY KEY ( id_spotkania,
                                                          id_zawodnika );

CREATE TABLE spotkania (
    id_spotkania     NUMBER NOT NULL,
    nr_kolejki       NUMBER(5) NOT NULL,
    id_sezonu        NUMBER NOT NULL,
    poczatek         DATE NOT NULL,
    gospodarz        NUMBER NOT NULL,
    gospodarz_wynik  NUMBER(2) DEFAULT 0,
    gosc             NUMBER NOT NULL,
    gosc_wynik       NUMBER(2) DEFAULT 0,
    rozegrane        VARCHAR2(3 CHAR) DEFAULT 'NIE'
);

ALTER TABLE spotkania ADD CONSTRAINT spotkania_gospodarz_wynik_ch CHECK ( gospodarz_wynik >= 0 );

ALTER TABLE spotkania ADD CONSTRAINT spotkania_gosc_wynik_ch CHECK ( gosc_wynik >= 0 );

ALTER TABLE spotkania
    ADD CHECK ( rozegrane IN ( 'NIE', 'TAK' ) );

ALTER TABLE spotkania ADD CONSTRAINT spotkania_pk PRIMARY KEY ( id_spotkania );

CREATE TABLE zawodnicy (
    id_zawodnika    NUMBER NOT NULL,
    imie            VARCHAR2(50 CHAR) NOT NULL,
    nazwisko        VARCHAR2(50 CHAR) NOT NULL,
    data_urodzenia  DATE NOT NULL,
    narodowosc      VARCHAR2(50 CHAR),
    wzrost          NUMBER(3),
    waga            NUMBER(3),
    pozycja         VARCHAR2(20 CHAR) NOT NULL,
    id_klubu        NUMBER NOT NULL
);

ALTER TABLE zawodnicy
    ADD CONSTRAINT zawodnicy_data_urodzenia_ch CHECK ( data_urodzenia < TO_DATE('01.01.2005', 'DD.MM.YYYY') );

ALTER TABLE zawodnicy
    ADD CONSTRAINT zawodnicy_wzrost_ch CHECK ( wzrost BETWEEN 140 AND 220 );

ALTER TABLE zawodnicy
    ADD CONSTRAINT zawodnicy_waga_ch CHECK ( waga BETWEEN 50 AND 130 );

ALTER TABLE zawodnicy
    ADD CONSTRAINT zawodnicy_pozycja_ch CHECK ( pozycja IN ( 'BRAMKARZ', 'NAPASTNIK', 'OBROŃCA', 'POMOCNIK' ) );

ALTER TABLE zawodnicy ADD CONSTRAINT zawodnicy_pk PRIMARY KEY ( id_zawodnika );

ALTER TABLE gole
    ADD CONSTRAINT gole_spotkania_fk FOREIGN KEY ( id_spotkania )
        REFERENCES spotkania ( id_spotkania );

ALTER TABLE gole
    ADD CONSTRAINT gole_zawodnicy_fk FOREIGN KEY ( id_zawodnika )
        REFERENCES zawodnicy ( id_zawodnika );

ALTER TABLE kartki
    ADD CONSTRAINT kartki_spotkania_fk FOREIGN KEY ( id_spotkania )
        REFERENCES spotkania ( id_spotkania );

ALTER TABLE kartki
    ADD CONSTRAINT kartki_zawodnicy_fk FOREIGN KEY ( id_zawodnika )
        REFERENCES zawodnicy ( id_zawodnika );

ALTER TABLE kluby
    ADD CONSTRAINT kluby_ligi_fk FOREIGN KEY ( id_ligi )
        REFERENCES ligi ( id_ligi );

ALTER TABLE sezony
    ADD CONSTRAINT sezony_ligi_fk FOREIGN KEY ( id_ligi )
        REFERENCES ligi ( id_ligi );

ALTER TABLE sklady
    ADD CONSTRAINT sklady_spotkania_fk FOREIGN KEY ( id_spotkania )
        REFERENCES spotkania ( id_spotkania );

ALTER TABLE sklady
    ADD CONSTRAINT sklady_zawodnicy_fk FOREIGN KEY ( id_zawodnika )
        REFERENCES zawodnicy ( id_zawodnika );

ALTER TABLE spotkania
    ADD CONSTRAINT spotkania_kluby1_fk FOREIGN KEY ( gospodarz )
        REFERENCES kluby ( id_klubu );

ALTER TABLE spotkania
    ADD CONSTRAINT spotkania_kluby2_fk FOREIGN KEY ( gosc )
        REFERENCES kluby ( id_klubu );

ALTER TABLE spotkania
    ADD CONSTRAINT spotkania_sezony_fk FOREIGN KEY ( id_sezonu )
        REFERENCES sezony ( id_sezonu );

ALTER TABLE zawodnicy
    ADD CONSTRAINT zawodnicy_kluby_fk FOREIGN KEY ( id_klubu )
        REFERENCES kluby ( id_klubu );

CREATE OR REPLACE VIEW Ekstrakl_rank_strzelcow_19_20 ( ranking, pilkarz, klub, gole ) AS
SELECT RANK() OVER(ORDER BY COUNT(*) DESC) ranking,
(imie||' '||nazwisko) pilkarz, 
kluby.nazwa klub, 
COUNT(*) gole
FROM gole
NATURAL JOIN zawodnicy 
NATURAL JOIN spotkania
JOIN kluby USING(id_klubu)
WHERE id_sezonu = (
    SELECT id_sezonu 
    FROM sezony 
    JOIN ligi USING(id_ligi)
    WHERE ligi.nazwa = 'Ekstraklasa' AND sezony.nazwa = '2019/2020'
) AND samobojczy = 'NIE'
GROUP BY id_zawodnika, imie, nazwisko, kluby.nazwa 
;

CREATE OR REPLACE VIEW Ekstraklasa_tabela_19_20 ( miejsce, klub, wygrane, remisy, przegrane, zdobyte_bramki, stracone_bramki, roznica_bramek, punkty ) AS
SELECT RANK() OVER(ORDER BY SUM(punkty) DESC, SUM(zdobyte)-SUM(stracone) DESC, SUM(zdobyte) DESC) miejsce,
nazwa klub, 
SUM(wygrana) wygrane, SUM(remis) remisy, SUM(przegrana) przegrane,
SUM(zdobyte) zdobyte_bramki, SUM(stracone) stracone_bramki, (SUM(zdobyte)-SUM(stracone)) roznica_bramek,
SUM(punkty) punkty
FROM (
    SELECT gospodarz id_klubu, gospodarz_wynik zdobyte, gosc_wynik stracone,
    CASE
    WHEN gospodarz_wynik > gosc_wynik THEN 3
    WHEN gospodarz_wynik < gosc_wynik THEN 0
    ELSE 1 END punkty,
    CASE WHEN gospodarz_wynik > gosc_wynik THEN 1 ELSE 0 END wygrana,
    CASE WHEN gospodarz_wynik = gosc_wynik THEN 1 ELSE 0 END remis,
    CASE WHEN gospodarz_wynik < gosc_wynik THEN 1 ELSE 0 END przegrana
    FROM spotkania WHERE id_sezonu = 10 AND rozegrane = 'TAK'
    UNION
    SELECT gosc klub, gosc_wynik zdobyte, gospodarz_wynik stracone, CASE
    WHEN gosc_wynik > gospodarz_wynik THEN 3
    WHEN gosc_wynik < gospodarz_wynik THEN 0
    ELSE 1 END punkty,
    CASE WHEN gosc_wynik > gospodarz_wynik THEN 1 ELSE 0 END wygrana,
    CASE WHEN gospodarz_wynik = gosc_wynik THEN 1 ELSE 0 END remis,
    CASE WHEN gosc_wynik < gospodarz_wynik THEN 1 ELSE 0 END przegrana
    FROM spotkania WHERE id_sezonu = 10 AND rozegrane = 'TAK'
)
JOIN kluby USING(id_klubu)
GROUP BY id_klubu, nazwa 
;

CREATE OR REPLACE VIEW Ekstraklasa_terminarz_19_20 ( gospodarz, wynik, gosc, data_spotkania, gole, kartki ) AS
SELECT (SELECT nazwa FROM kluby WHERE id_klubu = gospodarz) gospodarz,
CASE
WHEN rozegrane = 'NIE' THEN '-:-'
WHEN rozegrane = 'TAK' THEN (gospodarz_wynik||':'||gosc_wynik)
END wynik,
(SELECT nazwa FROM kluby WHERE id_klubu = gosc) gosc,
poczatek data_spotkania, nvl(gole, ' ') gole, nvl(kartki, ' ') kartki
FROM spotkania
LEFT JOIN (
    SELECT id_spotkania, 
    LISTAGG(nazwisko||' '||minuta||'''', ', ') WITHIN GROUP(ORDER BY minuta) gole
    FROM gole
    JOIN zawodnicy USING(id_zawodnika)
    JOIN kluby USING(id_klubu)
    GROUP BY id_spotkania
) USING(id_spotkania)
LEFT JOIN (
    SELECT id_spotkania,
    LISTAGG(nazwisko||'('||substr(kolor,1,1)||') '||minuta||'''', ', ') WITHIN GROUP(ORDER BY minuta) kartki
    FROM kartki
    JOIN zawodnicy USING(id_zawodnika)
    JOIN kluby USING(id_klubu)
    GROUP BY id_spotkania
) USING(id_spotkania)
WHERE id_sezonu = 10
ORDER BY data_spotkania 
;

CREATE OR REPLACE VIEW Ranking_goli_w_jednym_meczu ( ranking, pilkarz, mecz, data_spotkania, liczba_goli, gole ) AS
SELECT RANK() OVER(ORDER BY COUNT(*) DESC) ranking, (imie||' '||nazwisko) pilkarz, 
((SELECT nazwa FROM kluby WHERE id_klubu = gospodarz)
||' - '||(SELECT nazwa FROM kluby WHERE id_klubu = gosc)) mecz,
poczatek data_spotkania, COUNT(*) liczba_goli,
LISTAGG(minuta, ''' ') WITHIN GROUP(ORDER BY minuta)||'''' gole
FROM gole
NATURAL JOIN zawodnicy
NATURAL JOIN spotkania
WHERE samobojczy = 'NIE'
GROUP BY id_spotkania, id_zawodnika, imie, nazwisko, gospodarz, gosc, poczatek 
;

CREATE SEQUENCE seq_id_gola START WITH 1 MINVALUE 1 MAXVALUE 9999 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER gole_id_gola_trg BEFORE
    INSERT ON gole
    FOR EACH ROW
    WHEN ( new.id_gola IS NULL )
BEGIN
    :new.id_gola := seq_id_gola.nextval;
END;
/

CREATE SEQUENCE seq_id_kartki START WITH 1 MINVALUE 1 MAXVALUE 9999 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER kartki_id_kartki_trg BEFORE
    INSERT ON kartki
    FOR EACH ROW
    WHEN ( new.id_kartki IS NULL )
BEGIN
    :new.id_kartki := seq_id_kartki.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             0
-- ALTER TABLE                             37
-- CREATE VIEW                              4
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          2
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

CREATE SEQUENCE seq_id_zaw
MINVALUE 1
MAXVALUE 10000
START WITH 1
NOCYCLE
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER Sprawdz_limit_druzyn_ligi BEFORE INSERT ON Kluby
FOR EACH ROW
DECLARE 
    limit_druzyn INTEGER;
    aktualna_ilosc INTEGER;
BEGIN
    SELECT liczba_druzyn INTO limit_druzyn FROM Ligi WHERE id_ligi = :new.id_ligi;
    SELECT COUNT(*) INTO aktualna_ilosc FROM Kluby WHERE id_ligi = :new.id_ligi;
    
    IF aktualna_ilosc = limit_druzyn THEN
        raise_application_error(-20001, 'ANULOWANIE procedury wprowadzania 
        nowego klubu. Nie mozna dodac wiecej druzyn do ligi '||:new.id_ligi||'!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Sprawdz_nr_kolejki BEFORE INSERT ON Spotkania
FOR EACH ROW
DECLARE
    liczba_kolejek INTEGER;
    liga INTEGER;
BEGIN
    SELECT id_ligi, 2*(liczba_druzyn-1) INTO liga, liczba_kolejek FROM Ligi 
    WHERE id_ligi = (
        SELECT id_ligi FROM Sezony WHERE id_sezonu = :new.id_sezonu
    );
    
    IF :new.nr_kolejki > liczba_kolejek THEN
        raise_application_error(-20001, 'ANULOWANIE procedury wprowadzania 
        nowego spotkania. Podano za duzy numer kolejki - '
        ||' liczba kolejek dla ligi '||liga||' wynosi '||liczba_kolejek);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Sprawdz_poczatek_spotkania BEFORE INSERT ON Spotkania
FOR EACH ROW
DECLARE
    poczatek_sezonu DATE;
    koniec_sezonu DATE;
BEGIN
    SELECT poczatek, koniec INTO poczatek_sezonu, koniec_sezonu 
    FROM Sezony WHERE id_sezonu = :new.id_sezonu;
    
    IF :new.poczatek NOT BETWEEN poczatek_sezonu AND koniec_sezonu THEN 
        raise_application_error(-20001, 'ANULOWANIE procedury wprowadzania nowego 
        spotkania. Podana data spotkania nie miesci sie w ramach czasowych sezonu.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Sprawdz_gospodarza_spotkania BEFORE INSERT ON Spotkania
FOR EACH ROW
DECLARE
    liga_gospodarza INTEGER;
    liga_spotkania INTEGER;
BEGIN
    SELECT id_ligi INTO liga_gospodarza FROM Kluby WHERE id_klubu = :new.gospodarz;
    SELECT id_ligi INTO liga_spotkania FROM Sezony WHERE id_sezonu = :new.id_sezonu;
    
    IF liga_gospodarza != liga_spotkania THEN 
        raise_application_error(-20001, 'Klub o id '||:new.gospodarz||
        ' nie nalezy do ligi o id '||liga_spotkania||'!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Sprawdz_goscia_spotkania BEFORE INSERT ON Spotkania
FOR EACH ROW
DECLARE
    liga_goscia INTEGER;
    liga_spotkania INTEGER;
BEGIN
    SELECT id_ligi INTO liga_goscia FROM Kluby WHERE id_klubu = :new.gosc;
    SELECT id_ligi INTO liga_spotkania FROM Sezony WHERE id_sezonu = :new.id_sezonu;
    
    IF liga_goscia != liga_spotkania THEN 
        raise_application_error(-20001, 'Klub o id '||:new.gosc||
        ' nie nalezy do ligi o id '||liga_spotkania||'!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Sprawdz_czy_druga_zolta BEFORE INSERT ON Kartki
FOR EACH ROW
WHEN (NEW.kolor = 'ŻÓŁTA')
DECLARE 
    liczba_kartek_w_meczu INTEGER;
BEGIN
    SELECT COUNT(*) INTO liczba_kartek_w_meczu FROM Kartki 
    WHERE id_spotkania = :new.id_spotkania AND id_zawodnika = :new.id_zawodnika;
    
    IF liczba_kartek_w_meczu = 1 THEN
        :new.kolor := 'CZERWONA';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Ustaw_minute_zejscia BEFORE INSERT ON Kartki
FOR EACH ROW 
FOLLOWS Sprawdz_czy_druga_zolta
WHEN (NEW.kolor = 'CZERWONA')
BEGIN
    UPDATE Sklady SET zejscie = :new.minuta 
    WHERE id_spotkania = :new.id_spotkania AND id_zawodnika = :new.id_zawodnika;
END;
/

CREATE OR REPLACE TRIGGER Sprawdz_czy_ma_czerwona BEFORE INSERT ON Sklady
FOR EACH ROW
DECLARE
    liczba_czerwonych INTEGER;
    sezon INTEGER;
    kolejka INTEGER;
BEGIN
    SELECT id_sezonu, nr_kolejki INTO sezon, kolejka
    FROM Spotkania 
    WHERE id_spotkania = :new.id_spotkania;

    SELECT COUNT(*) INTO liczba_czerwonych
    FROM kartki
    NATURAL JOIN zawodnicy
    NATURAL JOIN spotkania
    WHERE id_zawodnika = :new.id_zawodnika AND id_sezonu = sezon 
    AND nr_kolejki IN (kolejka, kolejka-1, kolejka-2) AND kolor = 'CZERWONA';
    
    IF liczba_czerwonych > 0 THEN
        raise_application_error(-20001, 'Zawodnik o id '||:new.id_zawodnika
        ||' w ciagu 2 ostatnich spotkan otrzymal czerwona kartke i nie moze 
        uczestniczyc w tym spotkaniu');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER Zaktualizuj_wynik AFTER INSERT ON Gole
FOR EACH ROW
DECLARE
    klub_strzelajacego INTEGER;
    gospodarz INTEGER;
    gosc INTEGER;
BEGIN
    SELECT id_klubu INTO klub_strzelajacego
    FROM Zawodnicy WHERE id_zawodnika = :new.id_zawodnika;
    
    SELECT gospodarz, gosc INTO gospodarz, gosc
    FROM Spotkania WHERE id_spotkania = :new.id_spotkania;

    IF :new.samobojczy = 'NIE' AND klub_strzelajacego = gospodarz 
    OR :new.samobojczy = 'TAK' AND klub_strzelajacego = gosc THEN 
        UPDATE Spotkania SET gospodarz_wynik = gospodarz_wynik + 1 
        WHERE id_spotkania = :new.id_spotkania;
    END IF;
    
    IF :new.samobojczy = 'NIE' AND klub_strzelajacego = gosc
    OR :new.samobojczy = 'TAK' AND klub_strzelajacego = gospodarz THEN
        UPDATE Spotkania SET gosc_wynik = gosc_wynik + 1 
        WHERE id_spotkania = :new.id_spotkania;  
    END IF;
   
END;
/

CREATE OR REPLACE TRIGGER Formatuj_dane_zawodnika BEFORE INSERT ON Zawodnicy
FOR EACH ROW
BEGIN
    :new.imie := initcap(:new.imie);
    :new.nazwisko := initcap(:new.nazwisko);
    
    IF :new.narodowosc IS NOT NULL THEN
        :new.narodowosc := upper(:new.narodowosc);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER sprawdz_czy_dwie_rozne_druzyny BEFORE INSERT ON spotkania
FOR EACH ROW
BEGIN
    IF :NEW.gospodarz = :NEW.gosc THEN
        raise_application_error(-20001, 'ANULOWANIE procedury wprowadzania nowego spotkania - 
        gospodarz i gosc spotkania nie moze byc ta sama druzyna.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER sprawdz_liczbe_meczy_w_kolejce BEFORE INSERT ON spotkania
FOR EACH ROW
DECLARE
    rozegrane_spotkania_gospodarz INTEGER;
    rozegrane_spotkania_gosc INTEGER;
BEGIN
    SELECT COUNT(*) INTO rozegrane_spotkania_gospodarz
    FROM spotkania
    WHERE (gospodarz = :NEW.gospodarz OR gosc = :NEW.gospodarz) 
    AND id_sezonu = :NEW.id_sezonu AND nr_kolejki = :NEW.nr_kolejki;
    
    SELECT COUNT(*) INTO rozegrane_spotkania_gosc
    FROM spotkania
    WHERE (gospodarz = :NEW.gosc OR gosc = :NEW.gosc) 
    AND id_sezonu = :NEW.id_sezonu AND nr_kolejki = :NEW.nr_kolejki;
    
    IF rozegrane_spotkania_gospodarz > 0 THEN
        raise_application_error(-20001, 'ANULOWANIE procedury wprowadzania nowego spotkania - 
        gospodarz spotkania rozegral juz jeden mecz w kolejce numer '||:NEW.nr_kolejki||' sezonu
         o id '||:NEW.id_sezonu);
    END IF;
    
    IF rozegrane_spotkania_gosc > 0 THEN 
        raise_application_error(-20001, 'ANULOWANIE procedury wprowadzania nowego spotkania - 
        gosc spotkania rozegral juz jeden mecz w kolejce numer '||:NEW.nr_kolejki||' sezonu
         o id '||:NEW.id_sezonu);
    END IF;
END;
/