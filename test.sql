CREATE TABLE student (
    student_id INT,
    name VARCHAR(20),
    major VARCHAR(20),
    PRIMARY KEY(student_id)
);

/*NOT NULL depois de name, por ex, faria com que o name não pudesse não ter valor, deve ser preenchido obrigatoriamente*/
/*UNIQUE depois de major, por ex, faria com que o major não pudesse ser repetido caso já exista em alguma linha*/
/*DEFAULT 'valor padrão' depois de qualquer uma das colunas significa que, caso não se entre com um valor para a coluna, o padrão será: DEFAULT 'inserir valor padrão'*/
/*AUTO_INCREMENT depois da student_id INT faria com que o sql colocasse automticamente as keys, não precisa especificar como lá embaixo*/