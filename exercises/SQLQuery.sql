-- 11 dicembre
alter table prestito
	add constraint fk_prestito foreign key(ISBN) references libri
	on delete no action 
	on update cascade 

select p.UTENTE
from PRESTITO p
join scrive s on s.ISBN=p.ISBN
join AUTORE a on s.NOME_AUTORE=a.NOME and s.COGNOME_AUTORE=a.COGNOME
where a.CITTA='RM'

select p.UTENTE
from PRESTITO p
where p.ISBN in(
	select s.ISBN
	from SCRIVE s
	join AUTORE a on a.NOME=s.NOME_AUTORE and a.COGNOME=s.COGNOME_AUTORE
	where a.CITTA='mi'
	group by s.ISBN
	having count(s.NOME_AUTORE)>=2
)
create view milano as 

	select s.ISBN
	from SCRIVE s
	join AUTORE a on a.NOME=s.NOME_AUTORE and a.COGNOME=s.COGNOME_AUTORE
	where a.CITTA='mi'
	group by s.ISBN
	having count(s.NOME_AUTORE)>=2



	select distinct p.UTENTE
	from PRESTITO p
	where p.UTENTE not in(
		select p.UTENTE
		from PRESTITO P
		where p.ISBN in(
			select s.ISBN
			from SCRIVE s
			join AUTORE a on a.NOME=s.NOME_AUTORE and a.COGNOME=s.COGNOME_AUTORE
			where a.CITTA='mi'
			group by s.ISBN
			having count(s.NOME_AUTORE)>=2
		)
	)

--esame 19 gennaio
--Corsi (tutti gli attributi) tenuti da docenti del dipartimento 'DipA' in aule dell'edificio 'EdiZ' oppure dell'edificio 'EdiW'
select distinct c.*
from CORSO c
join LEZIONE l on l.IDCORSO=c.IDCORSO
join AULA a on a.IDAULA=l.IDAULA and (a.EDIFICIO='EdiZ' or a.EDIFICIO='EdiW')
join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE and d.DIPARTIMENTO='DipA'

select distinct c.*
from CORSO c
join LEZIONE l on l.IDCORSO=c.IDCORSO
join AULA a on a.IDAULA=l.IDAULA 
join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE 
where (a.EDIFICIO='EdiZ' or a.EDIFICIO='EdiW') and d.DIPARTIMENTO='DipA'

select c.*
from CORSO c
join LEZIONE l on l.IDCORSO=c.IDCORSO
join AULA a on a.IDAULA=l.IDAULA 
join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE 
where a.EDIFICIO='EdiZ'  and d.DIPARTIMENTO='DipA'
union
select c.*
from CORSO c
join LEZIONE l on l.IDCORSO=c.IDCORSO
join AULA a on a.IDAULA=l.IDAULA 
join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE 
where a.EDIFICIO='EdiW'  and d.DIPARTIMENTO='DipA'

--Selezionare gli EDIFICI tali che in nessuna aula di tali EDIFICI ci sono state lezioni per corsi del CDL 'CDL1' tenute da docenti del
--dipartimento 'DipB'

select distinct a.EDIFICIO
from AULA a 
where a.EDIFICIO not in(
	select a1.EDIFICIO
	from AULA a1
	join LEZIONE  l on a1.IDAULA=l.IDAULA
	join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE and l.RUOLO=d.RUOLO
	join corso c on c.IDCORSO=l.IDCORSO
	where c.CDL='CDL1' and d.DIPARTIMENTO='DipB'
) 

--AULE in cui ci sono state lezioni di tutti i docenti del dipartimento 'DipA', considerando solo lezioni dei corsi del CDL='CDL1'select *
from AULA
where not exists(
	select *
	from DOCENTE
	where DOCENTE.DIPARTIMENTO='DipA'
	and not exists(
		select *
		from LEZIONE
		join CORSO on CORSO.IDCORSO=LEZIONE.IDCORSO
		where corso.CDL='CDL1'
		and LEZIONE.IDAULA=AULA.IDAULA
		and LEZIONE.IDDOCENTE=DOCENTE.IDDOCENTE 
	)
)

