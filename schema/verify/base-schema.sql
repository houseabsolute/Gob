-- Verify Gob:base-schema on pg

BEGIN;

SELECT pg_catalog.has_table_privilege( 'user', 'select' );
SELECT pg_catalog.has_table_privilege( 'resume', 'select' );
SELECT pg_catalog.has_table_privilege( 'posting', 'select' );
SELECT pg_catalog.has_table_privilege( 'flow', 'select' );
SELECT pg_catalog.has_table_privilege( 'flow_step', 'select' );
SELECT pg_catalog.has_table_privilege( 'application', 'select' );
SELECT pg_catalog.has_table_privilege( 'application_flow_step', 'select' );

ROLLBACK;
