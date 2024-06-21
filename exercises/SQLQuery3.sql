----- CREARE UN DATABASE E QUINDI FAR GIRARE IL SEGUENTE SCRIPT


--CREATE TABLE CORSO (
--    IDCORSO INT PRIMARY KEY,
--    CDL VARCHAR(255) 
--);

--CREATE TABLE AULA (
--    IDAULA INT PRIMARY KEY,
--    EDIFICIO VARCHAR(255) 
--);

--CREATE TABLE DOCENTE (
--    IDDOCENTE INT,
--    RUOLO VARCHAR(255),
--    DIPARTIMENTO VARCHAR(255),
--    PRIMARY KEY (IDDOCENTE, RUOLO)
--);

--CREATE TABLE LEZIONE (
--    IDCORSO INT,
--    IDAULA INT,
--    IDDOCENTE INT,
--    RUOLO VARCHAR(255),
--    NUMEROORE INT,
--    PRIMARY KEY (IDCORSO, IDAULA, IDDOCENTE, RUOLO),
--    FOREIGN KEY (IDCORSO) REFERENCES CORSO(IDCORSO),
--    FOREIGN KEY (IDAULA) REFERENCES AULA(IDAULA),
--    FOREIGN KEY (IDDOCENTE, RUOLO) REFERENCES DOCENTE(IDDOCENTE, RUOLO)
--);



--INSERT INTO CORSO (IDCORSO, CDL) VALUES
--(1, 'CDL1'),
--(2, 'CDL2'),
--(3, 'CDL2'),
--(4, 'CDL3'),
--(5, 'CDL3');

--INSERT INTO AULA (IDAULA, EDIFICIO) VALUES
--(101, 'EdiZ'),
--(102, 'EdiZ'),
--(103, 'EdiK'),
--(104, 'EdiW'),
--(105, 'EdiW');


--INSERT INTO DOCENTE (IDDOCENTE, RUOLO, DIPARTIMENTO) VALUES
--(201, 'Professore', 'DipA'),
--(201, 'Assistente', 'DipB'),
--(202, 'Professore', 'DipB'),
--(204, 'Professore', 'DipC'),
--(202, 'Assistente', 'DipC');

--INSERT INTO LEZIONE (IDCORSO, IDAULA, IDDOCENTE, RUOLO, NUMEROORE) VALUES
--(1, 101, 201, 'Professore', 3),
--(2, 102, 201, 'Assistente', 4),
--(3, 103, 202, 'Professore', 2),
--(4, 104, 204, 'Professore', 3),
--(5, 105, 202, 'Assistente', 2),
--(1, 102, 201, 'Assistente', 2),
--(2, 103, 202, 'Professore', 3),
--(3, 104, 204, 'Professore', 4),
--(4, 105, 202, 'Assistente', 2),
--(5, 101, 201, 'Professore', 3),
--(1, 103, 202, 'Professore', 2),
--(2, 104, 204, 'Professore', 3),
--(3, 105, 202, 'Assistente', 4),
--(4, 101, 201, 'Professore', 2),
--(5, 102, 201, 'Assistente', 3);

--SELECT distinct c.*
--FROM CORSo C
--join lezione l on l.idcorso=c.idcorso
--join aula a on a.idaula=l.idaula
--join docente d on d.iddocente=l.iddocente and l.ruolo=d.ruolo
--WHERE (A.EDIFICIO='EdiZ' or A.EDIFICIO='Ediw') and D.DIPARTIMENTO='DipA'

--SELECT distinct a.edificio
--FROM aula a
--where a.edificio not in(
--	select a1.edificio
--	from aula a1
--	join lezione l on l.idaula=a1.idaula
--	join corso c on c.idcorso=l.idcorso
--	join docente d on l.iddocente=d.iddocente and l.ruolo=d.ruolo
--	where c.cdl='CDL1'
--	and d.dipartimento='DipB'
--)

--AULE in cui ci sono state lezioni di tutti i docenti del dipartimento 'DipA', considerando solo lezioni dei corsi del CDL='CDL1'
--select a.*
--from aula a
--where not exists(
--	select *
--	from docente d
--	where d.dipartimento='DipA'
--	and not exists(
--		select *
--		from lezione l
--		join corso c on c.idcorso=l.idcorso
--		where c.cdl='CDL1'
--		and	l.idaula=a.idaula
--		and l.iddocente=d.iddocente
--		and l.ruolo=d.ruolo
--	)
--	)

--Per ogni EDIFICIO, individuare il CDL dei corsi con il maggior NUMEROORE di lezione, considerando solo i docenti del dipartimento DipB
--e del DipC

--create view datalez as
--	select a.edificio, c.cdl, sum(l.numeroore) as totore
--	from aula a
--	join lezione l on l.idaula=a.idaula
--	join corso c on c.idcorso=l.idcorso
--	join docente d on d.iddocente=l.iddocente and d.ruolo=l.ruolo
--	where d.dipartimento='DipB' or d.dipartimento='DipC'
--	group by a.edificio, c.cdl


--create view dataore as
--	select edificio, cdl,sum(numeroore) as tot
--	from aula 
--	join lezione on l.idaula=a.idaula
--	join corso on c.idcorso=l.idcorso
--	join docente on d.iddocente=l.iddocente and d.ruolo=l.ruolo
--	where dipartimento='DipB' or dipartimento='DipC'
--	group by edificio,cdl

