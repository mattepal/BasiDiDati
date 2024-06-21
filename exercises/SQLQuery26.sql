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

select f.NAZIONALITA,foto.TEMA, count(v.VOTO) as numerofoto
from FOTOGRAFO f
join FOTOGRAFIA foto on foto.FOTOGRAFO=f.FOTOGRAFO
join VALUTAZIONE v on v.FOTOGRAFIA=foto.FOTOGRAFIA
join CONCORSO c on c.ANNO=v.ANNO and c.CONCORSO=v.CONCORSO
where c.TIPO='TipoA' and v.VOTO>5
group by f.NAZIONALITA, foto.TEMA
having count(v.VOTO)>=all(
		select count(v1.VOTO)
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
