-- tabla de usuarios, con validaciones de longitud y unicidad
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	username VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    register_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_connection TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,

    CONSTRAINT ck_length_username
        CHECK (CHAR_LENGTH(username) >= 4),
    CONSTRAINT ck_registerat_lastconnection
        CHECK (last_connection >= register_at)
);

-- tabla de monedas, con validaciones de longitud y unicidad
CREATE TABLE coins (
    id SERIAL PRIMARY KEY,
    external_id TEXT UNIQUE NOT NULL,
    name VARCHAR(50) UNIQUE NOT NULL,
    symbol VARCHAR(10) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    description TEXT NOT NULL,

    CONSTRAINT ck_length_symbol
        CHECK (CHAR_LENGTH(symbol) >= 3)
);

-- tabla de balances, con restricciones de clave foránea y unicidad para evitar duplicados
CREATE TABLE balances (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    coin_id INTEGER NOT NULL,
    amount NUMERIC(32, 18) DEFAULT 0 NOT NULL,

    CONSTRAINT fk_balances_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_balances_coin
        FOREIGN KEY (coin_id) REFERENCES coins(id)
        ON DELETE RESTRICT,

    CONSTRAINT uq_user_coin
        UNIQUE(user_id, coin_id)
);

-- tipo enumerado para las transacciones, con valores predefinidos
CREATE TYPE tx_type AS ENUM ('deposit', 'withdrawal', 'trade', 'fee');

-- tabla de transacciones, con restricciones de clave foránea, validaciones de cantidad y un campo para agrupar transacciones relacionadas
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    coin_id INTEGER NOT NULL,
    type tx_type NOT NULL,
    amount NUMERIC(32, 18) NOT NULL,
    fee NUMERIC(32, 18) DEFAULT 0 NOT NULL,
    trade_group_id UUID,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_users
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_transactions_coins
        FOREIGN KEY (coin_id) REFERENCES coins(id)
        ON DELETE RESTRICT,

    CONSTRAINT ck_amount_zero
        CHECK (amount <> 0)
);

-- trigger para actualizar balances despues de cada transaccion
CREATE OR REPLACE FUNCTION fn_update_balance_after_tx()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Intentamos insertar una fila nueva en balances
    INSERT INTO balances (user_id, coin_id, amount)
    VALUES (NEW.user_id, NEW.coin_id, NEW.amount)
    -- 2. Si ya existe la combinación (user_id, coin_id), saltamos al UPDATE
    ON CONFLICT (user_id, coin_id)
    DO UPDATE SET 
        amount = balances.amount + EXCLUDED.amount;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger para ejecutar la función después de cada inserción en transacciones
CREATE TRIGGER tr_sync_balances
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION fn_update_balance_after_tx();

-- consulta de ejemplo para verificar que los balances se actualizan correctamente después de una transacción
SELECT users.username, coins.symbol, balances.amount
FROM balances
JOIN users ON users.id = balances.user_id
JOIN coins ON coins.id = balances.coin_id
WHERE balances.user_id = 2 AND balances.coin_id = 1;

-- view para mostrar el portafolio completo de cada usuario, con su nombre de usuario, símbolo de la moneda y cantidad
CREATE OR REPLACE VIEW view_user_portfolio AS
SELECT users.username, coins.symbol, balances.amount
FROM balances
JOIN users ON users.id = balances.user_id
JOIN coins ON coins.id = balances.coin_id;
CREATE OR REPLACE FUNCTION fn_update_balance_after_tx()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Intentamos insertar una fila nueva en balances
    INSERT INTO balances (user_id, coin_id, amount)
    VALUES (NEW.user_id, NEW.coin_id, NEW.amount)
    -- 2. Si ya existe la combinación (user_id, coin_id), saltamos al UPDATE
    ON CONFLICT (user_id, coin_id)
    DO UPDATE SET 
        amount = balances.amount + EXCLUDED.amount;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_sync_balances
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION fn_update_balance_after_tx();