SELECT A.*
FROM AULA A
WHERE NOT EXISTS(
SELECT *
FROM DOCENTE D
WHERE D.DIPARTIMENTO='DipA'
AND NOT EXISTS(
SELECT *
FROM LEZIONE L
JOIN CORSO C ON (C.IDCORSO=L.IDCORSO)
WHERE L.IDAULA=A.IDAULA
AND L.IDDOCENTE=D.IDDOCENTE
AND C.CDL='CDL1'
)

--Per ogni EDIFICIO, individuare il CDL dei corsi con il maggior NUMEROORE di lezione, considerando solo i docenti del dipartimento DipB
--e del DipC

create view vistanuova as 
select  c.CDL, sum(l.NUMEROORE) as oretot, a.EDIFICIO
from CORSO c
join LEZIONE l on l.IDCORSO=c.IDCORSO
join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE and d.RUOLO=l.RUOLO
join AULA a on a.IDAULA=l.IDAULA
where d.DIPARTIMENTO='DipB' or d.DIPARTIMENTO='DipC'
group by a.EDIFICIO,c.CDL

select v.CDL,v.EDIFICIO
from vistanuova v
where v.oretot>=all(
	select oretot 
	from vistanuova v1
	where v1.EDIFICIO=v.EDIFICIO
)

select  c.CDL, a.EDIFICIO
from CORSO c
join LEZIONE l on l.IDCORSO=c.IDCORSO
join DOCENTE d on d.IDDOCENTE=l.IDDOCENTE AND d.RUOLO=l.RUOLO
join AULA a on a.IDAULA=l.IDAULA
where d.DIPARTIMENTO='DipB' or d.DIPARTIMENTO='DipC'
group by a.EDIFICIO,c.CDL
having sum(l.NUMEROORE)>=all(
	select sum(l1.NUMEROORE)
	from CORSO c1
	join LEZIONE l1 on l1.IDCORSO=c1.IDCORSO
	join DOCENTE d1 on d1.IDDOCENTE=l1.IDDOCENTE AND d1.RUOLO=l1.RUOLO
	join AULA a1 on a1.IDAULA=l1.IDAULA
	where a1.EDIFICIO=a.EDIFICIO and ( d1.DIPARTIMENTO='DipB' or d1.DIPARTIMENTO='DipC')
	group by a1.EDIFICIO,c1.CDL
)

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


ALTER TABLE AULA
	ADD CONSTRAINT FK_EDI FOREIGN KEY (EDIFICIO) REFERENCES EDIFICIO 
	ON DELETE CASCADE 
	ON UPDATE CASCADE



--9 FEBBRAIO appello1 
--seleziona le foto di un fotografo italiano o tedesco che hanno partecipato al concorso di 'TipoA'
select distinct foto.*
from fotografia foto
join fotografo f on foto.fotografo=f.fotografo 
join valutazione v on v.fotografia=foto.fotografia
join concorso c on c.concorso=v.concorso and c.anno=v.anno
where c.tipo='TipoA' and (f.nazionalita='italiano' or f.nazionalita='tedesco')

--seleziona tutti i concorsi di 'TipoA' a cui hanno partecipato tutti i fotografi di nazionalità tedesca consideranzo solo le valutazioni >5
select *
from CONCORSO c
WHERE c.tipo='TipoA'
and not exists(
	select *
	from FOTOGRAFO F
	WHERE F.NAZIONALITA='TEDESCO'
	AND NOT EXISTS(
		SELECT *
		FROM VALUTAZIONE V
		JOIN FOTOGRAFIA FOTO ON FOTO.FOTOGRAFIA=V.FOTOGRAFIA
		WHERE V.VOTO>5 
		AND V.ANNO=C.ANNO AND C.CONCORSO=V.CONCORSO
		AND FOTO.FOTOGRAFO=F.FOTOGRAFO
	)
)

--selezionare le fotografie fatte da fotografi di nazionalità italiana mai valutate in nessun concorso di 'tipoa'
select FOTO.*
from FOTOGRAFIA FOTO
JOIN FOTOGRAFO F ON F.FOTOGRAFO=FOTO.FOTOGRAFO
WHERE F.NAZIONALITA='ITALIANO' AND FOTO.FOTOGRAFIA NOT IN (
	SELECT V.FOTOGRAFIA
	FROM VALUTAZIONE V 
	JOIN CONCORSO C ON V.CONCORSO=C.CONCORSO AND V.ANNO=C.ANNO
	WHERE C.TIPO='TIPOA'
)

--selezionare per ogni tema il numero di fotografie valutate nei concorsi di tipo a e riportare in uscita solo il tema che nelle valutazioni ha raggiunto un voto medio>5
select FOTO.TEMA,COUNT(*) AS NUMERO_FOTO 
from FOTOGRAFIA FOTO
JOIN VALUTAZIONE V ON FOTO.FOTOGRAFIA=V.FOTOGRAFIA
JOIN CONCORSO C ON C.CONCORSO=V.CONCORSO AND C.ANNO=V.ANNO
WHERE C.TIPO='TIPOA'
GROUP BY FOTO.TEMA
HAVING AVG(V.VOTO)>5

--PER OGNI NAZIONALITà,IL TEMA DELLE FOTOGRAFIE DEI FOTOGRAFI DI QUELLA NAZIONALITA VALUTATE IL MAGGIOR NUMERO DI VOLTE
--CONSIDERANDO SOLO LE VALUTAZIONI CON VOTO >5 IN CONCORSI DI TIPOA

select f.nazionalita, foto.tema
from fotografo f
join fotografia foto on foto.fotografo=f.fotografo
join valutazione v on v.fotografia=foto.fotografia
join concorso c on c.concorso=v.concorso and c.anno=v.anno
where v.voto>5 and c.tipo='tipoa'
group by f.nazionalita, foto.tema
having count(*)>=all(
	select count(*)
	from fotografo f1
	join fotografia foto1 on foto1.fotografo=f1.fotografo
	join valutazione v1 on v1.fotografia=foto1.fotografia
	join concorso c1 on c1.concorso=v1.concorso and c1.anno=v1.anno
	where v1.voto>5 and c1.tipo='tipoa' and  f1.nazionalita=f.nazionalita
	group by f1.nazionalita, foto1.tema
)

alter table FOTOGRAFIA
 add constraint fk_fototema foreign key (TEMA) references TABELLA_TEMA
 ON DELETE NO ACTION
 ON UPDATE CASCADE

/*

alter table fotografia add constraint fk_tema FOREIGN KEY (TEMA) REFERENCES TABELLA_TEMA ON DELETE NO ACTION ON UPDATE CASCADE
-- Attenzione: se non la esegue è perché per la tabella 'tabella_tema' non è stata definita una Primary Key
-- Per testarla, puoi aggiungere il vincolo di primary key al campo TEMA di TABELLA_TEMA eseguendo la sottostante
-- Poi riprova ad eseguire la precedente (questa è stata una svista del prof)
alter table tabella_tema add constraint pk_tabella_tema PRIMARY KEY (tema)


*/

--9 febbraio appello 2
-- 1) Selezionare le valutazioni con voto > 5 a concorsi di 'TipoA' di fotografie di fotografi 'italiano'
select v.*
from VALUTAZIONE v
join CONCORSO c on c.CONCORSO=v.CONCORSO and c.ANNO=v.ANNO
join FOTOGRAFIA foto on foto.FOTOGRAFIA=v.FOTOGRAFIA
join FOTOGRAFO f on f.FOTOGRAFO=foto.FOTOGRAFO
where v.VOTO>5 and c.TIPO='TipoA' and f.NAZIONALITA='italiano'


