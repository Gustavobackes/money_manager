#!/bin/bash

# Caminho para o docker-compose do PostgreSQL
POSTGRES_COMPOSE="docker/postgres/docker-postgres.yml"

# Nome do contêiner do PostgreSQL (deve ser igual ao definido no docker-compose)
POSTGRES_CONTAINER="postgres"

# Função para verificar se o contêiner do PostgreSQL está ativo
wait_for_postgres() {
    echo "Aguardando o PostgreSQL iniciar..."
    while ! docker ps --filter "name=$POSTGRES_CONTAINER" --filter "status=running" | grep $POSTGRES_CONTAINER > /dev/null; do
        echo "PostgreSQL ainda não está ativo. Aguardando..."
        sleep 2
    done
    echo "PostgreSQL está ativo!"
}

# Derrubar o contêiner e remover volumes antigos
echo "Parando e removendo o contêiner PostgreSQL com volumes antigos..."
docker-compose -f "$POSTGRES_COMPOSE" down --volumes --remove-orphans

# Subir o contêiner PostgreSQL
echo "Subindo o PostgreSQL..."
docker-compose -f "$POSTGRES_COMPOSE" up --build -d

# Esperar o PostgreSQL estar pronto
wait_for_postgres

# Verificar se o arquivo init.sql está montado corretamente
echo "Verificando se o arquivo init.sql foi montado no contêiner..."
docker exec -it "$POSTGRES_CONTAINER" ls /docker-entrypoint-initdb.d/init.sql > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro: O arquivo init.sql não foi encontrado no contêiner!"
    exit 1
fi
echo "O arquivo init.sql está montado corretamente."

# Executar o script init.sql manualmente
echo "Executando o script init.sql no PostgreSQL..."
docker exec -it "$POSTGRES_CONTAINER" psql -U postgres -d postgres -f /docker-entrypoint-initdb.d/init.sql
if [ $? -eq 0 ]; then
    echo "Script init.sql executado com sucesso!"
else
    echo "Erro ao executar o script init.sql!"
    exit 1
fi

echo "Setup completo!"
