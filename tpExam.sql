#1
SELECT numav
FROM vol
GROUP BY numvol
HAVING numvol >= 2;

#2
--Quels sont les avions qui font une durée de vol la plus importante ?
SELECT numav
FROM avion
WHERE numav in (SELECT max(hd - ha)
                FROM vol);

#3
--Quels sont les départements où il n’y a personne du grade 3 ? (le grade dépend du salaire)
SELECT distinct deptno
FROM emp
WHERE not exists (SELECT grade
                  FROM salgrade
                  WHERE grade = 3);

#4
--Quel est le nom d’utilisateur qui a emprunté le plus de fois le même produit ?
--Donner le nom de l’utilisateur et le nom du produit
SELECT utilisateur.nom, produit.nom, count(numproduit)
FROM utilisateur NATURAL JOIN produit NATURAL JOIN emprunt_produit
GROUP BY

#5
--Quelle est la ville qui reçoit le plus grand nombre d’avions différents ?
SELECT ville_arr
FROM vol
WHERE numav in(SELECT max(distinct numav)
               FROM vol);

#6
--Quels sont les produits qui n’ont pas été empruntés pendant au moins 30 jours?
SELECT numproduit
FROM emprunt_produit NATURAL JOIN emprunt
WHERE date_emprunt >= 30;
