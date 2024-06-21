--CREATE TABLE [dbo].[AUTORE](
--    [NOME] [varchar](20) NOT NULL,
--    [COGNOME] [varchar](20) NOT NULL,
--    [CITTA] [char](2) NULL,
--    PRIMARY KEY ([NOME], [COGNOME])
--);

--CREATE TABLE [dbo].[LIBRO](
--    [ISBN] [char](13) NOT NULL,
--    [TITOLO] [varchar](50) NOT NULL,
--    [CITTA] [char](2) NULL,
--    [ANNO_PUBBLICAZIONE] [int] NOT NULL,
--    PRIMARY KEY ([ISBN])
--);

--CREATE TABLE [dbo].[PRESTITO](
--    [NumeroPrestito] [int] NOT NULL,
--    [ISBN] [char](13) NULL,
--    [UTENTE] [varchar](20) NULL,
--    PRIMARY KEY ([NumeroPrestito])
--);

--CREATE TABLE [dbo].[SCRIVE](
--    [ISBN] [char](13) NOT NULL,
--    [NOME_AUTORE] [varchar](20) NOT NULL,
--    [COGNOME_AUTORE] [varchar](20) NOT NULL,
--    PRIMARY KEY ([ISBN], [NOME_AUTORE], [COGNOME_AUTORE]),
--    FOREIGN KEY ([ISBN]) REFERENCES [dbo].[LIBRO]([ISBN]),
--    FOREIGN KEY ([NOME_AUTORE], [COGNOME_AUTORE]) REFERENCES [dbo].[AUTORE]([NOME], [COGNOME])
--);


--INSERT INTO AUTORE (NOME, COGNOME, CITTA) VALUES ('MARIO', 'ROSSI', 'RM');
--INSERT INTO AUTORE (NOME, COGNOME, CITTA) VALUES ('SIMONA', 'BIANCHI', 'NA');
--INSERT INTO AUTORE (NOME, COGNOME, CITTA) VALUES ('LUCA', 'VERDI', 'MI');
--INSERT INTO AUTORE (NOME, COGNOME, CITTA) VALUES ('GIANLUCA', 'ROSSI', 'MI');


--INSERT INTO LIBRO VALUES ('L1', 'IL CODICE', 'RM', 2010);
--INSERT INTO LIBRO VALUES ('L2', 'LA PROGRAMMAZIONE', 'NA', 2015);
--INSERT INTO LIBRO VALUES ('L3', 'I DATABASE', 'TO', 2022);
--INSERT INTO LIBRO VALUES ('L4', 'LA RICERCA', 'NA', 2020);
--INSERT INTO LIBRO VALUES ('L5', 'IL RITORNO', 'RM', 2012);
--INSERT INTO LIBRO VALUES ('L6', 'URBANO', 'RM', 2012);

--INSERT INTO SCRIVE VALUES ('L1', 'MARIO', 'ROSSI');
--INSERT INTO SCRIVE VALUES ('L1', 'SIMONA', 'BIANCHI');
--INSERT INTO SCRIVE VALUES ('L2', 'LUCA', 'VERDI');
--INSERT INTO SCRIVE VALUES ('L2', 'MARIO', 'ROSSI');
--INSERT INTO SCRIVE VALUES ('L3', 'GIANLUCA', 'ROSSI');
--INSERT INTO SCRIVE VALUES ('L4', 'LUCA', 'VERDI');
--INSERT INTO SCRIVE VALUES ('L3', 'LUCA', 'VERDI');


--INSERT INTO PRESTITO VALUES (1, 'L1', 'Mario_Rossi');
--INSERT INTO PRESTITO VALUES (2, 'L1', 'Luca_Bianchi');
--INSERT INTO PRESTITO VALUES (3, 'L3', 'Anna_Verdi');
--INSERT INTO PRESTITO VALUES (4, 'L3', 'Mario_Rossi');
--INSERT INTO PRESTITO VALUES (5, 'L5', 'Giovanna_Neri');
--INSERT INTO PRESTITO VALUES (6, 'L6', 'Giovanna_Neri');
--INSERT INTO PRESTITO VALUES (7, 'L3', 'Anna_Verdi');
--INSERT INTO PRESTITO VALUES (8, 'L2', 'Anna_Verdi');

--Aggiungere alla table PRESTITO la    FOREIGN KEY (ISBN) REFERENCES LIBRI in modo tale che
--(importante: le due istruzioni devono essere eseguite singolarmente nell'ordine dato)
--DELETE FROM LIBRO WHERE ISBN='L6' 
---- NON DEVE ESSERE CONSENTITA SE IN PRESTITO CI SONO TUPLE CON 'L6'
--UPDATE LIBRO SET ISBN= '_' + ISBN  WHERE ISBN='L6' 
---- MODIFICHI L'ISBN NEI RELATIVI PRESTITO IN SCRIVE

--alter table prestito
--	add constraint prestito_fk  foreign key (ISBN) references libro 
--	on delete no action 
--	on update cascade

	--Selezionare gli utenti (tutti gli attributi) che hanno preso in prestito almeno un libro scritto da almeno un autore di Roma (RM)
	--select distinct p.*
	--from prestito p
	--join scrive s on s.ISBN=p.ISBN
	--join autore a on a.nome=s.nome_autore and a.cognome=s.cognome_autore
	--where a.citta='RM'
	--Selezionare gli utenti (tutti gli attributi) che hanno preso in prestito almeno un libro scritto da almeno due autori di Milano (MI)
--create view numaut as
--	select l.*,a.citta as attcitta, count(*) as numautori
--	from libro l 
--	join scrive s on s.ISBN=l.ISBN
--	join autore a on  a.nome=s.nome_autore and a.cognome=s.cognome_autore
--	group by  l.isbn,l.titolo,l.citta,l.anno_pubblicazione, a.citta
	
--select p.*
--from prestito p
--join numaut n on n.isbn=p.isbn
--where numautori>=2 and attcitta='MI'



--	--Selezionare gli utenti (tutti gli attributi) che non hanno mai preso in prestito  un libro scritto da almeno due autori di Milano (MI)
--	select utente 
--	from prestito 
--	where utente not in(
--		select p.utente 
--		from prestito p
--		join numaut n on p.isbn=n.isbn
--		where n.numautori>=2 and n.attcitta='MI'
--	)

--	ALTER TABLE PRESTITO

--     ADD CONSTRAINT PRESTITO_LIBRO_FK

--         FOREIGN KEY (ISBN) REFERENCES LIBRO

--          ON DELETE NO ACTION

--          ON UPDATE CASCADE

--		  	select distinct p.*

--	from prestito p

--	join libro l on p.ISBN=l.ISBN

--	join scrive s on s.ISBN=l.ISBN

--	join autore a on a.nome=s.nome_autore and a.cognome=s.cognome_autore

--	where a.citta='RM'

--	SELECT UTENTE
--FROM PRESTITO
--WHERE ISBN IN (
--SELECT        LIBRO.ISBN
--FROM            dbo.LIBRO  INNER JOIN
--                         dbo.SCRIVE ON dbo.LIBRO.ISBN = dbo.SCRIVE.ISBN INNER JOIN
--                         dbo.AUTORE ON dbo.SCRIVE.NOME_AUTORE = dbo.AUTORE.NOME AND dbo.SCRIVE.COGNOME_AUTORE = dbo.AUTORE.COGNOME
--WHERE AUTORE.CITTA='MI'
--GROUP BY LIBRO.ISBN
--HAVING COUNT(*)=2)
 