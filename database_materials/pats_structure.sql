-- TABLE STRUCTURE FOR PATS DATABASE
--
--

CREATE TABLE animal_medicines (
    id SERIAL PRIMARY KEY,
    animal_id integer,
    medicine_id integer,
    recommended_num_of_units integer
);


CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name character varying(255) NOT NULL,
    active boolean DEFAULT true
);


CREATE TABLE medicine_costs (
    id SERIAL PRIMARY KEY,
    medicine_id integer,
    cost_per_unit integer,
    start_date date NOT NULL,
    end_date date
);


CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    stock_amount integer NOT NULL,
    method character varying(255) NOT NULL,
    unit character varying(255) NOT NULL,
    vaccine boolean DEFAULT false
);


CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    notable_type character varying(255),
    notable_id integer,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    user_id integer,
    date date NOT NULL
);


CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    street character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    zip character varying(255) NOT NULL,
    phone character varying(255),
    email character varying(255),
    active boolean DEFAULT true,
    state character varying(255) DEFAULT 'PA'::character varying
);


CREATE TABLE pets (
    id SERIAL PRIMARY KEY,
    animal_id integer,
    owner_id integer,
    name character varying(255) NOT NULL,
    female boolean NOT NULL,
    date_of_birth date,
    active boolean DEFAULT true
);


CREATE TABLE procedure_costs (
    id SERIAL PRIMARY KEY,
    procedure_id integer,
    cost integer NOT NULL,
    start_date date NOT NULL,
    end_date date
);


CREATE TABLE procedures (
    id SERIAL PRIMARY KEY,
    name character varying(255) NOT NULL,
    description text,
    length_of_time integer NOT NULL,
    active boolean DEFAULT true
);


CREATE TABLE treatments (
    id SERIAL PRIMARY KEY,
    visit_id integer,
    procedure_id integer,
    successful boolean,
    discount numeric(4,2) DEFAULT 0.0
);


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username character varying(255) NOT NULL UNIQUE,
    role character varying(255) NOT NULL,
    password_digest character varying(255),
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    active boolean DEFAULT true
);


CREATE TABLE visit_medicines (
    id SERIAL PRIMARY KEY,
    visit_id integer,
    medicine_id integer,
    units_given integer,
    discount numeric(4,2) DEFAULT 0.0
);


CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    pet_id integer,
    date date NOT NULL,
    weight integer,
    overnight_stay boolean,
    total_charge integer
);

