DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(100),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
	Orders_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

-- COPY Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
-- FROM '‪C:/Users/Omkar/Downloads/Books.csv'
-- CSV HEADER;

-- COPY Customers(Customer_ID,Name,Email,Phone,City,Country)
-- FROM 'C:\Users\Omkar\OneDrive\Desktop\Omkar\SQL\Customers.csv'
-- CSV HEADER;

-- COPY Orders(Orders_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
-- FROM 'C:\Users\Omkar\OneDrive\Desktop\Omkar\SQL\Orders.csv'
-- CSV HEADER;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

------------------------------------------------- BASIC QUESTIONS ----------------------------------------------

-- 1) Retrieve all books in the fiction genre.

SELECT * FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950.

SELECT Title, Author, Published_Year FROM Books
WHERE Published_Year > 1950;

-- 3) List all customers from the Canada.

SELECT Name, Country FROM Customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023.

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available.

 SELECT SUM(Stock) as total_book_stock_available FROM Books;

-- 6) Find the details of the most expensive book.

 SELECT * FROM Books 
 ORDER BY Price DESC 
 LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book.

SELECT * FROM Orders
WHERE Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20.

SELECT * FROM Orders
WHERE total_amount > 20;

-- 9) List all genre available in the books table.

SELECT DISTINCT Genre FROM Books;

-- 10) Find the book with lowest stock.

SELECT * FROM Books 
ORDER BY Stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders.
SELECT SUM(total_amount) as total_revenue FROM Orders; 

------------------------------------------------- ADVANCED QUESTIONS ----------------------------------------------
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve the total number of books sold for each genre.

SELECT b.Genre, SUM(o.Quantity) AS Total_books_sold
FROM Orders o
JOIN Books b 
ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Find the avg price of books in the fantasy genre.

SELECT AVG(Price) AS avg_price_of_fantasy FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders.

SELECT o.customer_id, c.Name, COUNT(o.orders_id) AS Order_count 
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.Name
HAVING COUNT(o.orders_id) >= 2;

-- 4) Find the most frequently ordered book.

SELECT o.Book_id, b.Title, COUNT(o.Orders_id) AS Order_count
FROM Orders o 
JOIN Books b ON o.Book_id = b.Book_id
GROUP BY o.Book_id, b.Title
ORDER BY Order_count DESC LIMIT 1;

-- 5) Show the most top 3 expensive books of fantasy genre.

SELECT * FROM Books
WHERE genre='Fantasy' 
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author.

SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author;

-- 7) List the cities where customers who spent over $30 are located.

SELECT DISTINCT c.city,c.name, o.total_amount
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
GROUP BY c.city,c.name,o.total_amount
HAVING o.total_amount > 30;

-- 8) Find the customer who spend the most on orders.

SELECT c.customer_id,c.name, SUM(o.total_amount) AS total_spend
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spend DESC LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders.

SELECT b.book_id, b.title, b.stock, COALESCE (SUM(o.quantity),0) AS order_quantity,
b.stock - COALESCE (SUM(o.quantity),0) AS remaining_quantity
FROM Books b
lEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;













