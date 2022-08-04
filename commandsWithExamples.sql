CREATE TABLE student (
    student_id INT,
    name VARCHAR(20),
    major VARCHAR(20),
    PRIMARY KEY(student_id)
);

--Obs (constraints):
-- NOT NULL depois de name, por ex, faria com que o name não pudesse ser vazio, deve ser preenchido obrigatoriamente
-- UNIQUE depois de major, por ex, faria com que o major não pudesse ser repetido caso já exista em alguma linha anterior (PRIMARY KEY is both NOT NULL and UNIQUE)
-- DEFAULT 'undecided' depois de major, por ex, significa que caso o valor para a coluna fique em branco (vazio), será inserido 'undecided' nesta linha e coluna específica
-- AUTO_INCREMENT depois da student_id pede que o sql coloque automaticamente as keys

DESCRIBE student; -- show table's layout

DROP TABLE student; -- if I want to drop/delet the table. After running this, table 'student' no longer exists. If you want it to exist, you have to run the create table command again

-- Let's say after the table was created, you want to give it another column:

ALTER TABLE student ADD gpa DECIMAL(3, 2); -- student's gpa is a new column

ALTER TABLE student DROP COLUMN gpa; -- delet the column 'gpa'



INSERT INTO student VALUES(1, 'Jack', 'Biology');

SELECT * FROM student; -- mostra todo o conteúdo da tabela, toda vez que clico aqui

-- caso a student_id fosse AUTO_INCREMENT, teria que inserir a info assim: INSERT INTO student(name, major) VALUES('Jack', 'Biology') - isso pode ser útil se tiver várias variáveis com AUTO_INCREMENT
-- posso simplesmente escrever INSERT INTO student(student_id, name) VALUES(1, 'Jack') se não possuo a informação do major (ficará vazio). Ou se não possuo a informação, faço normalmente e insiro "NULL" onde não possuo a informação

INSERT INTO student VALUES(2, 'Kate', 'Sociology'); -- estou escrevendo cada linha por extenso pra fins de rastreabilidade, mas o POPSql pelo menos, pode escrever tudo no mesmo e ir rodando que ele armazena as informações
INSERT INTO student VALUES(3, 'Claire', 'Chemistry');
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');



UPDATE student
SET major = 'Bio'
WHERE major = 'Biology'; -- changing everyone who has a major in Biology to Bio

-- Obs (other comparison operators):
-- = :equals
-- <> :not equals
-- > :greater than
-- < :less than
-- >= :greater than or equal
-- <= :less than or equal

UPDATE student
SET major = 'Comp Sci'
WHERE student_id = 5; -- changing a specific student's major

UPDATE student
SET major = 'Biochemistry'
WHERE major = 'Bio' OR major = 'Chemistry';

UPDATE student
SET name = 'Tom', major = 'undecided' -- it is also possible to do multiple sets
WHERE student_id = 1;

UPDATE student
SET major = 'undecided'; -- with no "where" statement, there is no restriction so it applies to everyone in the table

DELETE FROM student; -- delet all rows in the table

DELETE FROM student
WHERE student_id = 5; -- delet row 5 (student_id is a primary key)

DELETE FROM student
WHERE name = 'Tom' AND major = 'undecided';



SELECT student.name, student.major -- o student na frente evidencia de qual tabela estamos selecionando
FROM student
ORDER BY name; -- ordenar o output pelo nome; o default é ordenar por ordem alfabética/ascendente. se quisermos o contrário, o comando DESC deve vir após "name". É possível também ordenar por, por exemplo, student_id; por mais que ele não tenha sido selecionado/não apareça na tabela

SELECT *
FROM student
ORDER BY major, student_id; -- ordena primeiro por major depois student_id (se tiver algum deles com o mesmo major, serão ordenados por student_id)

SELECT *
FROM student
ORDER BY student_id DESC
LIMIT 2; -- pega só as primeiras 2 linhas da tabela

SELECT *
FROM student
WHERE major = 'Biology'; -- queremos ver quem tem major "Biology"

SELECT *
FROM student
WHERE name IN ('Claire', 'Kate', 'Mike') AND student_id > 2; -- aparecendo só as linhas que possuem esses nomes 'Claire', 'Kate', 'Mike' e com student_id maior que 2



-- now creating bigger tables and that has some relationships

DROP TABLE student;

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT, -- super_id e branch_id são foreign keys, apontam para outras tabelas que serão construídas, mas ainda não podemos definir aqui como foreign keys porque essas tabelas ainda não foram criadas
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL -- mgr_id é a foreign key que se relaciona com a coluna emp_id da tabela employee
);

-- ON DELETE SET NULL significa que caso algum employee seja deletado, ficará um NULL no lugar de mgr_id (usar em foreign keys, que não são tão essenciais pra tabela)
-- ON DELETE CASCADE significa que caso algum employee seja deletado, deleta as linhas inteiras da database onde o emp_id foi deletado (usar em primary keys, porque são essenciais pra tabela, primary key não pode ter valor NULL)

-- agora podemos setar super_id e branch_id como foreign keys, pois as duas tabelas foram criadas

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);



-- Corporate (branch)
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL); -- adicionando NULL onde tem foreign keys porque ainda não foi inserido valores na tabela branch

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100; -- agora podemos adicionar o valor da foreign key

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- Branch Supplier
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- Client
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- Works_With
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);



SELECT * FROM employee
ORDER BY salary; -- ordena por salário

SELECT * FROM employee
ORDER BY sex, first_name, last_name; -- ordena primeiro por sexo, depois pelo primeiro nome e pelo ultimo nome

SELECT first_name AS forename, last_name AS surname
FROM employee; -- seleciona e renomeia as colunas

SELECT DISTINCT sex
FROM employee; -- todos os diferentes generos da tabela

