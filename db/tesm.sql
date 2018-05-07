DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS schools;
DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(255) NOT NULL,
  image_url VARCHAR(255) NOT NULL
);

CREATE TABLE schools(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  icon_url VARCHAR(255) NOT NULL
);

CREATE TABLE items(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  buy_price INT4 NOT NULL
  CONSTRAINT positive_buy_price CHECK (buy_price >= 0),
  sell_price INT4 NOT NULL
  CONSTRAINT positive_sell_price CHECK (sell_price >= 0),
  school_id INT4 NOT NULL REFERENCES schools(id) ON DELETE CASCADE,
  supplier_id INT4 NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE
);

CREATE TABLE inventory(
  id SERIAL4 PRIMARY KEY,
  item_id INT4 UNIQUE NOT NULL REFERENCES items(id),
  quantity INT4 NOT NULL
  CONSTRAINT positive_quantity CHECK (quantity >= 0)
);
