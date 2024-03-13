/*
@Daniel Paino

This is an sql file to put your queries for SQL coursework. 
You can write your comment in sqlite with -- or /* * /

To read the sql and execute it in the sqlite, simply
type .read sqlcwk.sql on the terminal after sqlite3 musicstore.db.
*/

/* =====================================================
   WARNNIG: DO NOT REMOVE THE DROP VIEW
   Dropping existing views if exists
   =====================================================
*/
DROP VIEW IF EXISTS vNoCustomerEmployee; 
DROP VIEW IF EXISTS v10MostSoldMusicGenres; 
DROP VIEW IF EXISTS vTopAlbumEachGenre; 
DROP VIEW IF EXISTS v20TopSellingArtists; 
DROP VIEW IF EXISTS vTopCustomerEachGenre; 

/*
============================================================================
Task 1: Complete the query for vNoCustomerEmployee.
DO NOT REMOVE THE STATEMENT "CREATE VIEW vNoCustomerEmployee AS"
============================================================================
*/
CREATE VIEW vNoCustomerEmployee AS
SELECT EmployeeId, FirstName, LastName, Title
FROM Employees
WHERE EmployeeId NOT IN (
    SELECT DISTINCT EmployeeId
    FROM Invoices
    WHERE EmployeeId IS NOT NULL
);

SELECT EmployeeId, FirstName, LastName, Title FROM vNoCustomerEmployee;

/*
============================================================================
Task 2: Complete the query for v10MostSoldMusicGenres
DO NOT REMOVE THE STATEMENT "CREATE VIEW v10MostSoldMusicGenres AS"
============================================================================
*/
 CREATE VIEW v10MostSoldMusicGenres AS
 SELECT Invoice_Items.InvoiceID, Invoice_Items.TrackID, Genres.Name AS Genre, Tracks.GenreID 
FROM Invoice_Items
LEFT OUTER JOIN Tracks
ON Tracks.TrackID = Invoice_Items.TrackID
LEFT OUTER JOIN Genres
ON Genres.GenreID = Tracks.GenreID;

SELECT Genre, COUNT(*) As Sales FROM v10MostSoldMusicGenres
GROUP BY Genre
ORDER BY Sales DESC
LIMIT 10;

/*
============================================================================
Task 3: Complete the query for vTopAlbumEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopAlbumEachGenre AS"
============================================================================
*/
CREATE VIEW vTopAlbumEachGenre AS
SELECT Genres.Name AS Genre, Albums.Title AS Album, Artists.Name AS Artist, COUNT(*) AS Sales
FROM Tracks
JOIN Albums ON Tracks.AlbumId = Albums.AlbumId
JOIN Artists ON Albums.ArtistId = Artists.ArtistId
JOIN Genres ON Tracks.GenreId = Genres.GenreId
WHERE (Genres.GenreId, Albums.AlbumId) IN (
    SELECT Tracks.GenreId, Tracks.AlbumId
    FROM Tracks
    JOIN Invoice_Items ON Tracks.TrackId = Invoice_Items.TrackId
    GROUP BY Tracks.GenreId, Tracks.AlbumId
    ORDER BY COUNT(*) DESC
)
GROUP BY Genres.Name;

SELECT Genre, Album, Artist, Sales FROM vTopAlbumEachGenre;



