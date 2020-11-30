--1 Qual é a média da nota em matemática de todos os alunos mineiros?
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG;
--2 Qual é a média da nota em Linguagens e Códigos de todos os alunos mineiros?
SELECT
    round(avg(nu_nota_lc), 3)
FROM
    enem_2019_MG;
--3 Qual é a média da nota em Ciências Humanas dos alunos do sexo FEMININO mineiros?
SELECT
    round(avg(nu_nota_ch), 3)
FROM
    enem_2019_MG
WHERE
    tp_sexo = 'F';
--4 Qual é a média da nota em Ciências Humanas dos alunos do sexo MASCULINO?
--WIP
SELECT
    round(avg(nu_nota_ch), 3)
FROM
    enem_2019_MG
WHERE
    tp_sexo = 'M';
--5 Qual é a média da nota em Matemática dos alunos do sexo FEMININO que moram na cidade de Montes Claros?
--WIP
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    tp_sexo = 'F'
    AND no_municipio_residencia = 'Montes Claros';
--6 Qual é a média da nota em Matemática dos alunos do município de Sabará que possuem TV por assinatura na residência?
--WIP
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    no_municipio_residencia = 'Sabará'
    AND Q021 = 'B';
--7 Qual é a média da nota em Ciências Humanas dos alunos mineiros que possuem dois fornos micro-ondas em casa?
SELECT
    round(avg(nu_nota_ch), 3)
FROM
    enem_2019_MG
WHERE
    q016 = 'C';
--8 Qual é a nota média em Matemática dos alunos mineiros cuja mãe completou a pós-graduação?
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    q002 = 'G';
--9 Qual é a nota média em Matemática dos alunos de Belo Horizonte e de Conselheiro Lafaiete?
--WIP
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    no_municipio_residencia IN ('Belo Horizonte', 'Conselheiro Lafaiete');
--10 Qual é a nota média em Ciências Humanas dos alunos mineiros que moram sozinhos?
SELECT
    round(avg(nu_nota_ch), 3)
FROM
    enem_2019_MG
WHERE
    q005 = 1;
--11 Qual é a nota média em Ciências Humanas dos alunos mineiros cujo pai completou Pós graduação e possuem renda familiar entre R$ 8.982,01 e R$ 9.980,00.
SELECT
    round(avg(nu_nota_ch), 3)
FROM
    enem_2019_MG
WHERE
    q001 = 'G'
    AND q006 = 'M';
--12 Qual é a nota média em Matemática dos alunos do sexo Feminino que moram em Lavras e escolheram “Espanhol” como língua estrangeira?
--WIP
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    tp_sexo = 'F'
    AND no_municipio_residencia = 'Lavras'
    AND tp_lingua = 1;
--13 Qual é a nota média em Matemática dos alunos do sexo Masculino que moram em Ouro Preto?
--WIP
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    tp_sexo = 'M'
    AND no_municipio_residencia = 'Ouro Preto';
--14 Qual é a nota média em Ciências Humanas dos alunos surdos?
--WIP
SELECT
    round(avg(nu_nota_ch), 3)
FROM
    enem_2019_MG
WHERE
    IN_SURDEZ = 1;
--15 Qual é a nota média em Matemática dos alunos do sexo FEMININO, que moram em Belo Horizonte, Sabará, Nova Lima e Betim e possuem dislexia?
--WIP
SELECT
    round(avg(nu_nota_mt), 3)
FROM
    enem_2019_MG
WHERE
    tp_sexo = 'F'
    AND no_municipio_residencia IN ('Belo Horizonte', 'Sabará', 'Nova Lima', 'Betim')
    AND IN_DISLEXIA = 1;
