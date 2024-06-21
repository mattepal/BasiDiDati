
--Selezionare gli appelli (tutti gli attributi) di un insegnamento del 'Secondo' anno di corso sostenuto da almeno uno studente    con nazione 'China'

--select *
--from APPELLO a
--join INSEGNAMENTO i on i.NOME_INSEGNAMENTO=a.NOME_INSEGNAMENTO and i.ANNO_CORSO=a.ANNO_CORSO
--join SOSTIENE s on s.ID_APPELLO=a.ID_APPELLO
--join STUDENTE std on std.MATRICOLA=s.MATRICOLA
--where i.ANNO_CORSO='Secondo' and std.NAZIONESTUDENTE='China'

create view SostieneDaSolo as
	select a.ID_APPELLO,std.MATRICOLA
	from APPELLO a
	join SOSTIENE s on s.ID_APPELLO=a.ID_APPELLO
	join STUDENTE std on std.MATRICOLA=s.MATRICOLA
	where a.ID_APPELLO not in(
		select a1.ID_APPELLO
		from APPELLO a1
		join SOSTIENE s1 on s1.ID_APPELLO=a1.ID_APPELLO
		join STUDENTE std1 on std1.MATRICOLA=s1.MATRICOLA 
		group by a1.ID_APPELLO
		having count(distinct std1.MATRICOLA)>1
		)

		select std.*
		from STUDENTE std
		where not exists(
			select *
			from APPELLO a
			where a.ANNO_CORSO='2'
			and not exists(
				select *
				from SostieneDaSolo ss
				where ss.ID_APPELLO=a.ANNO_CORSO
				and ss.MATRICOLA=std.MATRICOLA
			)
		)

--		Selezionare  per ogni MATRICOLA  il DOCENTE con il quale MATRICOLA ha sostenuto  il maggior numero di appelli,
--considerando solo gli insegnamenti del Terzo anno
select std.MATRICOLA,i.DOCENTE, count(s.ID_APPELLO) as num_app
from STUDENTE std
join SOSTIENE s on s.MATRICOLA=std.MATRICOLA
join APPELLO a on s.ID_APPELLO=a.ID_APPELLO
join INSEGNAMENTO i on i.ANNO_CORSO=a.ANNO_CORSO and i.NOME_INSEGNAMENTO=a.NOME_INSEGNAMENTO
where i.ANNO_CORSO='terzo'
group by std.MATRICOLA,i.DOCENTE
having count(s.ID_APPELLO)>=all(
	select count(s1.ID_APPELLO)
	from STUDENTE std1
	join SOSTIENE s1 on s1.MATRICOLA=std1.MATRICOLA
	join APPELLO a1 on s1.ID_APPELLO=a1.ID_APPELLO
	join INSEGNAMENTO i1 on i1.ANNO_CORSO=a1.ANNO_CORSO and i1.NOME_INSEGNAMENTO=a1.NOME_INSEGNAMENTO
	where std.MATRICOLA=std1.MATRICOLA and i1.ANNO_CORSO='terzo'
	group by std1.MATRICOLA,i1.DOCENTE
)


--Selezionare i DOCENTI  degli appelli della SESSIONE  'Invernale2010' in cui non c'era nessuno studente della nazione 'USA'

select distinct i.DOCENTE
from INSEGNAMENTO i
join APPELLO a on a.ANNO_CORSO=i.ANNO_CORSO and i.NOME_INSEGNAMENTO=a.NOME_INSEGNAMENTO
join SOSTIENE s on s.ID_APPELLO=a.ID_APPELLO
join STUDENTE std on std.MATRICOLA=s.MATRICOLA
where std.MATRICOLA not in (
	select MATRICOLA
	from STUDENTE
	where NAZIONESTUDENTE='USA'
) and a.SESSIONE='Invernale2010'


select   a.MATRICOLA, DOCENTE, COUNT(*)
from STUDENTE A join SOSTIENE S on S.MATRICOLA=a.MATRICOLA
join APPELLO Art on Art.ID_APPELLO=S.ID_APPELLO
join INSEGNAMENTO Conf on (Conf.NOME_INSEGNAMENTO=Art.NOME_INSEGNAMENTO and
                            Conf.ANNO_CORSO = Art.ANNO_CORSO)
WHERE Art.ANNO_CORSO='Terzo'
group by a.MATRICOLA, DOCENTE
HAVING COUNT(*) >= all (SELECT COUNT(*)
    from STUDENTE B join SOSTIENE S on S.MATRICOLA=B.MATRICOLA
    join APPELLO Art on Art.ID_APPELLO=S.ID_APPELLO
    join INSEGNAMENTO Conf on (Conf.NOME_INSEGNAMENTO=Art.NOME_INSEGNAMENTO and
                            Conf.ANNO_CORSO = Art.ANNO_CORSO)
    where a.MATRICOLA= b.matricola AND Art.ANNO_CORSO='Terzo'
    group by  DOCENTE
)

CREATE  view dividendo
as
select S.MATRICOLA,C.NOME_INSEGNAMENTO,CDL_INSEGNAMENTO
from SostieneDaSolo S
        join APPELLO A on (A.ID_APPELLO=S.ID_APPELLO)
        join INSEGNAMENTO C on (C.NOME_INSEGNAMENTO=A.NOME_INSEGNAMENTO and C.CDL=A.CDL_INSEGNAMENTO)


select S.MATRICOLA,C.NOME_INSEGNAMENTO,C.ANNO_CORSO
from SostieneDaSolo S
        join APPELLO A on (A.ID_APPELLO=S.ID_APPELLO)
        join INSEGNAMENTO C on (C.NOME_INSEGNAMENTO=A.NOME_INSEGNAMENTO and C.ANNO_CORSO=A.ANNO_CORSO)

select Distinct STUDENTE.*
from   SostieneDaSolo
        join STUDENTE on (STUDENTE.MATRICOLA=SostieneDaSolo.MATRICOLA)
where not exists (select *
                    from INSEGNAMENTO
                    where ANNO_CORSO='Secondo'
                    and not exists (select * from dividendo
                                    where dividendo.MATRICOLA=SostieneDaSolo.MATRICOLA
                                    and INSEGNAMENTO.NOME_INSEGNAMENTO=dividendo.NOME_INSEGNAMENTO
                                    and INSEGNAMENTO.ANNO_CORSO=dividendo.ANNO_CORSO
                                    )
                    )