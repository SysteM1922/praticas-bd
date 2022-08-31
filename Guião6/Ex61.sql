-- 6.1)
-- a)

SELECT * FROM authors;

-- b)

SELECT au_fname, au_lname, phone from authors;

-- c)

SELECT au_fname,au_lname,phone
FROM authors
order by  au_fname, au_lname;

-- d)

select au_fname as first_name, au_lname as last_name, phone as tel_number
from authors
order by au_fname, au_lname;

-- e)

select au_fname as first_name, au_lname as last_name, phone as tel_number
from authors
where au_fname = 'CA' and au_lname != 'Ringer'
order by au_fname, au_lname;


-- f)
SELECT * FROM publishers
WHERE pub_name LIKE '%Bo%'

-- g)

SELECT DISTINCT pub_id FROM titles
WHERE type='business'

-- h)

SELECT pub_name, sum(qty) as total_sales
from ((publishers join titles on publishers.pub_id = titles.pub_id) join sales on titles.title_id=sales.title_id)
group by pub_name;

-- i)

SELECT pub_name, title, sum(qty) AS sales
FROM publishers, titles,sales
WHERE publishers.pub_id = titles.pub_id AND titles.title_id=sales.title_id
GROUP BY pub_name, title;

-- j)

SELECT DISTINCT title
from ((stores join sales
        on stores.stor_id=sales.stor_id)
    JOIN  titles on sales.title_id=titles.title_id
    )
where stor_name = 'Bookbeat';

-- k)

select au_fname, au_lname
from ((titles join titleauthor on titles.title_id=titleauthor.title_id) join authors on titleauthor.au_id=authors.au_id)
group by au_fname, au_lname
having count(distinct [type]) > 1;

-- l)

SELECT titles.pub_id AS editoraID, titles.type, COUNT(sales.qty) AS vendas, AVG(titles.price) AS precoMedio
	FROM (
		titles JOIN sales
			ON titles.title_id=sales.title_id
	)
	GROUP BY titles.pub_id, titles.type


-- m)

SELECT type, max(advance) AS maxAdvance, avg(advance) AS avgAdvance
FROM titles
GROUP BY type
HAVING max(advance) > 1.5*avg(advance);


-- n)

SELECT titles.title, authors.au_fname, authors.au_lname, SUM(sales.qty*titles.price) AS valorDeVendas
	FROM (
		((titles JOIN sales
			ON titles.title_id=sales.title_id) JOIN titleauthor
				ON titles.title_id=titleauthor.title_id) JOIN authors
					ON titleauthor.au_id=authors.au_id
	)
	GROUP BY titles.title, authors.au_fname, authors.au_lname


-- o)

SELECT title, ytd_sales,price*ytd_sales AS vendas, price*ytd_sales*royalty/100 AS author_money, price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_money
FROM titles;

-- p)

SELECT title, CONCAT(authors.au_fname, ' ', authors.au_lname) as author_fullname, ytd_sales,price*ytd_sales AS money_made, price*ytd_sales*royalty/100 AS author_money, price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_money
	FROM (
		(titles JOIN titleauthor
			ON titles.title_id=titleauthor.title_id) JOIN authors
				ON titleauthor.au_id=authors.au_id
	)


-- q)

SELECT stor_name, count(title) AS numTitles
FROM ((stores JOIN sales ON stores.stor_id=sales.stor_id) JOIN titles ON sales.title_id=titles.title_id)
GROUP BY stor_name
HAVING count(title)=(SELECT count(title_id) FROM titles);

-- r)

SELECT stor_name
FROM ((stores JOIN sales ON stores.stor_id=sales.stor_id) JOIN titles ON sales.title_id=titles.title_id)
GROUP BY stor_name
HAVING (SUM(sales.qty)/COUNT(title)) > (
	SELECT SUM(qty)/COUNT(stor_id) FROM sales
)

-- s)

SELECT DISTINCT title FROM titles
EXCEPT
(SELECT DISTINCT title
FROM titles,sales,stores
WHERE stor_name='Bookbeat' AND titles.title_id=sales.title_id AND sales.stor_id=stores.stor_id);


-- t)

SELECT publishers.pub_name, stores.stor_name
	FROM (
		((stores LEFT JOIN sales
			ON stores.stor_id=sales.stor_id) LEFT JOIN titles
				ON sales.title_id=titles.title_id) LEFT JOIN publishers
					ON titles.pub_id=publishers.pub_id
	)
	GROUP BY publishers.pub_name, stores.stor_name
	HAVING COUNT(sales.qty)=0