--Scrivere una vista BiDipartimentali che individua i corsi (tutti gli attributi) tali che le lezioni di quel Corso sono state tenute da docenti di
--esattamente due dipartimenti diversi

create view BiDip as(
	select c.*
	from CORSO c
	join LEZIONE l on l.IDCORSO=c.IDCORSO
	join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE and l.RUOLO=d.RUOLO
	group by c.CDL,c.IDCORSO
	having count(distinct d.DIPARTIMENTO)=2
	)

--Scrivere quindi una query (usando eventualmente altre viste) che per ogni corso in BiDipartimentali riporta, oltre al corso, due attributi
--DIPARTIMENTO_1, DIPARTIMENTO_2 con tali due dipartimenti distinti

select distinct b1.IDCORSO, d1.DIPARTIMENTO as DIPARTIMENTO_1,d2.DIPARTIMENTO as DIPARTIMENTO_2
from BiDip b1
join LEZIONE l1 on b1.IDCORSO=l1.IDCORSO
join LEZIONE l2 on b1.IDCORSO=l2.IDCORSO
join docente d1 on l1.IDDOCENTE=d1.IDDOCENTE and l1.RUOLO=d1.RUOLO
join DOCENTE d2 on d2.IDDOCENTE=l2.IDDOCENTE and l2.RUOLO=d2.RUOLO
where d1.DIPARTIMENTO<d2.DIPARTIMENTO
