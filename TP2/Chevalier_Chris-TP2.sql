#1
SELECT NUMAV
FROM VOL
ORDER BY HD;

#2
SELECT count(distinct ADRPIL)
FROM PILOTE;

#3
SELECT NOMAV, CAPAV
FROM AVION
GROUP BY NOMAV, CAPAV
ORDER BY CAPAV;

#4
SELECT avg(CAPAV) AS "nombre de places en moyennes pour les Airbus"
FROM AVION
WHERE NOMAV like 'A3%';

#5
SELECT NUMAV, LOCAV
FROM AVION
WHERE LOCAV != 'Paris Orly' and CAPAV > 200
ORDER BY NUMAV DESC;

#6
SELECT VILLE_ARR
FROM VOL natural join AVION
WHERE VILLE_DEP like 'Paris%' and CAPAV > ANY(SELECT CAPAV
                                              FROM AVION
                                              WHERE NOMAV = 'ATR44');

#7
SELECT NUMPIL
FROM VOL
WHERE VILLE_DEP = 'Paris Orly';

#8
SELECT distinct NUMPIL, NOMPIL, NOMAV
FROM VOL natural join PILOTE natural join AVION
WHERE NOMAV like 'ATR%';

#9
SELECT NUMPIL, ADRPIL
FROM PILOTE
WHERE ADRPIL in (SELECT substring(LOCAV, 1, length(ADRPIL))
                 FROM AVION
                 WHERE NOMAV = 'B747');

#10
SELECT NOMPIL, NOMAV, VILLE_ARR
FROM VOL natural join AVION natural join PILOTE
WHERE NOMPIL = 'Cécile' or NOMPIL = 'Marie';

#11
SELECT count(distinct NUMAV)
FROM VOL;

#12
SELECT NOMAV
FROM AVION
WHERE CAPAV > ALL(SELECT sum(CAPAV)
                  FROM AVION
                  WHERE LOCAV like 'Marseille%');

#13
SELECT count(distinct NUMPIL)
FROM VOL;

#14
SELECT pa.NOMPIL, pb.NOMPIL
FROM PILOTE as pa, PILOTE as pb
WHERE pa.ADRPIL = pb.ADRPIL AND pa.NOMPIL < pb.NOMPIL;

#15
SELECT distinct NUMPIL
FROM PILOTE natural join AVION
WHERE NUMAV = (SELECT count(distinct NUMAV)
               FROM AVION
               WHERE NOMAV like 'A%');
