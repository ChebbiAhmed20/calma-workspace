DROP DATABASE IF EXISTS calma_workspace;  -- erases local data
CREATE DATABASE calma_workspace CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE calma_workspace;

CREATE TABLE `user` (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    role          ENUM('MANAGER','TRACKING_AGENT','PAYMENT_AGENT','CLIENT') NOT NULL
);

CREATE TABLE client (
    user_id     INT PRIMARY KEY,
    client_type ENUM('STUDENT','SECONDARY_STUDENT','DEVELOPER','ENTREPRENEUR') NOT NULL,
    birth_date  DATE,
    FOREIGN KEY (user_id) REFERENCES `user`(id) ON DELETE CASCADE
);

CREATE TABLE manager (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(id) ON DELETE CASCADE
);

CREATE TABLE tracking_agent (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(id) ON DELETE CASCADE
);

CREATE TABLE payment_agent (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(id) ON DELETE CASCADE
);

CREATE TABLE salle (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL UNIQUE,
    type     ENUM('INDIVIDUAL','GROUP','MEETING','TRAINING') NOT NULL,
    capacity INT NOT NULL,
    CHECK (capacity > 0)
);

CREATE TABLE reservation (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    client_id        INT NOT NULL,
    salle_id         INT NOT NULL,
    purpose          ENUM('PERSONAL_REVISION','PERSONAL_TASK','MEETING','GROUP_TRAINING') NOT NULL,
    reservation_date DATE NOT NULL,
    start_time       TIME NOT NULL,
    end_time         TIME NOT NULL,
    nb_people        INT  NOT NULL DEFAULT 1,
    billing_mode     ENUM('HOURLY','DAILY') NOT NULL DEFAULT 'HOURLY',
    total_price      DECIMAL(10,2) NOT NULL DEFAULT 0,
    status           ENUM('PENDING','CONFIRMED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
    CHECK (end_time > start_time),
    CHECK (nb_people > 0),
    FOREIGN KEY (client_id) REFERENCES client(user_id),
    FOREIGN KEY (salle_id)  REFERENCES salle(id),
    UNIQUE KEY uq_res_id_client (id, client_id),
    INDEX idx_res_salle_date (salle_id, reservation_date)
);

CREATE TABLE payment (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE,
    client_id      INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    method         ENUM('ONLINE_CARD','CASH','TRANSFER') NOT NULL DEFAULT 'ONLINE_CARD',
    status         ENUM('PENDING','PAID','FAILED','REFUNDED') NOT NULL DEFAULT 'PENDING',
    paid_at        DATETIME NULL,
    receipt_number VARCHAR(30) NULL UNIQUE,
    CHECK (amount > 0),
    FOREIGN KEY (client_id) REFERENCES client(user_id),
    -- the payer must be the client who made the reservation
    FOREIGN KEY (reservation_id, client_id) REFERENCES reservation(id, client_id)
);
