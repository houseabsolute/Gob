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
    user_id       UUID      NOT NULL,
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
    user_id       UUID      NOT NULL,
    flow_id       UUID      NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now()
);

CREATE TABLE flow (
    flow_id       UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    title         citext    NOT NULL,
    user_id       UUID      NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now()
);

CREATE TYPE step_type AS ENUM ( 'Review', 'Questionnaire', 'Interview', 'Reference Checking' );

CREATE TABLE flow_step (
    flow_step_id  UUID      PRIMARY KEY DEFAULT uuid_generate_v4(),
    flow_id       UUID      NOT NULL,
    step_order    INT       NOT NULL,
    step_type     step_type NOT NULL,
    title         citext    NOT NULL,
    body          JSONB     NOT NULL,
    user_id       UUID      NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now(),
    UNIQUE (flow_id, step_order)
);

CREATE TABLE application (
    application_id  UUID    PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id       UUID      NOT NULL,
    posting_id    UUID      NOT NULL,
    cover_letter  TEXT      NOT NULL,
    resume        UUID      NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT now(),
    last_updated_at  TIMESTAMPTZ  DEFAULT now(),
    UNIQUE (user_id, posting_id)
);

CREATE TABLE application_flow_step (
    application_id  UUID    NOT NULL,
    flow_step_id  UUID      NOT NULL,
    step_state    JSONB     NOT NULL,
    PRIMARY KEY (application_id, flow_step_id)
);

ALTER TABLE resume
    ADD CONSTRAINT resume_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES "user" (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE posting
    ADD CONSTRAINT posting_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES "user" (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE posting
    ADD CONSTRAINT posting_flow_id_fkey FOREIGN KEY (flow_id)
    REFERENCES flow (flow_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE flow
    ADD CONSTRAINT flow_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES "user" (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE flow_step
    ADD CONSTRAINT flow_step_flow_id_fkey FOREIGN KEY (flow_id)
    REFERENCES flow (flow_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE application
    ADD CONSTRAINT application_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES "user" (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE application
    ADD CONSTRAINT application_posting_id_fkey FOREIGN KEY (posting_id)
    REFERENCES posting (posting_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE application_flow_step
    ADD CONSTRAINT application_flow_step_application_id_fkey FOREIGN KEY (application_id)
    REFERENCES application (application_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

ALTER TABLE application_flow_step
    ADD CONSTRAINT application_flow_step_flow_step_id_fkey FOREIGN KEY (flow_step_id)
    REFERENCES flow_step (flow_step_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE;

COMMIT;
