--select v1.Cliente as cliente1,v2.Cliente as cliente2
--from Vendita v1
--join Negozio n1 on v1.Negozio=n1.Negozio
--join Negozio n2 on n2.Citta=n1.Citta
--join vendita v2 on v2.Negozio=n2.Negozio
--where v1.Cliente<v2.Cliente and v1.Prodotto=v2.Prodotto

--Selezionare le Coppie di Clienti , Cliente1 e Cliente2, che hanno acquistato almeno una volta  in negozi della stessa Citta   (quindi non interessano i prodotti acquistati e i Negozi dove è stato effettuato l'acquisto, ma solo il fatto che tali negozi siano nella stessa Città)

--select distinct v1.Cliente as cliente1,v2.Cliente as cliente2
--from vendita v1
--join negozio n1 on n1.Negozio=v1.Negozio
--join Negozio n2 on n2.Citta=n1.Citta
--join vendita v2 on v2.Negozio=n2.Negozio
--where v1.Cliente<v2.Cliente

--Selezionare le Coppie di Clienti , Cliente1 e Cliente2, che hanno acquistato almeno una volta  nello stesso Negozio  (quindi non interessano i prodotti acquistati, ma solo il fatto che l'acquisto sia stato fatto dai due clienti nello stesso  negozio)

--select distinct v1.Cliente,v2.Cliente
--from vendita v1
--join Negozio n1 on v1.Negozio=n1.Negozio
--join Negozio n2 on n1.Negozio=n2.Negozio
--join vendita v2 on v2.Negozio=n2.Negozio
--where v1.Cliente<v2.Cliente

--select distinct v1.Cliente,v2.Cliente
--from vendita v1
--join vendita v2 on v2.Negozio=v1.Negozio
--where v1.Cliente<v2.Cliente

--Selezionare le Coppie di Clienti che hanno acquistato - almeno una volta -  lo stesso Prodotto  nello stesso Negozio
select *
from vendita v1
join vendita v2 on v1.Prodotto=v2.Prodotto and v1.Negozio=v2.Negozio
where v1.Cliente<v2.Cliente

select distinct v1.Cliente,v2.Cliente
from vendita v1
join Negozio n1 on v1.Negozio=n1.Negozio
join Negozio n2 on n1.Negozio=n2.Negozio
join vendita v2 on v2.Negozio=n2.Negozio
where v1.Cliente<v2.Cliente and v1.Prodotto=v2.Prodotto

--Selezionare le Coppie di Negozi , Negozio1 e Negozio2, che  hanno venduto, almeno una volta, allo stesso Cliente   (quindi  uno stesso cliente ha acquistato almeno una volta  sia in Negozio1 e almeno una volta in Negozio2)  
select distinct n1.Negozio as negozio1,n2.Negozio as negozio2
from Negozio n1
join Vendita v1 on n1.Negozio=v1.Negozio
join Vendita v2 on v2.Cliente=v1.Cliente
join negozio n2 on n2.Negozio=v2.Negozio
where n1.Negozio<n2.Negozio
--Selezionare le Coppie di Negozi , Negozio1 e Negozio2,
--che sono  nella Stessa Citta e hanno venduto almeno un prodotto allo Stesso Cliente 
--(quindi non è necessario che sia lo stesso Prodotto, ma solo che uno stesso cliente abbia acquistato almeno una volta sia in Negozio1 e almeno una volta in Negozio2, e che tali negozi siano della stessa città) 

select distinct n1.Negozio as negozio1,n2.Negozio as negozio2
from Negozio n1
join Vendita v1 on n1.Negozio=v1.Negozio
join Vendita v2 on v2.Cliente=v1.Cliente
join negozio n2 on n2.Negozio=v2.Negozio
where n1.Negozio<n2.Negozio and n1.Citta=n2.Citta

select distinct n1.Negozio as negozio1,n2.Negozio as negozio2
from Negozio n1
join Vendita v1 on n1.Negozio=v1.Negozio
join Vendita v2 on v2.Cliente=v1.Cliente and v2.Prodotto=v1.Prodotto
join negozio n2 on n2.Negozio=v2.Negozio
where n1.Negozio<n2.Negozio 

select distinct n1.Negozio as negozio1,n2.Negozio as negozio2
from Negozio n1
join Vendita v1 on n1.Negozio=v1.Negozio
join Vendita v2 on v2.Cliente=v1.Cliente and v2.Prodotto=v1.Prodotto
join negozio n2 on n2.Negozio=v2.Negozio
where n1.Negozio<n2.Negozio and n1.Citta=n2.Citta