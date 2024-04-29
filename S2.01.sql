#nivel 1

SELECT *
FROM company;

SELECT *
FROM transaction;

#Ej 1

SELECT transaction.id
FROM transaction
WHERE transaction.company_id IN 
    (SELECT company.id
     FROM company
     WHERE company.country = 'Germany');

#EJ 2

SELECT company_name
FROM company
WHERE company.id IN (
	SELECT company_id #aqui era company_id en vez de company.id
	from transaction
	WHERE amount > (
		SELECT avg(amount)
		FROM transaction
	)
);

#EJ3 

SELECT (SELECT company_name FROM company WHERE id = transaction.company_id) AS company_name,
    id,
    amount
FROM 
    transaction
WHERE 
    company_id IN (
        SELECT id
        FROM company
        WHERE company_name LIKE 'c%'
    );

#EJ4 

SELECT company_name
FROM company
WHERE id not in ( Select distinct company_id FROM transaction);
#theres no company without transactions

#nivel 2

#EJ1 

Select *
from transaction
WHERE company_id IN ( #el where in es equivalente a usar un join
	select id
	FROM company
	where country = (
		Select country
		from company
		where company_name = "Non Institute")
);


Select *
from transaction
join company ON company.id = transaction.company_id
	where country = (
		Select country
		from company
		where company_name = "Non Institute");



#EJ 2

Select company_name, amount
From company
join transaction ON company.id = transaction.company_id
where amount = (
	select MAX(amount)
    from transaction
    );
    
#version sin join Nivel 2 EJ 2

    SELECT 
    company_name,
    (SELECT MAX(amount)
	FROM transaction
    ) AS amount
FROM company
WHERE id = (
        SELECT company_id
        FROM transaction
        WHERE amount = (
                SELECT MAX(amount)
                FROM transaction)
    );
    
#Nivel 3

#ej 1

Select country, AVG(amount) as media
from transaction 
JOIN company ON company.id = transaction.company_id
group by country
having media > (
Select AVG(amount) AS media #el having se usa solo con funciones de agregacion
from transaction);

#version sin JOIN Nivel 3 ej 1

Select country, AVG(amount) as media
from (SELECT company.country, transaction.amount
    FROM transaction, company
    WHERE transaction.company_id = company.id AND transaction.declined != 1
) AS country_transactions
GROUP BY country
HAVING AVG(amount) > (
    SELECT AVG(amount) AS general_average
    FROM transaction
    WHERE declined != 1
);

#ej 2

SELECT company_name , transactions_amount ,
	IF (transactions_amount > 4, "T", "F") as more_than_4_transactions
from (SELECT company_name , count(transaction.id) as transactions_amount 
		FROM transaction
		JOIN company ON company.id = transaction.company_id
		group by company_name
		order by transactions_amount DESC
        ) as tab_for_amounts;
        
#version sin join nivel 3 ej 2

SELECT c.company_name,
    (SELECT 
    CASE WHEN COUNT(*) > 4 THEN 'F' ELSE 'T'END
        FROM transaction t 
        WHERE t.company_id = c.id
    ) AS more_than_4_transactions,
    (SELECT COUNT(*)
        FROM transaction t 
        WHERE t.company_id = c.id
    ) AS transactions_amount
FROM company c
ORDER BY transactions_amount DESC;


