MATCH (Dinosaur)-[r:MEMBER_OF]->(Group) DELETE r;
MATCH (Dinosaur)-[r:LIVED_DURING]->(Period) DELETE r;
MATCH (Dinosaur)-[r:LIVED_IN]->(Region) DELETE r;

MATCH (g:Group) DELETE g;
MATCH (p:Period) DELETE p;
MATCH (r:Region) DELETE r;
MATCH (d:Dinosaur) DELETE d;

DROP CONSTRAINT Dinosaur_name IF EXISTS;
DROP CONSTRAINT Group_name IF EXISTS;
DROP CONSTRAINT Period_name IF EXISTS;
DROP CONSTRAINT Region_name IF EXISTS;

CREATE CONSTRAINT Dinosaur_name
FOR (x:Dinosaur)
REQUIRE x.name IS UNIQUE;

CREATE CONSTRAINT Group_name
FOR (x:Group)
REQUIRE x.name IS UNIQUE;

CREATE CONSTRAINT Period_name
FOR (x:Period)
REQUIRE x.name IS UNIQUE;

CREATE CONSTRAINT Region_name
FOR (x:Region)
REQUIRE x.name IS UNIQUE;

// Dinosaurs
LOAD CSV WITH HEADERS
FROM 'https://guides.neo4j.com/dinosaur/data/dinosaurs.csv' AS row
MERGE (d:Dinosaur{name:row.name})
SET 
d.diet = row.diet, 
d.length = toFloat(row.length), 
d.named_year = toInteger(row.named_year),
d.link = row.link;

// Groups
LOAD CSV WITH HEADERS
FROM 'https://guides.neo4j.com/dinosaur/data/dinosaurs.csv' AS row
MATCH (d:Dinosaur{name:row.name})
MERGE (g:Group{name:row.type})
MERGE (d)-[:MEMBER_OF]->(g);

// Periods
LOAD CSV WITH HEADERS
FROM 'https://guides.neo4j.com/dinosaur/data/dinosaurs.csv' AS row
WITH row WHERE row.period IS NOT NULL
MATCH (d:Dinosaur{name:row.name})
MERGE (p:Period{name:row.period})
MERGE (d)-[l:LIVED_DURING]->(p)
SET l.from = toInteger(row.period_from), l.to = toInteger(row.period_to);

// Regions
LOAD CSV WITH HEADERS
FROM 'https://guides.neo4j.com/dinosaur/data/dinosaurs.csv' AS row
WITH row WHERE row.lived_in IS NOT NULL
MATCH (d:Dinosaur{name:row.name})
MERGE (r:Region{name:row.lived_in})
MERGE (d)-[:LIVED_IN]->(r);
