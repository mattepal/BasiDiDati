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