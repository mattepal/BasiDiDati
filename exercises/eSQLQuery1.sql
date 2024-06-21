--Selezionare i clienti (tutti gli attributi) della nazione 'NazioneC' che hanno prenotato oppure effettuato almeno un viaggio
--con destinazione 'Destinazione2'
select distinct c.*
from CLIENTE c
join PRENOTA p on p.IDCLIENTE=c.IDCLIENTE
join VIAGGIO v on v.IDVIAGGIO=p.IDCLIENTE and v.ANNO=p.ANNO
where c.NAZIONE='NazioneC' and  v.DESTINAZIONE='Destinazione2'
union 
select distinct c1.*
from CLIENTE c1
join EFFETTUA e on e.IDCLIENTE=c1.IDCLIENTE
join VIAGGIO v1 on v1.IDVIAGGIO=e.IDVIAGGIO and v1.ANNO=e.ANNO
where c1.NAZIONE='NazioneC' and  v1.DESTINAZIONE='Destinazione2'

--Selezionare le nazioni tali che nessun cliente di tali nazioni ha mai prenotato un viaggio con destinazione  'Destinazione2'
select CLIENTE.NAZIONE
from CLIENTE
where CLIENTE.NAZIONE not in(
	select c.NAZIONE
	from CLIENTE c
	join PRENOTA p on p.IDCLIENTE=c.IDCLIENTE
	join VIAGGIO v on v.ANNO=p.ANNO and p.IDVIAGGIO=v.IDVIAGGIO
	where v.DESTINAZIONE='Destinazione2'
)

--Selezionare i clienti della 'NazioneB' o della 'NazioneC' che hanno effettuato tutti i viaggi
--con destinazione 'Destinazione2'
select *
from CLIENTE c
where c.NAZIONE='NazioneB' or c.NAZIONE='NazioneC'
and not exists(
	select *
	from VIAGGIO v
	where v.DESTINAZIONE='Destinazione2'
	and not exists(
		select * 
		from EFFETTUA e 
		where e.IDCLIENTE=c.IDCLIENTE
		and e.IDCLIENTE=v.IDVIAGGIO and e.ANNO=v.ANNO
	)
)
--Selezionare per ogni DESTINAZIONE il numero di prenotazioni  effettuati dai clienti della  'NazioneB'
--e riportare in uscita solo le destinazioni che hanno una somma totale del  numero posti prenotati >=2
select v.DESTINAZIONE, COUNT(*) as numprenotazioni, sum(p.NUMEROPOSTI) as postipren
from CLIENTE c 
join PRENOTA p on p.IDCLIENTE=c.IDCLIENTE
join VIAGGIO v on v.ANNO=p.ANNO and v.IDVIAGGIO=p.IDVIAGGIO
where c.NAZIONE='NazioneB'
group by v.DESTINAZIONE
having sum(p.NUMEROPOSTI)>=2


--Creare una vista V2 che selezioni per ogni ANNO, il CLIENTE che ha fatto il maggior numero di viaggi di quell'anno.
--Quindi - considerando solo i clienti individuati in V2 -  selezionare quei clienti  che hanno effettuato tutti i viaggi che hanno prenotato.

create view v2 as(
	select v.ANNO,c.IDCLIENTE, count(v.IDVIAGGIO) as numeroviaggi
	from CLIENTE c 
	join EFFETTUA e on e .IDCLIENTE=c.IDCLIENTE
	join VIAGGIO v on v.IDVIAGGIO=e.IDVIAGGIO and v.ANNO=e.ANNO
	group by v.ANNO,c.IDCLIENTE
	having count(v.IDVIAGGIO)>=all(
		select count(v1.IDVIAGGIO)
		from CLIENTE c1 
		join EFFETTUA e1 on e1 .IDCLIENTE=c1.IDCLIENTE
		join VIAGGIO v1 on v1.IDVIAGGIO=e1.IDVIAGGIO and v1.ANNO=e1.ANNO
		where v.ANNO=v1.ANNO
		group by v1.ANNO,c1.IDCLIENTE
	)
)
select *
from v2 c
where not exists(
	select *
	from VIAGGIO v
	join PRENOTA p on p.IDVIAGGIO=v.IDVIAGGIO and p.ANNO=v.ANNO
	where not exists(
		select *
		from EFFETTUA e
		where e.ANNO=v.ANNO and e.IDVIAGGIO=v.IDVIAGGIO
		and c.IDCLIENTE=e.IDCLIENTE
	)
)

select v2.IDCLIENTE 
from v2
where v2.IDCLIENTE in(
select *
from CLIENTE c
where not exists (
	select *
	from VIAGGIO v 
	join PRENOTA p on p.ANNO=v.ANNO and p.IDVIAGGIO=v.IDVIAGGIO
	where not exists(
		select *
		from EFFETTUA e 
		where e.ANNO=p.ANNO and e.IDVIAGGIO=p.IDVIAGGIO and e.IDCLIENTE=c.IDCLIENTE
	)
)
)
select *
from CLIENTE c
where not exists (
	select *
	from VIAGGIO v 
	join PRENOTA p on p.ANNO=v.ANNO and p.IDVIAGGIO=v.IDVIAGGIO
	where not exists(
		select *
		from EFFETTUA e 
		where e.ANNO=p.ANNO and e.IDVIAGGIO=p.IDVIAGGIO and e.IDCLIENTE=c.IDCLIENTE
	)
)




CREATE TABLE VIAGGI_PRENOTATI_ED_EFFETTUATI (
    IDVIAGGIO INT ,
    ANNO INT,
    IDCLIENTE INT,
    FOREIGN KEY (IDVIAGGIO) REFERENCES PRENOTA(IDVIAGGIO),
    FOREIGN KEY (IDCLIENTE) REFERENCES EFFETTUA(IDCLIENTE)
);
--INSERT INTO VIAGGI_PRENOTATI_ED_EFFETTUATI (IDVIAGGIO, ANNO, IDCLIENTE) VALUES (1, 2022, 1);
--INSERT INTO VIAGGI_PRENOTATI_ED_EFFETTUATI (IDVIAGGIO, ANNO, IDCLIENTE) VALUES (2, 2023, 2);
