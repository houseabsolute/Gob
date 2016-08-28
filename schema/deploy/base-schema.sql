-- Deploy Gob:baseschema to pg

BEGIN;

CREATE EXTENSION citext;
CREATE EXTENSION "uuid-ossp";

CREATE DOMAIN email AS citext CHECK ( VALUE ~ '^[^@]+@[\w_\-]+(\.[\w_\-]+)+$' );

CREATE DOMAIN web_uri AS text CHECK ( VALUE ~ '^https?://[\w_\-]+(\.[\w_\-]+)+/.*$' );

CREATE TABLE "user" (
    user_id       UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    email         email     UNIQUE NOT NULL,
    password      CHAR(31)  NOT NULL,
    name          citext    NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now()
);

CREATE TABLE resume (
    resume_id     UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id       UUID      NOT NULL REFERENCES "user" (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    uri           web_uri   DEFAULT '',
    file          TEXT      DEFAULT '',
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now(),
    CONSTRAINT has_uri_or_file CHECK ( uri != '' OR file != '' )
);

CREATE TABLE posting (
    posting_id    UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    title         citext    NOT NULL,
    description   TEXT      NOT NULL,
    flow          JSONB     NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now()
);

CREATE TABLE application (
    user_id       UUID      NOT NULL REFERENCES "user" (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    posting_id    UUID      NOT NULL REFERENCES posting (posting_id) ON DELETE CASCADE ON UPDATE CASCADE,
    cover_letter  TEXT      NOT NULL,
    resume        UUID      NOT NULL,
    state         JSONB     NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now()
);


COMMIT;
