CREATE TYPE address AS (
  street TEXT,
  state CHAR(2),
  country VARCHAR(50),
  zip_code VARCHAR(10)
);

CREATE TABLE clients (
  _id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE,
  time_zone VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  _id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_id INT REFERENCES clients(_id) NOT NULL,
  UNIQUE(name, client_id)
);

CREATE TABLE inventory (
  _id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT,
  sku VARCHAR(50) NOT NULL DEFAULT _id,
  category_id INT REFERENCES categories(_id),

  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_id INT REFERENCES clients(_id) NOT NULL,
  UNIQUE(sku, client_id)
);

CREATE TABLE users (
  _id SERIAL PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password CHAR(60) NOT NULL,
  -- add roles in the future
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_id INT REFERENCES clients(_id) NOT NULL
);

CREATE TABLE customers (
  _id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  user_id INT REFERENCES users(_id),
  email VARCHAR(50) UNIQUE,
  -- student, alumni, etc.
  type VARCHAR(30) NOT NULL,
  student_id VARCHAR(50) UNIQUE,
  phone_number CHAR(10) UNIQUE CHECK(phone_number ~ '[0-9]{10}'),
  address ADDRESS,
  birth_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_id INT REFERENCES clients(_id) NOT NULL
);

CREATE TABLE reservations (
  _id SERIAL PRIMARY KEY,
  inventory_id INT REFERENCES inventory(_id) NOT NULL,
  customer_id INT REFERENCES customers(_id) NOT NULL,
  user_id INT REFERENCES users(_id) NOT NULL,
  start_timestamp TIMESTAMPTZ NOT NULL,
  end_timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_id INT REFERENCES clients(_id) NOT NULL
);

-- make reservation group table
