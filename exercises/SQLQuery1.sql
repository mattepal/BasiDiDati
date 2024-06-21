---- Creazione della tabella autore
--CREATE TABLE autore (
--    id INT PRIMARY KEY,
--    nome VARCHAR(255),
--    cognome VARCHAR(255),
--    naz VARCHAR(50)
--);

---- Creazione della tabella libro
--CREATE TABLE libro (
--    isbn VARCHAR(13) PRIMARY KEY,
--    titolo VARCHAR(255),
--    idautore INT,
--    anno INT,
--    FOREIGN KEY (idautore) REFERENCES autore(id)
--);

---- Creazione della tabella utente
--CREATE TABLE utente (
--    numtess INT PRIMARY KEY,
--    nome VARCHAR(255),
--    cognome VARCHAR(255)
--);

---- Creazione della tabella prestito
--CREATE TABLE prestito (
--    isbn VARCHAR(13),
--    numtess INT,
--    datau DATE,
--    datar DATE,
--    PRIMARY KEY (isbn, numtess, datau),
--    FOREIGN KEY (isbn) REFERENCES libro(isbn),
--    FOREIGN KEY (numtess) REFERENCES utente(numtess)
--);


---- Inserimento dati nella tabella autore
--INSERT INTO autore (id, nome, cognome, naz)
--VALUES
--    (1, 'John', 'Doe', 'USA'),
--    (2, 'Maria', 'Rossi', 'IT'),
--    (3, 'Carlos', 'Gonzalez', 'ES');

---- Inserimento dati nella tabella libro
--INSERT INTO libro (isbn, titolo, idautore, anno)
--VALUES
--    ('1234567890123', 'Il segreto', 1, 2010),
--    ('2345678901234', 'La scoperta', 2, 2015),
--    ('3456789012345', 'Viaggio nel tempo', 3, 2020);

---- Inserimento dati nella tabella utente
--INSERT INTO utente (numtess, nome, cognome)
--VALUES
--    (101, 'Alice', 'Bianchi'),
--    (102, 'Bob', 'Verdi'),
--    (103, 'Elena', 'Russo');

---- Inserimento dati nella tabella prestito
--INSERT INTO prestito (isbn, numtess, datau, datar)
--VALUES
--    ('1234567890123', 101, '2023-01-01', '2023-02-01'),
--    ('2345678901234', 102, '2023-02-01', '2023-03-01'),
--    ('3456789012345', 103, '2023-03-01', '2023-04-01');

--INSERT INTO libro (isbn, titolo, idautore, anno)
--VALUES
--    ('4567890123456', 'Lavventura', 1, 2012),
--    ('5678901234567', 'Segreti nascosti', 2, 2018),
--    ('6789012345678', 'Mistero svelato', 3, 2016);

---- Inserimento dati nella tabella prestito
--INSERT INTO prestito (isbn, numtess, datau, datar)
--VALUES
--    ('4567890123456', 101, '2023-04-01', '2023-05-01'),
--    ('5678901234567', 102, '2023-05-01', '2023-06-01'),
--    ('6789012345678', 103, '2023-06-01', '2023-07-01'),
--    ('1234567890123', 102, '2023-07-01', '2023-08-01'),
--    ('2345678901234', 103, '2023-08-01', '2023-09-01');




--select a.naz, count(l.isbn) as libripres, count(distinct p.isbn) as prest, count(distinct p.numtess) as numutenti
--from autore a
--join libro l on l.idautore=a.id
--join prestito p on p.isbn=l.isbn
--group by a.naz