--2) Selezionare i fotografi italiani che non hanno mai partecipato 
--a nessun concorso  un concorso  di 'TipoA' nell'anno 2008
select f.*
from FOTOGRAFO f
where f.NAZIONALITA='italiano' 
and f.FOTOGRAFO not in(
	select f1.FOTOGRAFO
	from FOTOGRAFO f1 
	join FOTOGRAFIA foto on foto.FOTOGRAFO=f1.FOTOGRAFO
	join VALUTAZIONE v on v.FOTOGRAFIA=foto.FOTOGRAFIA
	join CONCORSO c on c.CONCORSO=v.CONCORSO and c.ANNO=v.ANNO
	where c.TIPO='TipoA' and c.ANNO='2008'
)


--3) Selezionare i fotografi che hanno partecipato a tutti i concorsi di 'TipoA' , 
--considerando solo le valutazioni con voto > 2
select *
from FOTOGRAFO f
where not exists(
	select *
	from CONCORSO c 
	where c.TIPO='TipoA'
	and not exists(
		select*
		from valutazione v
		join FOTOGRAFIA foto on foto.FOTOGRAFIA=v.FOTOGRAFIA
		where v.VOTO>2 and v.CONCORSO=c.CONCORSO and c.anno=v.ANNO and foto.FOTOGRAFO=f.FOTOGRAFO
	)
)

--4) Selezionare per ogni FOTOGRAFO, la sua NAZIONALITA 
--ed il numero di fotografie valutate in concorsi di tipo A; 
--riportare in uscita solo i fotografi che nelle valutazioni hanno raggiunto  un voto medio maggiore di 5


