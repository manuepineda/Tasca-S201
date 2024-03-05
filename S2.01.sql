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
	SELECT company.id 
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


     
