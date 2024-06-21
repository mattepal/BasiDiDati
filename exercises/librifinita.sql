--alter table prestito
--	add constraint fk_prestito foreign key(ISBN) references libri
--	on delete no action 
--	on update cascade 

--Selezionare gli utenti (tutti gli attributi) che hanno preso in prestito almeno un libro scritto da almeno un autore di Roma (RM)
--select p.UTENTE
--from PRESTITO p
--join scrive s on s.ISBN=p.ISBN
--join AUTORE a on s.NOME_AUTORE=a.NOME and s.COGNOME_AUTORE=a.COGNOME
--where a.CITTA='RM'

--Selezionare gli utenti (tutti gli attributi) che hanno preso in prestito almeno un libro scritto da almeno due autori di Milano (MI)
select p.UTENTE
from PRESTITO p
where p.ISBN in(
	select s.ISBN
	from SCRIVE s
	join AUTORE a on a.NOME=s.NOME_AUTORE and a.COGNOME=s.COGNOME_AUTORE
	where a.CITTA='mi'
	group by s.ISBN
	having count(*)>=2
)

--create view milanoo as 
--	select s.ISBN
--	from SCRIVE s
--	join AUTORE a on a.NOME=s.NOME_AUTORE and a.COGNOME=s.COGNOME_AUTORE
--	where a.CITTA='mi'
--	group by s.ISBN
--	having count(s.NOME_AUTORE)>=2


	select distinct p.UTENTE
	from PRESTITO p
	where p.utente not in(
	select p1.UTENTE
	from prestito p1
	where p1.ISBN in(
	select s.ISBN
		from SCRIVE s
		join AUTORE a on a.NOME=s.NOME_AUTORE and a.COGNOME=s.COGNOME_AUTORE
		where a.CITTA='mi'
		group by s.ISBN
		having count(*)>=2
		)
	)

	select * from PRESTITO join SCRIVE on PRESTITO.ISBN=scrive.ISBN join AUTORE on AUTORE.NOME=scrive.NOME_AUTORE and SCRIVE.COGNOME_AUTORE=AUTORe.COGNOME