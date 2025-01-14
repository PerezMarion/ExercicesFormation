CREATE DATABASE tp2

USE DATABASE tp2

CREATE TABLE orders(
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    typePresta VARCHAR(50) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    clientId INTEGER NOT NULL,
    nbDays INTEGER NOT NULL,
    unitPrice INTEGER NOT NULL,
    state(1) INTEGER NOT NULL);

INSERT INTO orders(typePresta,designation,clientId,nbDays,unitPrice,state)values
("formation","angular init",2,3,1200,0),
("formation","react avance",2,3,1000,2),
("coaching","react techlead",1,20,900,2),
("coaching","nest.js techlead",1,50,800,1),
("coaching","react techlead",3,30,950,1),
("coaching","jakarta EE",3,15,1100,0),
("coaching","angular techlead",4,100,3000,2),
("formation","angular init",1,5,1500,1),
("formation","react avance",2,4,1000,1),
("coaching","react techlead",4,60,2500,2);

CREATE VIEW prix_HT_TTC AS SELECT (unitPrice*nbDays) AS totalExcluseTaxe, (unitPrice*nbDays*1.2) AS totalWithTaxe FROM orders;

SELECT * FROM prix_HT_TTC;

CREATE TABLE clients(
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    compagnyName VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    adress VARCHAR(100) NOT NULL,
    zipCode VARCHAR(20) NOT NULL,
    city VARCHAR(20) NOT NULL,
    country VARCHAR(20) NOT NULL,
    state(1) INTEGER NOT NULL);

INSERT INTO clients(compagnyName,firstName,lastName,email,phone,adress,zipCode,city,country,state)values
("capgemini","fabrice","martin","martin@mail.com","06 56 85 84 33","1 rue de la paix","xyz","nantes","france",0),
("M2I formation","julien","lamard","lamard@mail.com","06 11 22 33 44","2 rue de la paix","xyz","paris","france",1);

SELECT * FROM clients;

-- 1. Ajouter deux autres ESN

INSERT INTO clients(compagnyName,firstName,lastName,email,phone,adress,zipCode,city,country,state)values
("ATOS","jean","dupont","jean.dupont@mail.com","06 12 34 56 78","3 rue de la paix","xyz","lille","france",1),
("sopra steria","murielle","guillaume","m.guillaume@mail.com","07 89 12 34 56","4 rue de la paix","xyz","toulouse","france",0);

SELECT * FROM clients;

-- 2. Ecrire une requête pour créer ces deux tables en prenant en compte la jointure

ALTER TABLE orders ADD FOREIGN KEY(clientId) REFERENCES clients(id) ON DELETE RESTRICT;

SELECT clients.compagnyName, clients.state, orders.typePresta, orders.designation 
FROM clients JOIN orders ON clients.id=orders.clientId;

-- 3. Afficher toutes les formations sollicités par le client M2i formation

SELECT clients.compagnyName AS Entreprise,orders.typePresta AS Prestation,orders.designation AS Nom,orders.state AS Statut 
FROM clients JOIN orders ON clients.id=orders.clientId 
WHERE orders.typePresta="formation" AND clients.compagnyName="M2I formation";

-- 4. Afficher les noms et contacts de tous les contacts des clients qui ont sollicité un coaching

SELECT DISTINCT(clients.id), clients.firstName AS Prenom, clients.lastName AS Nom, clients.email, clients.phone AS Telephone, clients.adress AS Adresse 
FROM clients JOIN orders ON clients.id=orders.clientId 
WHERE orders.typePresta="coaching";

-- 5. Afficher les noms et contacts de tous les contacts des clients qui ont sollicité un coaching pour les accompagnements React.js

SELECT DISTINCT(clients.id), clients.firstName AS Prenom, clients.lastName AS Nom, clients.email, clients.phone AS Telephone, clients.adress AS Adresse 
FROM clients JOIN orders ON clients.id=orders.clientId 
WHERE orders.typePresta="coaching" AND orders.designation="React.js";

-- 6. Pour chacune des demandes de formations, afficher le prix UHT et prix TTC

SELECT orders.typePresta, orders.designation, orders.unitPrice*orders.nbDays AS prix_UHT, orders.unitPrice*orders.nbDays*1.2 AS prix_TTC 
FROM clients JOIN orders ON clients.id=orders.clientId 
WHERE orders.typePresta="formation";

-- 7. Lister toutes les prestations qui sont confirmés et qui vont rapporter plus de 30.000 euros

SELECT orders.typePresta, orders.designation, orders.unitPrice*orders.nbDays*1.2 AS prix_TTC 
FROM clients JOIN orders ON clients.id=orders.clientId 
WHERE orders.unitPrice*orders.nbDays*1.2>30000 AND orders.state=2;


-- Si je veux dans une table, avoir une colonne résultant d'un calcul entre d'autres colonnes de la même table, calculé automatiquement :

CREATE TABLE ...(
    ...
    ...
    ...
    unitPrice ...
    nbDays ...
    prix_UHT FLOAT GENERATED ALWAYS AS (unitPrice*nbDays) STORED,
    prix_TTC FLO FLOAT GENERATED ALWAYS AS (unitPrice*nbDays*1.2) STORED);

-- Si je veux faire une requête imprécise car je ne sais pas exactement le champs à rechercher :
-- Si je sais que le nom de l'organisme de formation commence par "M2" (recherche en début de chaîne)

SELECT * FROM clients WHERE compagnyName LIKE "M2%";

-- Si je sais que le nom de l'organisme de formation fini par "formation" (recherche en fin de chaîne)

SELECT * FROM clients WHERE compagnyName LIKE "%formation";

-- Si je recherche le mail d'une personne travaillant chez Sopra Steria donc possédant un mail du type "...@sopra..." (recherche en milieu de chaîne)

SELECT * FROM clients WHERE mail LIKE "%sopra%";

-- Cela fonctionne de la même manière avec les chiffres
-- Admettons que dans ma base de données, les numéros de téléphones possède des préfixes
-- Si je recherche combien il y a de numéros de téléphone de clients français 

SELECT COUNT(*) FROM clients WHERE phone LIKE "+33%";