--Donner toutes les paires de noms de pilotes habitant la même ville. (Supprimer les doublons : Pierre-Paul = Paul-Pierre).

SELECT pa.NOMPIL, pb.NOMPIL
FROM PILOTE as pa, PILOTE as pb
WHERE pa.ADRPIL = pb.ADRPIL AND pa.NOMPIL < pb.NOMPIL;

--1- Combien de produits a emprunté chaque utilisateur ?
-- chaque utilisateur => GROUP BY utilisateur
-- combien : count()

SELECT count(numproduit), numuser
FROM emprunt NATURAL JOIN emprunt_produit
GROUP BY numuser;

--2- Donner en moyenne le nombre de pc empruntés par jour
-- combien de PC sont empruntés chaque jour ?
-- utiliser ce SELECT comme table temporaire dans la clause FROM
-- et en faire la moyenne

SELECT avg(nbepd)
FROM (SELECT count(numproduit) AS nbepd
	  FROM emprunt NATURAL JOIN emprunt_produit JOIN produit ON codebarre = numproduit
	  WHERE nom like 'PC%'
	  GROUP BY date_emprunt) AS TA;

--3- Donner la liste des pc ayant été empruntés au moins 2 fois par jour
-- grouper par date (chaque jour) et par produit
-- ne garder que ceux qui ONt été emprunté au moins 2 fois (HAVING count(*) >=2 )

SELECT nom
FROM produit
WHERE nom like 'PC%' and codebarre not in (SELECT numproduit
	                                       FROM emprunt NATURAL JOIN emprunt_produit
	                                       GROUP BY date_emprunt,numproduit
	                                       HAVING count(*) >= 2);

--4- Sans utiliser de sous-requête, donner la liste des produits n'ayant jamais été empruntés
-- dONc jamais présent dans la table emprun_produit => Jointure externe

SELECT nom
FROM produit LEFT JOIN emprunt_produit ON codebarre = numproduit
WHERE numproduit is NULL;

--5- Quels sont les produits ayant été rendu par au moins 5 utilisateurs différents ?
-- groupé par numproduit, HAVING count(*) >5

SELECT nom
FROM produit
WHERE codebarre in (SELECT numproduit
			        FROM emprunt NATURAL JOIN emprunt_produit
                    WHERE date_rendu is not NULL
			        GROUP BY numproduit
			        HAVING count(distinct numuser) >= 5);

--6- Quel utilisateur a emprunté au moins une fois tous les produits ?
-- sont nombre de produits différents empruntés est égale au nombre de produits différents que nous avons

SELECT utilisateur.nom
FROM utilisateur NATURAL JOIN emprunt NATURAL JOIN emprunt_produit RIGHT JOIN produit ON codebarre=emprunt_produit.numproduit
GROUP BY utilisateur.nom
HAVING count(distinct numproduit) >= all(SELECT count(distinct codebarre)
                                         FROM produit);

--7- Quel utilisateur a au moins emprunté 3 fois le même vidéoprojecteur dans le même mois ?

-- pour commencer, le nombre d'emprunts fait chaque mois :
SELECT count(*),date_part('year', date_emprunt) || '-' || date_part('month', date_emprunt) AS mois
FROM emprunt
GROUP BY mois;

-- il faudra donc avec le même système faire le GROUP BY dans la requête

SELECT nom
FROM utilisateur
WHERE numuser in (SELECT numuser
                  FROM emprunt NATURAL JOIN emprunt_produit JOIN produit ON codebarre = emprunt.numemprunt
                  WHERE nom like 'Vidéoprojecteur%'
                  GROUP BY numproduit, numuser, date_part('year', date_emprunt) ||'-' || date_part('mONth', date_emprunt)
                  HAVING count(numemprunt) >=3);

--8- Quelle est la durée moyenne d’un emprunt ayant au maximum 2 produits dONt 1 vidéoprojecteur et une clé ?
-- durée moyenne d'un emprunt ?
date_rendu - date_emprunt

-- emprunt ayant un max de 2 produits ?
...GROUP BY numemprunt HAVING count(*) >=2 ...

-- emprunt contenant 1 vidéo et un cle ?
le numemprunt doit être dans emprunt-produit associé à un vidéo et aussi à une clé.
2 conditiONs dans le WHERE numemprunt in (les emprunt contenant un vidéo)
and numemprunt in(les emprunts cONtenant une clé)

----------- 4,9493....
SELECT avg(duree)
FROM (SELECT max(date_rendu - date_emprunt) AS duree
      FROM emprunt NATURAL JOIN emprunt_produit
      WHERE numemprunt in (SELECT numemprunt
                           FROM emprunt_produit JOIN produit ON codebarre=numproduit
                           WHERE nom like 'PC%') AND numemprunt IN (SELECT numemprunt
                                                                    FROM emprunt_produit JOIN produit ON codebarre = numproduit
                                                                    WHERE nom like 'Vidéo%')
                           GROUP BY numemprunt
                           HAVING count(*) >=2 ) AS T;
-----------
