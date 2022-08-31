--a)
SELECT * FROM authors

--b)
SELECT au_fname, au_lname ,phone FROM authors

--c)
SELECT au_fname, au_lname ,phone FROM authors
ORDER BY au_fname ASC, au_lname ASC

--d)
SELECT au_fname AS first_name, au_lname AS last_name,phone AS telephone FROM authors
ORDER BY au_fname ASC, au_lname ASC

--e)
SELECT au_fname AS first_name, au_lname AS last_name,phone AS telephone FROM authors
WHERE state ='CA' and au_lname !='Ringer'
ORDER BY au_fname ASC, au_lname ASC

--f)
SELECT * FROM publishers
WHERE pub_name LIKE '%Bo%'

--g)
SELECT DISTINCT pub_name FROM (titles JOIN publishers ON titles.pub_id=publishers.pub_id)
WHERE type='Business'

--h)
SELECT pub_name, SUM(qty) AS total_sales FROM ((sales JOIN titles ON sales.title_id = titles.title_id) JOIN publishers ON publishers.pub_id=titles.pub_id)
GROUP BY pub_name

--i)
SELECT pub_name, title, SUM(qty) AS total_sales FROM ((sales JOIN titles ON sales.title_id = titles.title_id) JOIN publishers ON publishers.pub_id=titles.pub_id)
GROUP BY pub_name, title

--j)
SELECT DISTINCT title FROM (sales JOIN stores ON sales.stor_id=stores.stor_id), titles
WHERE stor_name='Bookbeat' and titles.title_id=sales.title_id

--k)
SELECT au_fname, au_lname FROM ((authors JOIN titleauthor ON authors.au_id=titleauthor.au_id) JOIN titles ON titles.title_id = titleauthor.title_id)
GROUP BY au_fname, au_lname
HAVING COUNT(titles.type)>1

--l)
SELECT pub_name, type, AVG(price) AS avg_price, SUM(qty) AS total_sales FROM (sales JOIN titles ON titles.title_id=sales.title_id) JOIN publishers ON titles.pub_id=publishers.pub_id
GROUP BY publishers.pub_id, pub_name, type

--m)
SELECT type FROM titles
GROUP BY type
HAVING MAX(advance) > 1.5*AVG(advance)

--n)
SELECT title, au_fname, au_lname, SUM(qty*price) AS profit FROM (((titles JOIN titleauthor ON titles.title_id = titleauthor.title_id) JOIN authors ON titleauthor.au_id = authors.au_id) JOIN sales ON sales.title_id=titles.title_id)
GROUP BY title, au_fname, au_lnamev

--o)
SELECT title, ytd_sales, price*ytd_sales AS faturacao, price*ytd_sales*royalty/100 AS auths_revenue, price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_revenue
FROM titles
ORDER BY title

--p)
SELECT title, ytd_sales, CONCAT(au_fname, ' ', au_lname) AS author, price*ytd_sales*royalty/100 AS auths_revenue, price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_revenue
FROM ((titles JOIN titleauthor ON titles.title_id = titleauthor.title_id) JOIN authors ON titleauthor.au_id=authors.au_id)
ORDER BY title

--q)
SELECT stor_name FROM ((stores JOIN sales ON stores.stor_id=sales.stor_id) JOIN titles ON sales.title_id=titles.title_id)
GROUP BY stor_name
HAVING COUNT(DISTINCT sales.title_id) = (SELECT COUNT(title_id) FROM titles) 

--r)
SELECT stores.stor_name as va FROM ((stores JOIN sales ON stores.stor_id=sales.stor_id) JOIN titles ON sales.title_id=titles.title_id)
GROUP BY stor_name
HAVING SUM(sales.qty) > (SELECT SUM(qty)/COUNT(DISTINCT stor_id) FROM sales)

--s)
SELECT DISTINCT title FROM titles
EXCEPT(SELECT title FROM ((titles JOIN sales ON sales.title_id=titles.title_id) JOIN stores ON sales.stor_id=stores.stor_id) WHERE stores.stor_name='Bookbeat')

--t)
SELECT pub_name, stor_name FROM publishers, stores 
EXCEPT(SELECT pub_name, stor_name FROM (((publishers JOIN titles ON publishers.pub_id=titles.pub_id) JOIN sales ON titles.title_id = sales.title_id) JOIN stores ON sales.stor_id=stores.stor_id))
