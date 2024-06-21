--Per ogni EDIFICIO, individuare il CDL dei corsi con il maggior NUMEROORE di lezione, considerando solo i docenti del dipartimento DipB
----e del DipC


--select a.EDIFICIO, c.CDL,count(*) as numlez
--from AULA a
--join LEZIONE l on l.IDAULA=a.IDAULA
--join CORSO c on c.IDCORSO= l.IDCORSO
--join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE and d.RUOLO=l.RUOLO
--where d.DIPARTIMENTO='DipC' or d.DIPARTIMENTO='DipB'
--group by a.EDIFICIO, c.CDL
--having count(*)>=all(
--	select count(*)
--	from aula a1
--	join lezione l1 on l1.IDAULA=a1.IDAULA
--	join CORSO c1 on c1.IDCORSO=l1.IDCORSO
--	join DOCENTE d1 on d1.IDDOCENTE=l1.IDDOCENTE and d1.RUOLO=l1.RUOLO
--	where a1.EDIFICIO=a.EDIFICIO
--	and (d1.DIPARTIMENTO='DipC' or d1.DIPARTIMENTO='DipB')
--	group by a1.EDIFICIO, c1.CDL
--)


--CREATE VIEW DATAORE AS
--SELECT A.EDIFICIO, C.CDL, SUM(L.NUMEROORE) AS TOTORE
--FROM DOCENTE AS D, LEZIONE AS L, CORSO AS C, AULA AS A
--WHERE (D.RUOLO=L.RUOLO AND D.IDDOCENTE=L.IDDOCENTE AND L.IDCORSO = C.IDCORSO AND L.IDAULA = A.IDAULA)
--AND D.DIPARTIMENTO IN ('DipB', 'DipC')
--GROUP BY A.EDIFICIO, C.CDL

--SELECT D1.EDIFICIO, D1.CDL
--FROM DATAORE D1
--WHERE D1.TOTORE >= ALL(
--SELECT D2.TOTORE
--FROM DATAORE D2
--WHERE D2.EDIFICIO = D1.EDIFICIO
--)

-- Scrivere una vista BiDipartimentali che individua i corsi (tutti gli attributi) tali che le lezioni di quel Corso sono state tenute da docenti di
--esattamente due dipartimenti diversi
--Scrivere quindi una query (usando eventualmente altre viste) che per ogni corso in BiDipartimentali riporta, oltre al corso, due attributi
--DIPARTIMENTO_1, DIPARTIMENTO_2 con tali due dipartimenti distinti


--create view BiDipartimentali as
--select *
--from corso 
--where IDCORSO in(
--	select l.IDCORSO 
--	from LEZIONE l
--	join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE and d.RUOLO=l.RUOLO
--	group by l.IDCORSO
--	having count(distinct d.DIPARTIMENTO)=2
--)

create view temp as
 select c.*, d.DIPARTIMENTO
 from CORSO c
 join lezione l on l.IDCORSO=c.IDCORSO
 join docente d on d.IDDOCENTE=l.IDDOCENTE and d.RUOLO=l.RUOLO
 where c.IDCORSO in(
	select *
	from
 )