SELECT DISTINCT branch_id
FROM employee; -- todos as diferentes áreas da empresa na tabela

-- Functions
SELECT COUNT(emp_id)
FROM employee; -- quantos funcionarios a empresa tem

SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1971-01-01'; -- quantas funcionárias mulheres nascidas a partir de 1970

SELECT AVG(salary)
FROM employee; -- média dos salarios de todos os funcionários

SELECT AVG(salary)
FROM employee
WHERE sex = 'M'; -- média dos salarios dos funcionários homens

SELECT COUNT(sex), sex
FROM employee
GROUP BY sex; -- quantos funcionários homens e mulheres. primeiro conta quantos "sex" existem, depois seleciona a coluna e agrupa

SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id; -- total de vendas por cada funcionário

SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id; -- quanto cada cliente gastou com o branch

-- Wildcards
SELECT *
FROM client
WHERE client_name LIKE '%LLC'; -- filtrando clientes que possuem LLC no nome. O nome teria que ter LLC no final, se fosse LLC primeiro, seria LLC%

SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%'; -- fornecedores do branch que possuem "Label" no nome

SELECT *
FROM employee
WHERE birth_day LIKE '____-10%'; -- funcionários que nasceram em outubro. Usamos _ aqui pra representar o ano porque sabemos que o formato é 'YYYY-MM-DD'

SELECT *
FROM client
WHERE client_name LIKE '%school%'; -- clientes que sejam uma escola

-- Union
SELECT first_name AS company_names -- só é possível usar UNION quando seleciono o mesmo número de colunas. Nesse caso to selecionando 1 e depois 1 também. Elas também devem ter datatype similares; neste caso, ambas são colunas que contém strings
FROM employee
UNION
SELECT branch_name
FROM branch; -- lista de todos os funcionarios e áreas em uma só coluna; poderia colocar mais UNION e não teria problema

SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier; -- ambos tem branch_id, facilita se colocarmos o nome da tabela antes

SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with; -- lista todo o dinheiro que a empresa gastou e ganhou

-- Joins
-- inserindo mais uma linha na tabela "Branch" sem mgr_id e sem mgr_start_date

INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

-- Áreas e o nome do gerente de cada área
SELECT employee.emp_id, employee.first_name, branch.branch_name -- especificando que queremos pegar uma coluna da tabela "Branch", e o JOIN depois puxa ela
FROM employee
JOIN branch -- o JOIN normal é o INNER JOIN: interseção
ON employee.emp_id = branch.mgr_id; -- combinar as linhas nessas condições employee.emp_id = branch.mgr_id

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id; -- agora aparecem todos os funcionários, mas os que não estiverem associados a mgr_id (manager de uma área da empresa) aparecem NULL

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id; -- agora aparecem todas as áreas, mas as que não tiverem manager aparecem NULL

-- existe também FULL OUTER JOIN, que apareceria todas as condições (une LEFT e RIGHT). mas o MySQL não permite

-- Nomes dos funcionarios que venderam mais de 30000 para um só cliente
SELECT works_with.emp_id
FROM works_with
WHERE works_with.total_sales > 30000; -- id's dos funcionários que venderam > 30000; isso vai ir dentro de um WHERE

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
); -- queremos o primeiro e ultimo nome dos funcionarios onde o emp_id está NO RESULTADO do que está dentro dos parenteses!

-- Todos os clientes que são da área em que Michael Scott é gerente (assumindo que sabemos o ID dele)
SELECT branch.branch_id
FROM branch
WHERE branch.mgr_id = 102; -- sabendo que a id do Michael Scott é 102, vamos pegar a foreign key branch_id que liga essa tabela com a "client"; e isso vai ir dentro do WHERE

SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102
); -- primeiro executa o que está dentro do parênteses e depois o mais externo; nesse caso deu certo porque Michael Scott só é mgr de 1 só branch. Caso ele fosse mgr de mais de um branch, teríamos que adicionar LIMIT 1 dentro do parênteses depois do WHERE



-- Deleting a foreign key
DELETE FROM employee
WHERE emp_id = 102;

SELECT * FROM branch;
SELECT * FROM employee;

DELETE FROM branch
WHERE branch_id = 2;

SELECT * FROM branch_supplier;



-- Triggers (has to be done in the command line, POPSQL doesn't run trigger)
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT -- my_trigger is the name of the trigger
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee'); -- the delimiter was changed bc we are using semicolon to end this SQL command. So we can't use the same delimiter in order to end off the trigger creation. If we do, then SQL will read this statement as the end of the trigger
    END$$ -- here the trigger is done being created! now we can just delinear back to a semicolon
DELIMITER ;

-- adding a new employee to test
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;

DELIMITER $$
CREATE
    TRIGGER my_trigger1 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;

DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        IF NEW.sex = 'M' THEN
            INSERT INTO trigger_test VALUES('added male employee');
        ELSEIF NEW.sex = 'F' THEN
            INSERT INTO trigger_test VALUES('added female employee');
        ELSE
            INSERT INTO trigger_test VALUES('added other employee');
        END IF;
    END$$
DELIMITER ;



-- HAVING is used in combination with GROUP BY to ignore groups that don't meet certain criteria. So this query, for example, will only include groups that have more than one ID in them.
SELECT Animal, COUNT(ID)
FROM 'bigquery-public-data.pet_records.pets'
GROUP BY Animal
HAVING COUNT(ID) > 1


-- Select query with INNER JOIN on multiple tables

--SELECT column, another_table_column, …
--FROM mytable
--INNER JOIN another_table 
--    ON mytable.id = another_table.id
--WHERE condition(s)
--ORDER BY column, … ASC/DESC
--LIMIT num_limit OFFSET num_offset;
