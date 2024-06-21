select distinct SOC_COMPETENZA
from TRATTA
where COD_T not in(
	select v.TRATTA
	from VIAGGIO v
	join AUTOMOBILISTA a on v.AUTOMOBILISTA=a.COD_F
	where a.SESSO='m'
)

select SOC_COMPETENZA
from TRATTA t
where not exists
	(select *	
	from AUTOMOBILISTA a
	where sesso='m'
	and not exists(
		select *
		from VIAGGIO v
		where v.AUTOMOBILISTA=a.COD_F
		and v.TRATTA=t.COD_T
		))


select *
from SOCIETA
where COD_S not in(
	select SOC_COMPETENZA
	from TRATTA t
	join VIAGGIO v on v.TRATTA= t.COD_T
	join AUTOMOBILISTA a on v.AUTOMOBILISTA=a.COD_F
	where a.SESSO='m'
)