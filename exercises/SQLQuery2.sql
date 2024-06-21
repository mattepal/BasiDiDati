---- Creazione delle tabelle
--CREATE TABLE studente (
--    MATRICOLA INT PRIMARY KEY,
--    nome VARCHAR(50),
--    cognome VARCHAR(50)
--);

--CREATE TABLE insegnamento (
--    CODI INT PRIMARY KEY,
--    nome VARCHAR(50),
--    corso VARCHAR(50),
--    cfu INT
--);

--CREATE TABLE esame (
--    DATA DATE,
--    CODI INT,
--    MATRICOLA INT,
--    voto INT,  -- Modifica del campo esito in voto di tipo INT
--    PRIMARY KEY (DATA, CODI, MATRICOLA),
--    FOREIGN KEY (CODI) REFERENCES insegnamento(CODI),
--    FOREIGN KEY (MATRICOLA) REFERENCES studente(MATRICOLA)
--);

---- Inserimento di dati fittizi con voti numerici
--INSERT INTO studente (MATRICOLA, nome, cognome) VALUES
--    (1, 'Mario', 'Rossi'),
--    (2, 'Luca', 'Bianchi'),
--    (3, 'Anna', 'Verdi');

--INSERT INTO insegnamento (CODI, nome, corso, cfu) VALUES
--    (101, 'Matematica', 'Scienze Informatiche', 6),
--    (102, 'Programmazione', 'Ingegneria del Software', 8),
--    (103, 'Fisica', 'Fisica Teorica', 6),
--	(104, 'Analisi 1', 'Scienze Matematiche', 9);

--INSERT INTO esame (DATA, CODI, MATRICOLA, voto) VALUES
--    ('2023-01-15', 101, 1, 80),  -- Voto 80
--    ('2023-02-20', 102, 2, 60),  -- Voto 60
--    ('2023-03-10', 103, 3, 90),  -- Voto 90
--	('2023-04-05', 104, 1, 20),  -- Voto maggiore di 18
--    ('2023-04-10', 104, 1, 15);  -- Voto minore di 18

select *
from insegnamento

select *
from esame

select * 
from studente S
where not exists(
	select *
	from insegnamento I
	where I.corso='ing. inf.'
	and not exists(
		select *
		from esame E
		where E.MATRICOLA=S.MATRICOLA
		and E.CODI=I.CODI
		and E.voto>=18
	)
) 
