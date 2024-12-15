-- Seleciona o banco de dados 'postgres' (opcional caso já esteja configurado no init.sql)
\c postgres;

-- Criação da tabela de entradas
CREATE TABLE entradas (
    id SERIAL PRIMARY KEY,           -- Identificador único
    valor NUMERIC(10, 2) NOT NULL,   -- Valor da entrada
    descricao TEXT NOT NULL,         -- Descrição da entrada
    data DATE NOT NULL,              -- Data da entrada
    categoria VARCHAR(50) NOT NULL   -- Categoria (e.g., ativo, recorrente, etc.)
);

-- Criação da tabela de saídas
CREATE TABLE saidas (
    id SERIAL PRIMARY KEY,           -- Identificador único
    valor NUMERIC(10, 2) NOT NULL,   -- Valor da saída
    descricao TEXT NOT NULL,         -- Descrição da saída
    data DATE NOT NULL,              -- Data da saída
    categoria VARCHAR(50) NOT NULL   -- Categoria (e.g., passivo, recorrente, etc.)
);

-- Verificar se há registros em 'entradas' ou 'saidas' e evitar inserção caso já existam
DO $$
BEGIN
    -- Verificar se existe algum registro em 'entradas' ou 'saidas'
    IF EXISTS (SELECT 1 FROM entradas) OR EXISTS (SELECT 1 FROM saidas) THEN
        RAISE NOTICE 'Tabelas já possuem registros. Nenhuma inserção será realizada.';
    ELSE
        -- Inserir exemplos iniciais para a tabela 'entradas'
        INSERT INTO entradas (valor, descricao, data, categoria)
        VALUES
            (5000.00, 'Salário Mensal', '2024-12-01', 'Recorrente'),
            (150.00, 'Freelance Design', '2024-12-10', 'Ativo');

        -- Inserir exemplos iniciais para a tabela 'saidas'
        INSERT INTO saidas (valor, descricao, data, categoria)
        VALUES
            (1200.00, 'Aluguel Mensal', '2024-12-01', 'Recorrente'),
            (300.00, 'Conta de Luz', '2024-12-05', 'Recorrente'),
            (50.00, 'Jantar com amigos', '2024-12-12', 'Passivo');

        RAISE NOTICE 'Registros iniciais inseridos com sucesso.';
    END IF;
END
$$;