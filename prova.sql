create table aeronaves (
id SERIAL PRIMARY KEY,
modelo VARCHAR(150) not null,
codigo_caudo VARCHAR(10) not null unique,
capacidade DECIMAL (10,2) not null check (capacidade > 0)
)

create table pilotos (
id SERIAL PRIMARY KEY,
nome VARCHAR(150) not null,
codigo_anac VARCHAR(6) not null unique,
horas_voo DECIMAL (10,2) not null check (horas_voo >= 0)
)

create table voos (
id SERIAL PRIMARY KEY,
aeronaves_id INTEGER NOT NULL,
pilotos_id INTEGER NOT NULL,
numero_voo VARCHAR(150) NOT NULL,
origem VARCHAR(150) NOT NULL,
destino VARCHAR(150) NOT NULL,
data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
status VARCHAR (30) DEFAULT 'agendado' CHECK (status IN ('agendado', 'em voo', 'concluido', 'cancelado')),

CONSTRAINT fk_aeronave_voo
FOREIGN KEY (aeronaves_id)
REFERENCES aeronaves(id),

CONSTRAINT fk_pilotos_voo
FOREIGN KEY (pilotos_id)
REFERENCES pilotos(id)
);

create table passageiros (
id SERIAL PRIMARY KEY,
nome VARCHAR(150) NOT NULL,
cpf VARCHAR(11) not null unique,
email VARCHAR(150) not null unique
);

create table passagens (
id SERIAL PRIMARY KEY,
voos_id INTEGER NOT NULL,
passageiros_id INTEGER NOT NULL,
assento VARCHAR(4) NOT NULL UNIQUE,
classe VARCHAR (30) default 'economica' CHECK (classe IN('economica', 'executiva')),
valor DECIMAL (10,2) NOT NULL CHECK (valor > 0),

CONSTRAINT fk_voos_passagens
FOREIGN KEY (voos_id)
REFERENCES voos(id),

CONSTRAINT fk_passageiros_passagens
FOREIGN KEY (passageiros_id)
REFERENCES passageiros(id)
);

INSERT INTO aeronaves (modelo, codigo_caudo, capacidade) values
('Airbus', 'AFE-124', 50),
('aeronave2', 'AHG-323', 35),
('aeronaverosa', 'ERU-545', 60),
('aeronaveazul', 'EYT-746', 55),
('aeronavedabarbie', 'OPI-875', 30);

SELECT * FROM
AERONAVES

insert into pilotos (nome, codigo_anac, horas_voo) values
('Roberto Vanir', '456733', 1045 ),
('Claúdio Ramos', '726472', 1330),
('Fernando Almeida', '726323', 1120),
('José Nunes', '723463', 1555),
('Natanael da Silva', '763472', 0730);

insert into passageiros (nome, cpf, email) values
('Renata Vasconcelos', '45673332321', 'renata.90@gmail.com'),
('Claúdia Fernandes', '72647245431', 'claudia.fernandes@gmail.com'),
('Julia Silva', '72632357921', 'julia.silva@gmail.com'),
('João Costa', '72346346983', 'joao.costa@gmail.com' ),
('Marina Lurdes', '76347453182', 'marina.lurdes@gmail.com');

insert into voos (aeronaves_id, pilotos_id, numero_voo, origem, destino, data_hora, status) values
(1,1, '12342', 'São Paulo', 'florianópolis', '20/10/2025 09:10:00', 'concluido'),
(2,2, '73642', 'Mato Grosso do sul', 'Rio de Janeiro', '02/10/2026 10:00:00', 'em voo'),
(3,3, '72356', 'Florianópolis', 'Rio Grande do Sul', '09/09/2024 11:00:00', 'cancelado'),
(4,4, '83672', 'Curitiba', 'São Paulo', '07/08/2027 12:00:00', 'agendado' ),
(5,5, '87548', 'Rio de Janeiro', 'Brasilia', '10/10/2026 12:30:00', 'agendado');

insert into passagens (voos_id, passageiros_id, assento, classe, valor) values
(17,1, 'a12', 'economica', 320.00),
(18,2, 'a13', 'executiva', 600.00),
(19,3, 'a14', 'economica', 320.00),
(20,4, 'a15', 'executiva', 600.00),
(21,5, 'a16', 'economica', 320.00);

insert into passagens (voos_id, passageiros_id, assento, classe, valor) values
(17,1, 'a12', 'economica', 320.00),
(18,2, 'a13', 'executiva', 600.00),
(19,3, 'a14', 'economica', 320.00),
(20,4, 'a15', 'executiva', 600.00),
(21,5, 'a16', 'economica', 320.00);

select
v.numero_voo, 
v.origem,
v.destino,
a.modelo AS modelo_aeronave,
p.nome As nome_piloto
from voos v
join aeronaves a on v.aeronaves_id = a.id
join pilotos p on v.pilotos_id = p.id
where v.status in ('agendado', 'em voo');

create view vw_painel_aeroporto as
select
v.numero_voo, 
v.origem,
v.destino,
a.modelo AS modelo_aeronave,
p.nome As nome_piloto
from voos v
join aeronaves a on v.aeronaves_id = a.id
join pilotos p on v.pilotos_id = p.id
where v.status in ('agendado', 'em voo');

select
classe,
sum(valor) as total_arrecadado
from passagens
group by classe
order by classe;

create view vw_faturamento_por_voo as
select
classe,
sum(valor) as total_arrecadado
from passagens
group by classe
order by classe;

select
p.nome as nome_passageiros,
v.numero_voo,
pa.assento,
pa.valor
from passagens pa
join passageiros p ON pa.passageiros_id = p.id
join voos v  on pa.voo_id = v.id
where pa.classe = 'executiva'
and pa.valor > 800.00
order by pa.valor desc;