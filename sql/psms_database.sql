-- ============================================================
-- Pakistan Stock Market Simulator — MySQL Database Schema
-- Normalized to Third Normal Form (3NF)
-- Matches ERD Diagram
-- ============================================================

DROP DATABASE IF EXISTS psms_db;
CREATE DATABASE psms_db;
USE psms_db;

-- ============================================================
-- TABLE 1: users
-- Central entity. PK: user_id
-- ============================================================
CREATE TABLE users (
    user_id   INT AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(50)  NOT NULL UNIQUE,
    password  VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 2: sectors (3NF normalization — removes transitive
-- dependency from stocks on sector details)
-- ============================================================
CREATE TABLE sectors (
    sector_id   INT AUTO_INCREMENT PRIMARY KEY,
    sector_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500) NULL
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 3: stocks
-- PK: symbol  |  FK: sector_id → sectors
-- ============================================================
CREATE TABLE stocks (
    symbol         VARCHAR(10) PRIMARY KEY,
    company_name   VARCHAR(200) NOT NULL,
    sector_id      INT          NOT NULL,
    current_price  DOUBLE       NOT NULL,
    previous_close DOUBLE       NOT NULL,
    day_open       DOUBLE       NOT NULL,
    volume         BIGINT       NOT NULL DEFAULT 0,
    FOREIGN KEY (sector_id) REFERENCES sectors(sector_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 4: portfolios
-- One per user.  FK: user_id → users
-- ============================================================
CREATE TABLE portfolios (
    portfolio_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT    NOT NULL UNIQUE,
    current_balance DOUBLE NOT NULL DEFAULT 1000000.00,
    initial_balance DOUBLE NOT NULL DEFAULT 1000000.00,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 5: holdings
-- Stocks held inside a portfolio.
-- FK: portfolio_id → portfolios,  stock_symbol → stocks
-- ============================================================
CREATE TABLE holdings (
    holding_id      INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id    INT         NOT NULL,
    stock_symbol    VARCHAR(10) NOT NULL,
    quantity        INT         NOT NULL DEFAULT 0,
    average_buy_price DOUBLE    NOT NULL DEFAULT 0.0,
    UNIQUE KEY uk_portfolio_stock (portfolio_id, stock_symbol),
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (stock_symbol) REFERENCES stocks(symbol)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 6: trade_history
-- Every buy/sell executed by a user.
-- FK: user_id → users,  stock_symbol → stocks
-- ============================================================
CREATE TABLE trade_history (
    trade_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT         NOT NULL,
    stock_symbol    VARCHAR(10) NOT NULL,
    action          ENUM('BUY','SELL') NOT NULL,
    quantity        INT         NOT NULL,
    execution_price DOUBLE      NOT NULL,
    trade_timestamp DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (stock_symbol) REFERENCES stocks(symbol)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_user_trades (user_id, trade_timestamp)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 7: watchlists
-- Composite key (user_id, stock_symbol).
-- FK: user_id → users,  stock_symbol → stocks
-- ============================================================
CREATE TABLE watchlists (
    user_id      INT         NOT NULL,
    stock_symbol VARCHAR(10) NOT NULL,
    added_at     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, stock_symbol),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (stock_symbol) REFERENCES stocks(symbol)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 8: price_alerts
-- FK: user_id → users,  stock_symbol → stocks
-- ============================================================
CREATE TABLE price_alerts (
    alert_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT         NOT NULL,
    stock_symbol    VARCHAR(10) NOT NULL,
    alert_condition ENUM('ABOVE','BELOW') NOT NULL,
    threshold_price DOUBLE      NOT NULL,
    is_triggered    TINYINT(1)  NOT NULL DEFAULT 0,
    created_at      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (stock_symbol) REFERENCES stocks(symbol)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 9: chat_messages
-- FK: user_id → users
-- ============================================================
CREATE TABLE chat_messages (
    message_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT  NOT NULL,
    message_text TEXT NOT NULL,
    message_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_chat_time (message_time)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 10: reviews
-- FK: user_id → users
-- ============================================================
CREATE TABLE reviews (
    review_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT  NOT NULL,
    rating           INT  NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment          TEXT NULL,
    review_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 11: support_tickets
-- FK: user_id → users
-- ============================================================
CREATE TABLE support_tickets (
    ticket_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT          NOT NULL,
    subject          VARCHAR(200) NOT NULL,
    message          TEXT         NOT NULL,
    status           ENUM('OPEN','IN_PROGRESS','CLOSED') NOT NULL DEFAULT 'OPEN',
    ticket_timestamp DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_user_tickets (user_id, status)
) ENGINE=InnoDB;

-- ============================================================
-- TABLE 12: transactions
-- Wallet deposit/withdraw.  FK: portfolio_id → portfolios
-- ============================================================
CREATE TABLE transactions (
    transaction_id        INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id          INT NOT NULL,
    transaction_type      ENUM('DEPOSIT','WITHDRAW') NOT NULL,
    amount                DOUBLE   NOT NULL,
    transaction_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA: Sectors
-- ============================================================
INSERT INTO sectors (sector_name, description) VALUES
('Energy',       'Oil, gas, and power generation companies'),
('Banking',      'Commercial and investment banking institutions'),
('Cement',       'Cement manufacturing and construction materials'),
('Fertilizer',   'Fertilizer production and agricultural chemicals'),
('Technology',   'Information technology and software services'),
('Conglomerate', 'Diversified industrial conglomerates'),
('Textile',      'Textile mills and apparel manufacturers'),
('Automobile',   'Automobile assemblers and parts manufacturers'),
('Pharma',       'Pharmaceutical and healthcare companies'),
('Telecom',      'Telecommunications service providers');

-- ============================================================
-- SEED DATA: Stocks (20 PSX-listed companies)
-- ============================================================
INSERT INTO stocks (symbol, company_name, sector_id, current_price, previous_close, day_open, volume) VALUES
('ENGRO','Engro Corporation',         6, 268.50, 265.00, 266.00, 1250000),
('OGDC', 'Oil & Gas Development',     1,  89.75,  88.50,  89.00, 3400000),
('HBL',  'Habib Bank Limited',        2, 112.30, 110.00, 111.00, 2100000),
('LUCK', 'Lucky Cement',              3, 485.00, 480.00, 482.00,  980000),
('PPL',  'Pakistan Petroleum',        1,  72.40,  71.00,  71.50, 1800000),
('PSO',  'Pakistan State Oil',        1, 195.60, 193.00, 194.00, 1500000),
('FFC',  'Fauji Fertilizer',          4, 108.25, 107.00, 107.50, 2200000),
('HUBC', 'Hub Power Company',         1,  78.90,  77.50,  78.00, 1900000),
('UBL',  'United Bank Limited',       2, 143.50, 141.00, 142.00, 1700000),
('MCB',  'MCB Bank Limited',          2, 178.00, 175.50, 176.00, 1300000),
('EFERT','Engro Fertilizers',         4,  65.30,  64.00,  64.50, 2800000),
('BAHL', 'Bank Al Habib',             2,  58.75,  57.50,  58.00, 1600000),
('MEBL', 'Meezan Bank',              2, 145.60, 143.00, 144.00, 2000000),
('SYS',  'Systems Limited',           5, 398.00, 392.00, 395.00,  750000),
('TRG',  'TRG Pakistan',              5,  85.20,  83.50,  84.00, 1100000),
('DGKC', 'DG Khan Cement',            3,  68.50,  67.00,  67.50, 2400000),
('NML',  'Nishat Mills Limited',       7, 112.00, 110.50, 111.00, 1000000),
('INDU', 'Indus Motor Company',        8, 1285.00,1270.00,1275.00, 320000),
('SEARL','Searle Company',             9, 245.00, 242.00, 243.00,  680000),
('PTC',  'Pakistan Telecom',          10,   8.50,   8.30,   8.40, 5200000);