select f.FOTOGRAFO,f.nazionalita ,count(*) as numerofoto
from FOTOGRAFO f
join FOTOGRAFIA foto on foto.FOTOGRAFO=f.FOTOGRAFO
join VALUTAZIONE v on v.FOTOGRAFIA=foto.FOTOGRAFIA
join CONCORSO c on c.ANNO=v.ANNO and c.CONCORSO=v.CONCORSO
where c.TIPO='TipoA'
group by f.FOTOGRAFO, f.nazionalita
having avg(v.VOTO)>5


create view votomedio as
select fr.FOTOGRAFO
from fotografo fr join fotografia f on f.FOTOGRAFO = fr.FOTOGRAFO
join valutazione v on v.FOTOGRAFIA = f.FOTOGRAFIA
group by fr.FOTOGRAFO
having avg(v.voto) > 5

select distinct fr.FOTOGRAFO, fr.NAZIONALITA, count(*) numeroConcorsi
from fotografo fr join fotografia f on fr.FOTOGRAFO = f.FOTOGRAFO
join valutazione v on v.FOTOGRAFIA = f.FOTOGRAFIA
join concorso c on c.ANNO = v.ANNO and c.CONCORSO = v.CONCORSO
where fr.FOTOGRAFO in (select * from votomedio)
group by fr.FOTOGRAFO, fr.NAZIONALITA, c.TIPO
having c.TIPO = 'TipoA'

--5) Per Ogni NAZIONALITA, 
--il TEMA delle fotografie dei fotografi di quella nazionalità valutate il maggior numero di volte, 
--considerando solo le valutazioni con voto > 5 in concorsi di 'TipoA'

select f.NAZIONALITA,foto.TEMA, count(v.FOTOGRAFIA) as numerofoto
from FOTOGRAFO f
join FOTOGRAFIA foto on foto.FOTOGRAFO=f.FOTOGRAFO
join VALUTAZIONE v on v.FOTOGRAFIA=foto.FOTOGRAFIA
join CONCORSO c on c.ANNO=v.ANNO and c.CONCORSO=v.CONCORSO
where c.TIPO='TipoA' and v.VOTO>5
group by f.NAZIONALITA, foto.TEMA
having count(v.FOTOGRAFIA)>=all(
		select count(*)
		from FOTOGRAFO f1
	join FOTOGRAFIA foto1 on foto1.FOTOGRAFO=f1.FOTOGRAFO
	join VALUTAZIONE v1 on v1.FOTOGRAFIA=foto1.FOTOGRAFIA
	join CONCORSO c1 on c1.ANNO=v1.ANNO and c1.CONCORSO=v1.CONCORSO
	where c1.TIPO='TipoA' and v1.VOTO>5 and f.NAZIONALITA=f1.NAZIONALITA
	group by f1.NAZIONALITA, foto1.TEMA
)

select distinct fr.NAZIONALITA, f.TEMA, count(f.TEMA) as numeroValutazioni
from fotografo fr join fotografia f on fr.FOTOGRAFO = f.FOTOGRAFO
join valutazione v on v.FOTOGRAFIA = f.FOTOGRAFIA
join concorso c on c.ANNO = v.ANNO and c.CONCORSO = v.CONCORSO
where c.TIPO = 'TipoA' and v.VOTO > 5
group by fr.NAZIONALITA, f.TEMA
having count(f.TEMA) >= ALL (
		select count(f1.TEMA)
		from fotografia f1 join fotografo fr1 on fr1.FOTOGRAFO = f1.FOTOGRAFO
			join valutazione v1 on v1.FOTOGRAFIA = f1.FOTOGRAFIA
			join concorso c1 on c1.ANNO = v1.ANNO and c1.CONCORSO = v1.CONCORSO
			where c1.TIPO = 'TipoA' and v1.VOTO > 5 and fr1.NAZIONALITA = fr.NAZIONALITA
			group by f1.TEMA

)

--SELECT DISTINCT TEMA INTO TABELLA_TEMA FROM FOTOGRAFIA
--Aggiungere quindi alla tabella FOTOGRAFIA la 

--FOREIGN KEY (TEMA) REFERENCES TABELLA_TEMA

--in modo tale che  

--DELETE FROM TABELLA_TEMA   
-- NON DEVE ESSERE CONSENTITA
--UPDATE TABELLA_TEMA SET tema = '_' + tema
-- MODIFICHI il tema  NELLE RELATIVE fotografie

alter table tabella_tema add constraint pk_tabella_tema PRIMARY KEY (tema)

alter table FOTOGRAFIA
add constraint fk_temafoto foreign key (TEMA) references TABELLA_TEMA
on delete no action 
on update cascade
