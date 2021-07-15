--
-- PostgreSQL database dump
--

-- Dumped from database version 12.6
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.votingphases DROP CONSTRAINT fk_votingphases_phase_type_id_voting_phase_types;
ALTER TABLE ONLY public.votingphases DROP CONSTRAINT fk_votingphases_department_id_departments;
ALTER TABLE ONLY public.userprofiles DROP CONSTRAINT fk_userprofiles_id_users;
ALTER TABLE ONLY public.userpassword DROP CONSTRAINT fk_userpassword_user_id_users;
ALTER TABLE ONLY public.user_login_token DROP CONSTRAINT fk_user_login_token_user_id_users;
ALTER TABLE ONLY public.urnsupporters DROP CONSTRAINT fk_urnsupporters_urn_id_urns;
ALTER TABLE ONLY public.urnsupporters DROP CONSTRAINT fk_urnsupporters_member_id_users;
ALTER TABLE ONLY public.urns DROP CONSTRAINT fk_urns_voting_id_votingphases;
ALTER TABLE ONLY public.tags DROP CONSTRAINT fk_tags_parent_id_tags;
ALTER TABLE ONLY public.supporters DROP CONSTRAINT fk_supporters_proposition_id_propositions;
ALTER TABLE ONLY public.supporters DROP CONSTRAINT fk_supporters_member_id_users;
ALTER TABLE ONLY public.subjectareas DROP CONSTRAINT fk_subjectareas_department_id_departments;
ALTER TABLE ONLY public.secretvoters DROP CONSTRAINT fk_secretvoters_member_id_users;
ALTER TABLE ONLY public.secretvoters DROP CONSTRAINT fk_secretvoters_ballot_id_ballots;
ALTER TABLE ONLY public.propositiontypes DROP CONSTRAINT fk_propositiontypes_policy_id_policies;
ALTER TABLE ONLY public.propositiontags DROP CONSTRAINT fk_propositiontags_tag_id_tags;
ALTER TABLE ONLY public.propositiontags DROP CONSTRAINT fk_propositiontags_proposition_id_propositions;
ALTER TABLE ONLY public.propositions DROP CONSTRAINT fk_propositions_replaces_id_propositions;
ALTER TABLE ONLY public.propositions DROP CONSTRAINT fk_propositions_modifies_id_propositions;
ALTER TABLE ONLY public.propositions DROP CONSTRAINT fk_propositions_ballot_id_ballots;
ALTER TABLE ONLY public.propositions DROP CONSTRAINT fk_propositions_author_id_users;
ALTER TABLE ONLY public.propositionnotes DROP CONSTRAINT fk_propositionnotes_user_id_users;
ALTER TABLE ONLY public.propositionnotes DROP CONSTRAINT fk_propositionnotes_proposition_id_propositions;
ALTER TABLE ONLY public.postalvotes DROP CONSTRAINT fk_postalvotes_voting_id_votingphases;
ALTER TABLE ONLY public.postalvotes DROP CONSTRAINT fk_postalvotes_member_id_users;
ALTER TABLE ONLY public.oauth_token DROP CONSTRAINT fk_oauth_token_id_users;
ALTER TABLE ONLY public.groupmembers DROP CONSTRAINT fk_groupmembers_member_id_users;
ALTER TABLE ONLY public.groupmembers DROP CONSTRAINT fk_groupmembers_group_id_groups;
ALTER TABLE ONLY public.document DROP CONSTRAINT fk_document_proposition_type_id_propositiontypes;
ALTER TABLE ONLY public.document DROP CONSTRAINT fk_document_area_id_subjectareas;
ALTER TABLE ONLY public.departmentmembers DROP CONSTRAINT fk_departmentmembers_member_id_users;
ALTER TABLE ONLY public.departmentmembers DROP CONSTRAINT fk_departmentmembers_department_id_departments;
ALTER TABLE ONLY public.changeset DROP CONSTRAINT fk_changeset_proposition_id_propositions;
ALTER TABLE ONLY public.changeset DROP CONSTRAINT fk_changeset_document_id_document;
ALTER TABLE ONLY public.ballots DROP CONSTRAINT fk_ballots_voting_id_votingphases;
ALTER TABLE ONLY public.ballots DROP CONSTRAINT fk_ballots_proposition_type_id_propositiontypes;
ALTER TABLE ONLY public.ballots DROP CONSTRAINT fk_ballots_area_id_subjectareas;
ALTER TABLE ONLY public.argumentvotes DROP CONSTRAINT fk_argumentvotes_relation_id_argumentrelations;
ALTER TABLE ONLY public.argumentvotes DROP CONSTRAINT fk_argumentvotes_member_id_users;
ALTER TABLE ONLY public.arguments DROP CONSTRAINT fk_arguments_author_id_users;
ALTER TABLE ONLY public.argumentrelations DROP CONSTRAINT fk_argumentrelations_proposition_id_propositions;
ALTER TABLE ONLY public.argumentrelations DROP CONSTRAINT fk_argumentrelations_parent_id_argumentrelations;
ALTER TABLE ONLY public.argumentrelations DROP CONSTRAINT fk_argumentrelations_argument_id_arguments;
ALTER TABLE ONLY public.areamembers DROP CONSTRAINT fk_areamembers_member_id_users;
ALTER TABLE ONLY public.areamembers DROP CONSTRAINT fk_areamembers_area_id_subjectareas;
DROP TRIGGER propositions_search_vector_trigger ON public.propositions;
DROP INDEX public.ix_propositions_search_vector;
ALTER TABLE ONLY public.voting_module DROP CONSTRAINT uq_voting_module_name;
ALTER TABLE ONLY public.users DROP CONSTRAINT uq_users_name;
ALTER TABLE ONLY public.users DROP CONSTRAINT uq_users_email;
ALTER TABLE ONLY public.userprofiles DROP CONSTRAINT uq_userprofiles_sub;
ALTER TABLE ONLY public.tags DROP CONSTRAINT uq_tags_name;
ALTER TABLE ONLY public.propositiontypes DROP CONSTRAINT uq_propositiontypes_name;
ALTER TABLE ONLY public.propositiontypes DROP CONSTRAINT uq_propositiontypes_abbreviation;
ALTER TABLE ONLY public.policies DROP CONSTRAINT uq_policies_name;
ALTER TABLE ONLY public.groups DROP CONSTRAINT uq_groups_name;
ALTER TABLE ONLY public.document DROP CONSTRAINT uq_document_name;
ALTER TABLE ONLY public.departments DROP CONSTRAINT uq_departments_name;
ALTER TABLE ONLY public.votingphases DROP CONSTRAINT pk_votingphases;
ALTER TABLE ONLY public.voting_phase_types DROP CONSTRAINT pk_voting_phase_types;
ALTER TABLE ONLY public.voting_module DROP CONSTRAINT pk_voting_module;
ALTER TABLE ONLY public.users DROP CONSTRAINT pk_users;
ALTER TABLE ONLY public.userprofiles DROP CONSTRAINT pk_userprofiles;
ALTER TABLE ONLY public.userpassword DROP CONSTRAINT pk_userpassword;
ALTER TABLE ONLY public.user_login_token DROP CONSTRAINT pk_user_login_token;
ALTER TABLE ONLY public.urnsupporters DROP CONSTRAINT pk_urnsupporters;
ALTER TABLE ONLY public.urns DROP CONSTRAINT pk_urns;
ALTER TABLE ONLY public.tags DROP CONSTRAINT pk_tags;
ALTER TABLE ONLY public.supporters DROP CONSTRAINT pk_supporters;
ALTER TABLE ONLY public.subjectareas DROP CONSTRAINT pk_subjectareas;
ALTER TABLE ONLY public.secretvoters DROP CONSTRAINT pk_secretvoters;
ALTER TABLE ONLY public.propositiontypes DROP CONSTRAINT pk_propositiontypes;
ALTER TABLE ONLY public.propositiontags DROP CONSTRAINT pk_propositiontags;
ALTER TABLE ONLY public.propositions DROP CONSTRAINT pk_propositions;
ALTER TABLE ONLY public.propositionnotes DROP CONSTRAINT pk_propositionnotes;
ALTER TABLE ONLY public.postalvotes DROP CONSTRAINT pk_postalvotes;
ALTER TABLE ONLY public.policies DROP CONSTRAINT pk_policies;
ALTER TABLE ONLY public.page DROP CONSTRAINT pk_page;
ALTER TABLE ONLY public.oauth_token DROP CONSTRAINT pk_oauth_token;
ALTER TABLE ONLY public.groups DROP CONSTRAINT pk_groups;
ALTER TABLE ONLY public.groupmembers DROP CONSTRAINT pk_groupmembers;
ALTER TABLE ONLY public.document DROP CONSTRAINT pk_document;
ALTER TABLE ONLY public.departments DROP CONSTRAINT pk_departments;
ALTER TABLE ONLY public.departmentmembers DROP CONSTRAINT pk_departmentmembers;
ALTER TABLE ONLY public.customizable_text DROP CONSTRAINT pk_customizable_text;
ALTER TABLE ONLY public.changeset DROP CONSTRAINT pk_changeset;
ALTER TABLE ONLY public.ballots DROP CONSTRAINT pk_ballots;
ALTER TABLE ONLY public.argumentvotes DROP CONSTRAINT pk_argumentvotes;
ALTER TABLE ONLY public.arguments DROP CONSTRAINT pk_arguments;
ALTER TABLE ONLY public.argumentrelations DROP CONSTRAINT pk_argumentrelations;
ALTER TABLE ONLY public.areamembers DROP CONSTRAINT pk_areamembers;
ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
DROP TABLE public.votingphases;
DROP TABLE public.voting_phase_types;
DROP TABLE public.voting_module;
DROP TABLE public.users;
DROP TABLE public.userprofiles;
DROP TABLE public.userpassword;
DROP TABLE public.user_login_token;
DROP TABLE public.urnsupporters;
DROP TABLE public.urns;
DROP TABLE public.tags;
DROP TABLE public.supporters;
DROP TABLE public.subjectareas;
DROP TABLE public.secretvoters;
DROP TABLE public.propositiontypes;
DROP TABLE public.propositiontags;
DROP TABLE public.propositions;
DROP TABLE public.propositionnotes;
DROP TABLE public.postalvotes;
DROP TABLE public.policies;
DROP TABLE public.page;
DROP TABLE public.oauth_token;
DROP TABLE public.groups;
DROP TABLE public.groupmembers;
DROP TABLE public.document;
DROP TABLE public.departments;
DROP TABLE public.departmentmembers;
DROP TABLE public.customizable_text;
DROP TABLE public.changeset;
DROP TABLE public.ballots;
DROP TABLE public.argumentvotes;
DROP TABLE public.arguments;
DROP TABLE public.argumentrelations;
DROP TABLE public.areamembers;
DROP TABLE public.alembic_version;
DROP FUNCTION public.uuid_timestamp(uuid uuid);
DROP FUNCTION public.tsq_tokenize_character(state public.tsq_state);
DROP FUNCTION public.tsq_tokenize(search_query text);
DROP FUNCTION public.tsq_process_tokens(config regconfig, tokens text[]);
DROP FUNCTION public.tsq_process_tokens(tokens text[]);
DROP FUNCTION public.tsq_parse(config text, search_query text);
DROP FUNCTION public.tsq_parse(config regconfig, search_query text);
DROP FUNCTION public.tsq_parse(search_query text);
DROP FUNCTION public.tsq_append_current_token(state public.tsq_state);
DROP FUNCTION public.propositions_search_vector_update();
DROP FUNCTION public.generate_uuid0();
DROP FUNCTION public.generate_ulid();
DROP FUNCTION public.array_nremove(anyarray, anyelement, integer);
DROP TYPE public.votingtype;
DROP TYPE public.votingsystem;
DROP TYPE public.votingstatus;
DROP TYPE public.votebyuser;
DROP TYPE public.tsq_state;
DROP TYPE public.supporterstatus;
DROP TYPE public.secretvoterstatus;
DROP TYPE public.propositionvisibility;
DROP TYPE public.propositionstatus;
DROP TYPE public.majority;
DROP TYPE public.argumenttype;
DROP EXTENSION "uuid-ossp";
DROP EXTENSION pgcrypto;
--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: argumenttype; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.argumenttype AS ENUM (
    'PRO',
    'CONTRA'
);


--
-- Name: majority; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.majority AS ENUM (
    'SIMPLE',
    'TWO_THIRDS'
);


--
-- Name: propositionstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.propositionstatus AS ENUM (
    'DRAFT',
    'SUBMITTED',
    'CHANGING',
    'ABANDONED',
    'QUALIFIED',
    'SCHEDULED',
    'VOTING',
    'FINISHED'
);


--
-- Name: propositionvisibility; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.propositionvisibility AS ENUM (
    'PUBLIC',
    'UNLISTED',
    'HIDDEN'
);


--
-- Name: secretvoterstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.secretvoterstatus AS ENUM (
    'ACTIVE',
    'EXPIRED',
    'RETRACTED'
);


--
-- Name: supporterstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.supporterstatus AS ENUM (
    'ACTIVE',
    'EXPIRED',
    'RETRACTED'
);


--
-- Name: tsq_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tsq_state AS (
	search_query text,
	parentheses_stack integer,
	skip_for integer,
	current_token text,
	current_index integer,
	current_char text,
	previous_char text,
	tokens text[]
);


--
-- Name: votebyuser; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.votebyuser AS ENUM (
    'UNSURE',
    'ACCEPT',
    'DECLINE',
    'ABSTENTION'
);


--
-- Name: votingstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.votingstatus AS ENUM (
    'PREPARING',
    'VOTING',
    'FINISHED',
    'ABORTED'
);


--
-- Name: votingsystem; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.votingsystem AS ENUM (
    'RANGE_APPROVAL'
);


--
-- Name: votingtype; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.votingtype AS ENUM (
    'ONLINE',
    'ASSEMBLY',
    'BOARD',
    'URN'
);


--
-- Name: array_nremove(anyarray, anyelement, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.array_nremove(anyarray, anyelement, integer) RETURNS anyarray
    LANGUAGE sql IMMUTABLE
    AS $_$
    WITH replaced_positions AS (
        SELECT UNNEST(
            CASE
            WHEN $2 IS NULL THEN
                '{}'::int[]
            WHEN $3 > 0 THEN
                (array_positions($1, $2))[1:$3]
            WHEN $3 < 0 THEN
                (array_positions($1, $2))[
                    (cardinality(array_positions($1, $2)) + $3 + 1):
                ]
            ELSE
                '{}'::int[]
            END
        ) AS position
    )
    SELECT COALESCE((
        SELECT array_agg(value)
        FROM unnest($1) WITH ORDINALITY AS t(value, index)
        WHERE index NOT IN (SELECT position FROM replaced_positions)
    ), $1[1:0]);
$_$;


--
-- Name: generate_ulid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_ulid() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  -- Crockford's Base32
  encoding   BYTEA = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  timestamp  BYTEA = E'\\000\\000\\000\\000\\000\\000';
  output     TEXT = '';

  unix_time  BIGINT;
  ulid       BYTEA;
BEGIN
  -- 6 timestamp bytes
  unix_time = (EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT;
  timestamp = SET_BYTE(timestamp, 0, (unix_time >> 40)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 1, (unix_time >> 32)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 2, (unix_time >> 24)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 3, (unix_time >> 16)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 4, (unix_time >> 8)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 5, unix_time::BIT(8)::INTEGER);

  -- 10 entropy bytes
  ulid = timestamp || gen_random_bytes(10);

  -- Encode the timestamp
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 0) & 224) >> 5));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 0) & 31)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 1) & 248) >> 3));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 1) & 7) << 2) | ((GET_BYTE(ulid, 2) & 192) >> 6)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 2) & 62) >> 1));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 2) & 1) << 4) | ((GET_BYTE(ulid, 3) & 240) >> 4)));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 3) & 15) << 1) | ((GET_BYTE(ulid, 4) & 128) >> 7)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 4) & 124) >> 2));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 4) & 3) << 3) | ((GET_BYTE(ulid, 5) & 224) >> 5)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 5) & 31)));

  -- Encode the entropy
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 6) & 248) >> 3));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 6) & 7) << 2) | ((GET_BYTE(ulid, 7) & 192) >> 6)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 7) & 62) >> 1));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 7) & 1) << 4) | ((GET_BYTE(ulid, 8) & 240) >> 4)));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 8) & 15) << 1) | ((GET_BYTE(ulid, 9) & 128) >> 7)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 9) & 124) >> 2));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 9) & 3) << 3) | ((GET_BYTE(ulid, 10) & 224) >> 5)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 10) & 31)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 11) & 248) >> 3));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 11) & 7) << 2) | ((GET_BYTE(ulid, 12) & 192) >> 6)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 12) & 62) >> 1));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 12) & 1) << 4) | ((GET_BYTE(ulid, 13) & 240) >> 4)));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 13) & 15) << 1) | ((GET_BYTE(ulid, 14) & 128) >> 7)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 14) & 124) >> 2));
  output = output || CHR(GET_BYTE(encoding, ((GET_BYTE(ulid, 14) & 3) << 3) | ((GET_BYTE(ulid, 15) & 224) >> 5)));
  output = output || CHR(GET_BYTE(encoding, (GET_BYTE(ulid, 15) & 31)));

  RETURN output;
END
$$;


--
-- Name: generate_uuid0(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_uuid0() RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  timestamp  BYTEA = E'\\000\\000\\000\\000\\000\\000';

  unix_time  BIGINT;
  bytes       BYTEA;
BEGIN
  -- 6 timestamp bytes
  unix_time = (EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT;
  timestamp = SET_BYTE(timestamp, 0, (unix_time >> 40)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 1, (unix_time >> 32)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 2, (unix_time >> 24)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 3, (unix_time >> 16)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 4, (unix_time >> 8)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 5, unix_time::BIT(8)::INTEGER);

  -- 10 entropy bytes
  bytes = timestamp || gen_random_bytes(10);


  RETURN bytes::uuid;
END
$$;


--
-- Name: propositions_search_vector_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.propositions_search_vector_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                NEW.search_vector = (((setweight(to_tsvector('pg_catalog.german', coalesce(NEW.title, '')), 'A') || setweight(to_tsvector('pg_catalog.german', coalesce(NEW.abstract, '')), 'B')) || setweight(to_tsvector('pg_catalog.german', coalesce(NEW.content, '')), 'C')) || setweight(to_tsvector('pg_catalog.german', coalesce(NEW.motivation, '')), 'D')) || setweight(to_tsvector('pg_catalog.german', coalesce(NEW.voting_identifier, '')), 'A');
                RETURN NEW;
            END
            $$;


--
-- Name: tsq_append_current_token(public.tsq_state); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_append_current_token(state public.tsq_state) RETURNS public.tsq_state
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    IF state.current_token != '' THEN
        state.tokens := array_append(state.tokens, state.current_token);
        state.current_token := '';
    END IF;
    RETURN state;
END;
$$;


--
-- Name: tsq_parse(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_parse(search_query text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT tsq_parse(get_current_ts_config(), search_query);
$$;


--
-- Name: tsq_parse(regconfig, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_parse(config regconfig, search_query text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT tsq_process_tokens(config, tsq_tokenize(search_query));
$$;


--
-- Name: tsq_parse(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_parse(config text, search_query text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT tsq_parse(config::regconfig, search_query);
$$;


--
-- Name: tsq_process_tokens(text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_process_tokens(tokens text[]) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT tsq_process_tokens(get_current_ts_config(), tokens);
$$;


--
-- Name: tsq_process_tokens(regconfig, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_process_tokens(config regconfig, tokens text[]) RETURNS tsquery
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    result_query text;
    previous_value text;
    value text;
BEGIN
    result_query := '';

    FOREACH value IN ARRAY tokens LOOP
        IF value = '"' THEN
            CONTINUE;
        END IF;

        IF value = 'or' THEN
            value := ' | ';
        END IF;

        IF left(value, 1) = '"' AND right(value, 1) = '"' THEN
            value := phraseto_tsquery(config, value);
        ELSIF value NOT IN ('(', ' | ', ')', '-') THEN
            value := quote_literal(value) || ':*';
        END IF;

        IF previous_value = '-' THEN
            IF value = '(' THEN
                value := '!' || value;
            ELSIF value = ' | ' THEN
                CONTINUE;
            ELSE
                value := '!(' || value || ')';
            END IF;
        END IF;

        SELECT
            CASE
                WHEN result_query = '' THEN value
                WHEN previous_value = ' | ' AND value = ' | ' THEN result_query
                WHEN previous_value = ' | ' THEN result_query || ' | ' || value
                WHEN previous_value IN ('!(', '(') OR value = ')' THEN result_query || value
                WHEN value != ' | ' THEN result_query || ' & ' || value
                ELSE result_query
            END
        INTO result_query;

        IF result_query = ' | ' THEN
            result_query := '';
        END IF;

        previous_value := value;
    END LOOP;

    RETURN to_tsquery(config, result_query);
END;
$$;


--
-- Name: tsq_tokenize(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_tokenize(search_query text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    state tsq_state;
BEGIN
    SELECT
        search_query::text AS search_query,
        0::int AS parentheses_stack,
        0 AS skip_for,
        ''::text AS current_token,
        0 AS current_index,
        ''::text AS current_char,
        ''::text AS previous_char,
        '{}'::text[] AS tokens
    INTO state;

    state.search_query := lower(trim(
        regexp_replace(search_query, '""+', '""', 'g')
    ));

    FOR state.current_index IN (
        SELECT generate_series(1, length(state.search_query))
    ) LOOP
        state.current_char := substring(
            search_query FROM state.current_index FOR 1
        );

        IF state.skip_for > 0 THEN
            state.skip_for := state.skip_for - 1;
            CONTINUE;
        END IF;

        state := tsq_tokenize_character(state);
        state.previous_char := state.current_char;
    END LOOP;
    state := tsq_append_current_token(state);

    state.tokens := array_nremove(state.tokens, '(', -state.parentheses_stack);

    RETURN state.tokens;
END;
$$;


--
-- Name: tsq_tokenize_character(public.tsq_state); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tsq_tokenize_character(state public.tsq_state) RETURNS public.tsq_state
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    IF state.current_char = '(' THEN
        state.tokens := array_append(state.tokens, '(');
        state.parentheses_stack := state.parentheses_stack + 1;
        state := tsq_append_current_token(state);
    ELSIF state.current_char = ')' THEN
        IF (state.parentheses_stack > 0 AND state.current_token != '') THEN
            state := tsq_append_current_token(state);
            state.tokens := array_append(state.tokens, ')');
            state.parentheses_stack := state.parentheses_stack - 1;
        END IF;
    ELSIF state.current_char = '"' THEN
        state.skip_for := position('"' IN substring(
            state.search_query FROM state.current_index + 1
        ));

        IF state.skip_for > 1 THEN
            state.tokens = array_append(
                state.tokens,
                substring(
                    state.search_query
                    FROM state.current_index FOR state.skip_for + 1
                )
            );
        ELSIF state.skip_for = 0 THEN
            state.current_token := state.current_token || state.current_char;
        END IF;
    ELSIF (
        state.current_char = '-' AND
        (state.current_index = 1 OR state.previous_char = ' ')
    ) THEN
        state.tokens := array_append(state.tokens, '-');
    ELSIF state.current_char = ' ' THEN
        state := tsq_append_current_token(state);
    ELSE
        state.current_token = state.current_token || state.current_char;
    END IF;
    RETURN state;
END;
$$;


--
-- Name: uuid_timestamp(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.uuid_timestamp(uuid uuid) RETURNS timestamp with time zone
    LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
DECLARE
  bytes bytea; 
BEGIN
  bytes := uuid_send(uuid);
  RETURN to_timestamp(
             (
                 (
                   (get_byte(bytes, 0)::bigint << 24) |
                   (get_byte(bytes, 1)::bigint << 16) |
                   (get_byte(bytes, 2)::bigint <<  8) |
                   (get_byte(bytes, 3)::bigint <<  0)
                 ) + (
                   ((get_byte(bytes, 4)::bigint << 8 |
                   get_byte(bytes, 5)::bigint)) << 32
                 ) + (
                   (((get_byte(bytes, 6)::bigint & 15) << 8 | get_byte(bytes, 7)::bigint) & 4095) << 48
                 ) - 122192928000000000
             ) / 10000 / 1000::double precision
         );
END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: areamembers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areamembers (
    area_id integer NOT NULL,
    member_id integer NOT NULL
);


--
-- Name: argumentrelations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.argumentrelations (
    id integer NOT NULL,
    parent_id integer,
    argument_id integer,
    proposition_id bigint,
    argument_type public.argumenttype NOT NULL
);


--
-- Name: COLUMN argumentrelations.parent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.argumentrelations.parent_id IS 'only for inter-arguments';


--
-- Name: argumentrelations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.argumentrelations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.argumentrelations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: arguments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.arguments (
    id integer NOT NULL,
    title text NOT NULL,
    abstract text NOT NULL,
    details text,
    author_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: arguments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.arguments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.arguments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: argumentvotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.argumentvotes (
    member_id integer NOT NULL,
    relation_id integer NOT NULL,
    weight integer NOT NULL
);


--
-- Name: COLUMN argumentvotes.weight; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.argumentvotes.weight IS 'if extendedDiscussion: --(-2),-,0,+,++(+2) , otherwise -1 and +1';


--
-- Name: ballots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ballots (
    id integer NOT NULL,
    name text,
    election integer DEFAULT 0 NOT NULL,
    voting_type public.votingtype,
    proposition_type_id integer,
    area_id integer,
    voting_id integer,
    result jsonb
);


--
-- Name: ballots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.ballots ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ballots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: changeset; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.changeset (
    id integer NOT NULL,
    document_id integer NOT NULL,
    proposition_id bigint NOT NULL,
    section text
);


--
-- Name: COLUMN changeset.section; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.changeset.section IS 'Identifier for the section of the document that is changed.';


--
-- Name: changeset_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.changeset ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.changeset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customizable_text; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customizable_text (
    name text NOT NULL,
    lang text NOT NULL,
    text text,
    permissions json
);


--
-- Name: departmentmembers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departmentmembers (
    department_id integer NOT NULL,
    member_id integer NOT NULL,
    is_admin boolean DEFAULT false NOT NULL
);


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    exporter_settings jsonb DEFAULT '{}'::jsonb,
    voting_module_settings jsonb DEFAULT '{}'::jsonb
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.departments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document (
    id integer NOT NULL,
    name text,
    lang text,
    area_id integer,
    text text,
    description text,
    proposition_type_id integer
);


--
-- Name: document_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.document ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: groupmembers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groupmembers (
    group_id integer NOT NULL,
    member_id integer NOT NULL
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name text NOT NULL,
    is_admin_group boolean DEFAULT false NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: oauth_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_token (
    id integer NOT NULL,
    token json,
    provider text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: page; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page (
    name text NOT NULL,
    lang text NOT NULL,
    title text,
    text text,
    permissions json
);


--
-- Name: policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policies (
    id integer NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text,
    majority public.majority,
    proposition_expiration integer,
    qualification_minimum integer,
    qualification_quorum numeric(3,2),
    range_max integer,
    range_small_max integer,
    range_small_options integer,
    secret_minimum integer,
    secret_quorum numeric(3,2),
    submitter_minimum integer,
    voting_duration integer,
    voting_system public.votingsystem
);


--
-- Name: COLUMN policies.proposition_expiration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.proposition_expiration IS 'days to reach the qualification (supporter) quorum';


--
-- Name: COLUMN policies.qualification_minimum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.qualification_minimum IS 'minimum for qualification quorum';


--
-- Name: COLUMN policies.qualification_quorum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.qualification_quorum IS 'fraction of area members that must support a proposition for reaching the qualified state';


--
-- Name: COLUMN policies.range_max; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.range_max IS 'maximum score used when the number of options is at least `range_small_options`';


--
-- Name: COLUMN policies.range_small_max; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.range_small_max IS 'maximum score used when the number of options is less than `range_small_options`';


--
-- Name: COLUMN policies.range_small_options; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.range_small_options IS 'largest number of options for which `range_small_max` is used as maximum score';


--
-- Name: COLUMN policies.secret_minimum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.secret_minimum IS 'minimum for secret voting quorum';


--
-- Name: COLUMN policies.secret_quorum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.secret_quorum IS 'quorum to force a secret voting';


--
-- Name: COLUMN policies.submitter_minimum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.submitter_minimum IS 'minimum number of submitters for a proposition';


--
-- Name: COLUMN policies.voting_duration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.policies.voting_duration IS 'voting duration in days; ends at target date';


--
-- Name: policies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.policies ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: postalvotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.postalvotes (
    member_id integer NOT NULL,
    voting_id integer NOT NULL
);


--
-- Name: propositionnotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.propositionnotes (
    proposition_id bigint NOT NULL,
    user_id integer NOT NULL,
    notes text,
    vote public.votebyuser
);


--
-- Name: propositions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.propositions (
    id bigint NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    abstract text DEFAULT ''::text NOT NULL,
    motivation text DEFAULT ''::text NOT NULL,
    voting_identifier text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    submitted_at timestamp without time zone,
    qualified_at timestamp without time zone,
    status public.propositionstatus DEFAULT 'DRAFT'::public.propositionstatus NOT NULL,
    submitter_invitation_key text,
    author_id integer,
    ballot_id integer NOT NULL,
    modifies_id bigint,
    replaces_id bigint,
    external_discussion_url text,
    external_fields jsonb DEFAULT '{}'::jsonb,
    visibility public.propositionvisibility DEFAULT 'PUBLIC'::public.propositionvisibility NOT NULL,
    search_vector tsvector,
    CONSTRAINT ck_propositions_qualified_at_must_be_set CHECK (((qualified_at IS NOT NULL) OR (status = ANY (ARRAY['DRAFT'::public.propositionstatus, 'SUBMITTED'::public.propositionstatus, 'ABANDONED'::public.propositionstatus, 'CHANGING'::public.propositionstatus, 'FINISHED'::public.propositionstatus])))),
    CONSTRAINT ck_propositions_submitted_at_must_be_set CHECK (((submitted_at IS NOT NULL) OR (status = ANY (ARRAY['DRAFT'::public.propositionstatus, 'ABANDONED'::public.propositionstatus, 'CHANGING'::public.propositionstatus]))))
);


--
-- Name: COLUMN propositions.submitted_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.propositions.submitted_at IS 'optional, §3.1, for order of voting §5.3, date of change if original (§3.4)';


--
-- Name: COLUMN propositions.qualified_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.propositions.qualified_at IS 'optional, when qualified';


--
-- Name: COLUMN propositions.modifies_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.propositions.modifies_id IS 'only one level allowed';


--
-- Name: COLUMN propositions.external_fields; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.propositions.external_fields IS 'Fields that are imported from or exported to other systems but are not interpreted by the portal.';


--
-- Name: propositiontags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.propositiontags (
    proposition_id bigint NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: propositiontypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.propositiontypes (
    id integer NOT NULL,
    name text NOT NULL,
    abbreviation text NOT NULL,
    description text DEFAULT ''::text,
    policy_id integer NOT NULL
);


--
-- Name: propositiontypes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.propositiontypes ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.propositiontypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: secretvoters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.secretvoters (
    member_id integer NOT NULL,
    ballot_id integer NOT NULL,
    status public.secretvoterstatus NOT NULL,
    last_change timestamp without time zone NOT NULL
);


--
-- Name: subjectareas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subjectareas (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    department_id integer NOT NULL
);


--
-- Name: subjectareas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.subjectareas ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.subjectareas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: supporters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supporters (
    member_id integer NOT NULL,
    proposition_id bigint NOT NULL,
    submitter boolean DEFAULT false NOT NULL,
    status public.supporterstatus DEFAULT 'ACTIVE'::public.supporterstatus NOT NULL,
    last_change timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: COLUMN supporters.submitter; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.supporters.submitter IS 'submitter or regular';


--
-- Name: COLUMN supporters.last_change; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.supporters.last_change IS 'last status change';


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name text NOT NULL,
    parent_id integer,
    mut_exclusive boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN tags.mut_exclusive; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.mut_exclusive IS 'whether all children are mutually exclusive';


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.tags ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: urns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.urns (
    id integer NOT NULL,
    voting_id integer NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    location text NOT NULL,
    description text,
    opening time without time zone
);


--
-- Name: urns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.urns ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.urns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: urnsupporters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.urnsupporters (
    member_id integer NOT NULL,
    urn_id integer NOT NULL,
    type text NOT NULL,
    voted boolean DEFAULT false NOT NULL
);


--
-- Name: user_login_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_login_token (
    token text NOT NULL,
    user_id integer,
    valid_until timestamp without time zone
);


--
-- Name: userpassword; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userpassword (
    user_id integer NOT NULL,
    hashed_password text
);


--
-- Name: userprofiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userprofiles (
    id integer NOT NULL,
    sub text,
    eligible boolean,
    verified boolean,
    profile text
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    email character varying(255),
    auth_type text DEFAULT 'system'::text NOT NULL,
    joined timestamp without time zone DEFAULT now() NOT NULL,
    active boolean DEFAULT true NOT NULL,
    last_active timestamp without time zone DEFAULT now() NOT NULL,
    can_login_until timestamp without time zone
);


--
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.email IS 'optional, for notifications, otherwise use user/mails/';


--
-- Name: COLUMN users.auth_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.auth_type IS 'deleted,system,token,virtual,oauth(has UserProfile)';


--
-- Name: COLUMN users.last_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.last_active IS 'last relevant activity (to be considered active member §2.2)';


--
-- Name: COLUMN users.can_login_until; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.can_login_until IS 'optional expiration datetime after which login is no longer possible';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: voting_module; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voting_module (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    base_url text NOT NULL,
    module_type text NOT NULL
);


--
-- Name: voting_module_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.voting_module ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.voting_module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: voting_phase_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voting_phase_types (
    id integer NOT NULL,
    name text DEFAULT ''::text,
    abbreviation text DEFAULT ''::text,
    secret_voting_possible boolean NOT NULL,
    voting_type public.votingtype NOT NULL,
    description text DEFAULT ''::text,
    voting_days integer,
    registration_start_days integer,
    registration_end_days integer
);


--
-- Name: COLUMN voting_phase_types.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.voting_phase_types.name IS 'readable name';


--
-- Name: COLUMN voting_phase_types.abbreviation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.voting_phase_types.abbreviation IS 'abbreviated name';


--
-- Name: COLUMN voting_phase_types.voting_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.voting_phase_types.voting_days IS 'voting duration in days; ends at target date';


--
-- Name: COLUMN voting_phase_types.registration_start_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.voting_phase_types.registration_start_days IS 'voter registration start in days relative to target date';


--
-- Name: COLUMN voting_phase_types.registration_end_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.voting_phase_types.registration_end_days IS 'voter registration end in days relative to target date';


--
-- Name: voting_phase_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.voting_phase_types ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.voting_phase_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: votingphases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votingphases (
    id integer NOT NULL,
    status public.votingstatus DEFAULT 'PREPARING'::public.votingstatus NOT NULL,
    target timestamp without time zone,
    department_id integer NOT NULL,
    phase_type_id integer NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    name text DEFAULT ''::text,
    title text DEFAULT ''::text,
    description text DEFAULT ''::text,
    voting_module_data jsonb DEFAULT '{}'::jsonb,
    voting_days integer,
    registration_start_days integer,
    registration_end_days integer,
    CONSTRAINT ck_votingphases_state_valid CHECK (((status = 'PREPARING'::public.votingstatus) OR ((status <> 'PREPARING'::public.votingstatus) AND (target IS NOT NULL))))
);


--
-- Name: COLUMN votingphases.target; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.votingphases.target IS 'constrained by §4.1';


--
-- Name: COLUMN votingphases.secret; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.votingphases.secret IS 'whether any secret votes will take place (decision deadline §4.2)';


--
-- Name: COLUMN votingphases.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.votingphases.name IS 'short, readable name which can be used for URLs';


--
-- Name: COLUMN votingphases.voting_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.votingphases.voting_days IS 'voting duration in days; ends at target date';


--
-- Name: COLUMN votingphases.registration_start_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.votingphases.registration_start_days IS 'voter registration start in days relative to target date';


--
-- Name: COLUMN votingphases.registration_end_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.votingphases.registration_end_days IS 'voter registration end in days relative to target date';


--
-- Name: votingphases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.votingphases ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.votingphases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
4c6df443cb98
\.


--
-- Data for Name: areamembers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.areamembers (area_id, member_id) FROM stdin;
1	2
2	2
4	3
1	4
\.


--
-- Data for Name: argumentrelations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.argumentrelations (id, parent_id, argument_id, proposition_id, argument_type) FROM stdin;
1	\N	1	6775098944857779980	PRO
2	\N	2	6775098944857779980	PRO
3	\N	3	6775098944857779980	CONTRA
\.


--
-- Data for Name: arguments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.arguments (id, title, abstract, details, author_id, created_at) FROM stdin;
1	Ein Pro-Argument	12.01.2017 um 10:47 Uhr: Nicht nur ohne Bahnhof und ohne Krankenhaus, sondern auch ohne Autobahnanbindung und demnächst auch ohne Geld! 10:0	18. Dezember 2015, 22:02 Uhr 131 Kommentare Auf einer Seite lesen Seite 1 — Ramschware Öl 2. Seite 2 — Wem nützt billiges Öl? 10027 Volksratschef Purgin: Donbass-Blockade bringt Kiew „dutzende Millionen Griwna“Die gegen die Donbass-Region verhängte Wirtschaftsblockade bringt Kiew dutzende Millionen Griwna. "1984 wurden in den Bergen die Olympischen Winterspiele ausgetragen. Die Schnitzel werden evtl. flach geklopft, von beiden Seiten mit Pesto bestrichen und mit einer italienischen Gewürzmischung bestreut. 13-Megapixel-Kamera mit zweiter Linse Die Ultrapixel-Kamera mit 4 Megapixeln hat HTC beim neuen One M9 bereits durch ein gutes 20-Megapixel-Modell ersetzt, beim One M8s wurde sie ebenfalls gestrichen. 15 Fakten über das Park Hyatt Vienna Park Hyatt Vienna An der Außenwand des Hauses erinnert eine Bronze-Tafel vom österreichischen Bildhauer Oskar Thiede an Henry Dunant, Gründer des Roten Kreuzes. 11:36 Lob für Kanzler Werner Faymann und Innenministerin Mikl-Leitner gab es von Amnesty International für die rasche Grenzöffnung. 1April 2015 - 08:51 Uhr (Motorsport-Total. 09.40 Uhr - Die oppositionellen griechischen Konservativen werden nach den Worten eines Abgeordneten der Partei in einer Vertrauensabstimmung nicht für die Regierung stimmen. 11:19 Leoni AG: Kreuzen des GD 50 nach unten (58.7 Euro, Short) 13.07.	2	2021-03-09 17:04:23.664292
2	Ein zweites Pro-Argument	dafür!!!	\N	3	2021-03-09 17:04:23.664292
3	Ein Contra-Argument	dagegen!!!	aus Gründen	2	2021-03-09 17:04:23.664292
\.


--
-- Data for Name: argumentvotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.argumentvotes (member_id, relation_id, weight) FROM stdin;
2	1	1
2	2	-1
3	1	-1
\.


--
-- Data for Name: ballots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ballots (id, name, election, voting_type, proposition_type_id, area_id, voting_id, result) FROM stdin;
1	PP001/2/3/4	0	\N	1	2	1	\N
2	\N	0	\N	1	2	\N	\N
3	\N	0	\N	1	2	\N	\N
4	\N	0	\N	1	2	\N	\N
5	\N	0	\N	1	2	\N	\N
6	\N	0	\N	1	2	\N	\N
7	PP001	0	\N	1	1	3	{"PP001": {"no": 10, "yes": 14, "rank": 1, "points": 213, "abstention": 15}}
8	PP005	0	\N	1	1	3	{"PP005": {"state": "accepted"}}
9	PP006	0	\N	1	1	3	{"PP006": {"state": "rejected"}}
10	PP007/8	0	\N	1	1	3	{"PP007": {"state": "not decided"}, "PP008": {"state": "rejected"}}
\.


--
-- Data for Name: changeset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.changeset (id, document_id, proposition_id, section) FROM stdin;
\.


--
-- Data for Name: customizable_text; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customizable_text (name, lang, text, permissions) FROM stdin;
push_draft_external_template	de	\nDieser Antragsentwurf wurde automatisch erstellt durch das Antragsportal\n\n{draft_link}\n\n## Vorbemerkungen / Bearbeitungshinweise\n\n(nicht Teil des Antrags)\n\n{editing_remarks}\n\n## Zusammenfassung\n\n{abstract}\n\n## Antragstext\n\n{content}\n\n## Begründung\n\n{motivation}\n	\N
push_draft_portal_template	de	\nDer Antragsentwurf wird hier weiterentwickelt:\n\n{topic_url}\n\nVerbesserungsvorschläge und Verständnisfragen bitte dort einbringen.\n	\N
document_propose_change_explanation	de	\nStelle einen Wahlprogrammantrag, um dieses Programm zu ändern.\nDu kannst eine Änderung an einem Abschnitt vorschlagen, indem du auf dessen Überschrift klickst.\nAuf der folgenden Seite kannst du den Text bearbeiten und weitere Informationen zu deinen Antragsentwurf ergänzen.\n	\N
new_draft_explanation	de	\nNach dem Abschicken wird dein Antragsentwurf automatisch im Forum in der Kategorie Antragsentwicklung eingestellt.\nDer Text des Antrags kann dort von allen angemeldeten Benutzern bearbeitet werden wie in einem Wiki.\nDu kannst die Bearbeitung sperren lassen. Wende dich dazu an die Antragskommission.\n	\N
\.


--
-- Data for Name: departmentmembers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.departmentmembers (department_id, member_id, is_admin) FROM stdin;
3	2	f
4	2	f
3	4	t
5	3	f
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.departments (id, name, description, exporter_settings, voting_module_settings) FROM stdin;
1	Landesverband Bayern	\N	{}	{}
2	Bezirksverband Oberpfalz	\N	{}	{}
3	Piratenpartei Deutschland	\N	{"exporter_name": "testdiscourse", "exporter_description": "Ein Test-Discourse"}	{}
4	Piratenpartei Schweiz	\N	{}	{}
5	Zentralschweiz	\N	{}	{}
\.


--
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.document (id, name, lang, area_id, text, description, proposition_type_id) FROM stdin;
1	Wahlprogramm	de	1	# Wahlprogramm\n\n## Section 1 {data-section="1"}\n\n### Section 1.1 {data-section="1.1"}\n\nText Section 1.1\n	Ein Wahlprogramm	2
\.


--
-- Data for Name: groupmembers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.groupmembers (group_id, member_id) FROM stdin;
1	1
2	2
2	3
2	4
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.groups (id, name, is_admin_group) FROM stdin;
1	Göttliche Admins	t
2	Deppengruppe	f
\.


--
-- Data for Name: oauth_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.oauth_token (id, token, provider, created_at) FROM stdin;
3	{}	ekklesia	2021-03-09 17:04:23.664292
4	{}	ekklesia	2021-03-09 17:04:23.664292
\.


--
-- Data for Name: page; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.page (name, lang, title, text, permissions) FROM stdin;
\.


--
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.policies (id, name, description, majority, proposition_expiration, qualification_minimum, qualification_quorum, range_max, range_small_max, range_small_options, secret_minimum, secret_quorum, submitter_minimum, voting_duration, voting_system) FROM stdin;
1	default	11.02.2017 Marvels Spider-Man geht voraussichtlich wieder zur Schule Keine gute Nachricht ohne einen kleinen Wermutstropfen. 16-Wochen-Behandlungsgruppen Von den 211 Patienten, die randomisiert den 16-Wochen-Behandlungsgruppen zugeteilt wurden, erhielten 106 Patienten Grazoprevir/Elbasvir plus RBV. 16.53 Uhr: Auch in Hannover versammelten sich rund 300 Franzosen und Deutsche.	SIMPLE	180	50	0.10	9	3	5	20	0.05	2	14	RANGE_APPROVAL
\.


--
-- Data for Name: postalvotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.postalvotes (member_id, voting_id) FROM stdin;
\.


--
-- Data for Name: propositionnotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.propositionnotes (proposition_id, user_id, notes, vote) FROM stdin;
\.


--
-- Data for Name: propositions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.propositions (id, title, content, abstract, motivation, voting_identifier, created_at, submitted_at, qualified_at, status, submitter_invitation_key, author_id, ballot_id, modifies_id, replaces_id, external_discussion_url, external_fields, visibility, search_vector) FROM stdin;
6775098944857779980	Ein Titel	13:23 dpa-AFX: Citigroup startet Deutsche Wohnen mit 'Buy' - Ziel 29,70 Euro 20.07. 12.20 Uhr - Der Wechsel an der Spitze des Bundesamts für Migration und Flüchtlinge (BAMF) bietet nach Ansicht des CDU-Innenexperten Armin Schuster die Chance auf eine bessere Arbeit der Behörde. 14 Uhr: Die Lufthansa-Aktie liegt bereits seit dem Morgen im Minus und verliert bis zum frühen Nachmittag mehr als vier Prozent. 1100 Euro Preisgeld am Sonntag sind verlockend "Die haben dann den Kontakt zur Spielvereinigung hergestellt", erklärt Beste. 15:33 Fuchs Petrolub: Plus 10 Prozent Die Analysten der Nord LB bestätigen die Halteempfehlung für die Aktien von Fuchs Petrolub. 11:04 Citigroup senkt HeidelbergCement auf 'Neutral' - Ziel aber rauf Die US-Bank Citigroup hat HeidelbergCement von "Buy" auf "Neutral" abgestuft, das Kursziel aber von 69 auf 77 Euro angehoben. 18. Januar 2015 14:20 - Aktualisiert 15:59 von Claudia von Duehren Sie trinkt stilles Mondwasser, knabbert Cashewkerne und plaudert über ihr Leben. 1/11 Der Sieg ist im Trockenen: Seferovic ballt nach dem dritten Schweizer Tor die Faust: Shaqiri hatte ihn bedient. 1200 Gäste kamen zur Preisverleihung ins Deutsche Schauspielhaus. 15.30 Uhr Ibrahim hilft beim Sortieren der Spenden, jeden Tag mehrere Stunden. 11/17/15 8:38 PM Pistorius sagt, die Einsatzlage in Hannover bleibe bis spätestens morgen "unverändert". 19.05.2017 - Tobias Simon Könnte dich interessieren The Last Guardian Gerücht: Neue Informationen auf der E3? 1' Anpfiff Ersatz-Schiedsrichter Sascha Amhof gibt die Partie frei! 15 PC GAMES Pillars of Eternity im Testvideo: So klasse ist das inoffizielle Baldur's Gate 3, Pillars of Eternity: Let's Play des bis jetzt grandiosen Kickstarter-Rollenspiels (Spoileralarm) uvm. 10:30 Felix Neureuther (GER) ist gestartet, das Rennen beginnt! 10:26 Auch in Adelboden ist es für Jänner extrem warm. 13 Diäten später ist aus dem Experiment ein Buch geworden: "I'll Have What She's Having. 100 Amazon-Bestseller: Begehrte Produkte im Test! 1&1 DSL Vorteilswochen: Mobilflat kostenlos zubuchbar. 1&1: 24 Monate lang 10 Euro sparen Bei 1&1 profitieren Kunden aktuell von den Vorteilswochen. 15:49 SocGen belässt Evonik auf 'Buy' Die französische Großbank Societe Generale (SocGen) hat die Einstufung für Evonik auf "Buy" belassen. 1/4 Wer ist verantwortlich für das hohe Preisniveau in der Schweiz – die Bauern oder die Detailhändler? 15:52 JPMorgan nimmt Repsol mit 'Neutral' wieder auf - Ziel 16,80 Euro Die US-Bank JPMorgan hat Repsol mit "Neutral" und einem Kursziel von 16,80 Euro in die Bewertung wieder aufgenommen. Eine gruselige Allianz (taz. 16 Bilder "Fifa 16" im Test: Das ist neu im EA-Sports-Spiel Markus Böhm Hey Jörg, "PES 2016" ist schon eine Woche draußen, "Fifa 16" erscheint Donnerstag. 1400 Tonnen Öl an Bord Der russische Trawler «Oleg Neidenow» war bereits am 15. April zirka 24 Kilometer vor der Insel gesunken. 14.26 Uhr: Die Ursache für den Absturz der Germanwings-Maschine in Südfrankreich wird nach Ansicht eines Branchenexperten erst in einigen Wochen endgültig geklärt sein. 19.00 Uhr: Eine Schweigeminute gibt es noch für Ex-Nationalspieler Wolfram Wuttke, der in der Nacht zu Sonntag verstorben ist. 17:34 In Berlin wurde heute laut Polizeiangaben ein Islamist von der Polizei erschossen. 100.000 Freiwillige gesucht Von der Maßnahme selbst scheint man aber überzeugt zu sein. 1 2 3 Fazit Pro & Kontra So testet 4Players Bitte hier klicken, um an der Diskussion teilzunehmen! 11.20 Uhr - Fernduell Merkel - Seehofer: Als Horst Seehofer um kurz nach zehn zu seiner Regierungserklärung im bayerischen Landtag ansetzte, war Angela Merkel schon durch. 16.41 Uhr: Alzenau - Die Polizei hat am Donnerstag einen Busfahrer gestoppt, der volltrunken hinterm Steuer saß. 18 Leserempfehlungen Antwort auf "Wichtig ist doch, dass auf jeden Fall die EU-Kommission ihren.. Bundesliga, 2015/16, 1Spieltag Hamburger SV - Hannover 96 1:2 Unter Bruno Labbadia hat sich der Hamburger SV gefangen und ist in der Tabelle nach oben geklettert. Im Gegensatz zu früheren Webseiten müssen wir zum Beispiel nicht mehr zwei verschiedene Webseiten für den Internet Explorer und einen anderen Browser programmieren. 1 Festtagskarten der Bundesräte Bloss nicht Weihnachten! 13.31 Uhr: EU-Kommissionspräsident Jean-Claude Juncker hat kurz vor dem Eurogruppe-Treffen ein Krisengespräch mit Ministerpräsident Alexis Tsipras geführt. 1 2 3 weiter » KuchenDeluxe Weiß jemand hier was zum Gerücht, dass das Spiel wegen der alten Hintergründe nur in 4:3 spielbar sein wird? 15.41 Uhr: Die Angst vor Ebola hat nach britischen Angaben zu einem vorläufigen Stopp der Genitalverstümmelung bei Frauen in Sierra Leone und Liberia geführt. 12.09.2017 10:04 Uhr Denise Bergert vorlesen 2016 soll es erste Drohnen mit Snapdragon Flight geben. 10.25 Uhr: Das pleitebedrohte Griechenland hat einen neuen Antrag für Rettungsmilliarden beim Eurorettungsschirm ESM gestellt.			PP001	2020-01-01 00:00:00	2020-01-05 00:00:00	2020-01-08 00:00:00	SCHEDULED	\N	\N	1	\N	\N	http://example.com	{}	PUBLIC	'..':619C '04':112C,750C '1':234C,323C,324C,330C,331C,339C,340C,546C,627C,669C,699C '1/11':165C '1/4':368C '10':95C,277C,287C,335C,749C '10.25':764C '100':315C '100.000':533C '11':111C '11.20':563C '11/17/15':204C '1100':73C '12.09.2017':748C '12.20':19C '1200':184C '13':3C,298C '13.31':676C '14':50C,145C '14.26':473C '1400':451C '15':90C,148C,245C,347C,384C,464C '15.30':192C '15.41':724C '16':394C,410C,422C,425C,448C '16.41':587C '17':519C '18':142C,603C '19.00':498C '19.05.2017':219C '1spieltag':622C '2':547C,628C,700C '20':146C '20.07':18C '2015':144C '2015/16':621C '2016':441C,755C '23':4C '24':332C,467C '26':288C '29':15C '3':261C,548C,701C,720C '30':278C '33':91C '34':520C '38':206C '4':719C '49':348C '4players':554C '52':385C '59':149C '69':137C '70':16C '77':139C '8':205C '80':395C,411C '96':626C 'abgestuft':132C 'absturz':479C 'adelbod':291C 'afx':7C 'akti':55C,107C 'aktualisiert':147C 'aktuell':343C 'alexis':696C 'allianz':420C 'alt':715C 'alzenau':589C 'amazon':317C 'amazon-bestsell':316C 'amhof':240C 'analyst':98C 'angab':733C 'angehob':141C 'angela':583C 'angst':727C 'anpfiff':235C 'ansetzt':581C 'ansicht':35C,488C 'antrag':772C 'antwort':605C 'april':465C 'arbeit':47C 'armin':40C 'aufgenomm':417C 'baldur':258C 'ballt':172C 'bamf':32C 'bank':124C,400C 'bau':380C 'bayer':579C 'bedient':183C 'begehrt':319C 'beginnt':286C 'behord':49C 'beim':196C,775C 'beispiel':654C 'belass':367C 'belasst':350C 'bereit':57C,462C 'bergert':753C 'berlin':522C 'bess':46C 'best':89C 'bestat':102C 'bestsell':318C 'bewert':415C 'bietet':33C 'bild':423C 'bitt':555C 'bleib':214C 'bloss':673C 'bohm':437C 'bord':455C 'branchenexpert':490C 'britisch':732C 'brows':667C 'bruno':630C 'buch':306C 'bundesamt':27C 'bundesliga':620C 'bundesrat':672C 'busfahr':596C 'buy':13C,129C,353C,366C 'cashewkern':159C 'cdu':38C 'cdu-innenexpert':37C 'chanc':43C 'citigroup':8C,113C,125C 'claud':683C 'claudia':151C 'dass':610C,710C 'denis':752C 'detailhandl':383C 'deutsch':10C,190C 'diat':299C 'diskussion':561C 'donnerstag':450C,594C 'dpa':6C 'dpa-afx':5C 'drauss':446C 'dritt':175C 'drohn':759C 'dsl':325C 'duehr':153C 'e3':233C 'ea':433C 'ea-sports-spiel':432C 'ebola':729C 'einsatzlag':211C 'einstuf':362C 'endgult':495C 'erklart':88C 'ersatz':237C 'ersatz-schiedsricht':236C 'erscheint':449C 'erschoss':532C 'erst':491C,758C 'esm':777C 'eternity':250C,264C 'eu':616C,679C 'eu-kommission':615C 'eu-kommissionsprasident':678C 'euro':17C,74C,140C,336C,396C,412C 'eurogrupp':690C 'eurogruppe-treff':689C 'eurorettungsschirm':776C 'evon':351C,364C 'ex':507C 'ex-nationalspiel':506C 'experiment':304C 'explor':663C 'extr':296C 'fall':613C 'faust':179C 'fazit':549C 'felix':279C 'fernduell':565C 'festtagskart':670C 'fifa':424C,447C 'flight':762C 'fluchtling':31C 'franzos':355C 'frau':741C 'frei':244C 'freiwill':534C 'fruh':67C,649C 'fuch':92C,109C 'gam':247C 'gast':185C 'gat':260C 'geb':763C 'gefang':637C 'gefuhrt':698C,747C 'gegensatz':647C 'geklart':496C 'geklettert':645C 'general':358C 'genitalverstummel':739C 'ger':281C 'germanwing':482C 'germanwings-maschin':481C 'gerucht':228C,709C 'gestartet':283C 'gestellt':778C 'gestoppt':597C 'gesucht':535C 'gesunk':472C 'geword':307C 'gibt':241C,502C 'grandios':271C 'griechenland':768C 'grossbank':356C 'grusel':419C 'guardian':227C 'halteempfehl':104C 'hamburg':623C,635C 'hannov':213C,625C 'hav':310C 'having':314C 'heidelbergcement':115C,127C 'hergestellt':87C 'heut':524C 'hey':438C 'hilft':195C 'hintergrund':716C 'hinterm':600C 'hoh':374C 'horst':569C 'i':308C 'ibrahim':194C 'information':230C 'innenexpert':39C 'inoffiziell':257C 'insel':471C 'interessi':224C 'internet':662C 'islamist':528C 'jann':295C 'januar':143C 'jean':682C 'jean-claud':681C 'jemand':705C 'jorg':439C 'jpmorgan':386C,401C 'junck':684C 'kam':186C 'kickstart':273C 'kickstarter-rollenspiel':272C 'kilomet':468C 'klass':254C 'klick':557C 'knabbert':158C 'kommission':617C 'kommissionsprasident':680C 'kontakt':84C 'kontra':551C 'kostenlos':328C 'krisengesprach':693C 'kuchendelux':703C 'kund':342C 'kursziel':134C,408C 'kurz':572C,686C 'labbadia':631C 'landtag':580C 'lang':334C 'last':226C 'laut':525C 'lb':101C 'leb':164C 'leon':744C 'leserempfehl':604C 'let':265C 'liberia':746C 'liegt':56C 'll':309C 'lufthansa':54C 'lufthansa-akti':53C 'markus':436C 'maschin':483C 'massnahm':538C 'mehr':69C,202C,656C 'merkel':566C,584C 'migration':29C 'ministerprasident':695C 'minus':62C 'mobilflat':327C 'monat':333C 'mondwass':157C 'morg':60C,217C 'muss':651C 'nachmittag':68C 'nacht':514C 'nationalspiel':508C 'neidenow':460C 'neu':229C,430C,771C 'neureuth':280C 'neutral':117C,131C,390C,405C 'nimmt':387C 'nord':100C 'oben':644C 'of':249C,263C 'ol':453C 'oleg':459C 'parti':243C 'pc':246C 'pes':440C 'petrolub':93C,110C 'pillar':248C,262C 'pistorius':208C 'plaudert':161C 'play':267C 'pleitebedroht':767C 'plus':94C 'pm':207C 'polizei':531C,591C 'polizeiangab':526C 'pp001':779A 'preisgeld':75C 'preisniveau':375C 'preisverleih':188C 'pro':550C 'produkt':320C 'profiti':341C 'programmi':668C 'prozent':72C,96C 'rauf':120C 'regierungserklar':577C 'renn':285C 'repsol':388C,403C 'rettungsmilliard':774C 'rollenspiel':274C 'russisch':457C 's':259C,266C,313C 'sagt':209C 'sascha':239C 'sass':602C 'schauspielhaus':191C 'scheint':540C 'schiedsricht':238C 'schon':443C,585C 'schust':41C 'schweigeminut':501C 'schweiz':176C,378C 'seehof':567C,570C 'seferovic':171C 'seit':58C 'senkt':114C 'shaqiri':180C 'she':312C 'sieg':167C 'sierra':743C 'simon':221C 'snapdragon':761C 'socg':349C,359C 'societ':357C 'sonntag':77C,516C 'sorti':197C 'spar':337C 'spat':300C 'spatest':216C 'spend':199C 'spiel':435C,712C 'spielbar':721C 'spielverein':86C 'spitz':25C 'spoileralarm':275C 'sport':434C 'startet':9C 'steu':601C 'still':156C 'stopp':737C 'stund':203C 'sudfrankreich':485C 'sv':624C,636C 'tabell':642C 'tag':201C 'taz':421C 'teilzunehm':562C 'test':322C,427C 'testet':553C 'testvideo':252C 'the':225C 'titel':2A 'tobias':220C 'tonn':452C 'tor':177C 'trawl':458C 'treff':691C 'trinkt':155C 'trock':170C 'tsipras':697C 'uberzeugt':543C 'uhr':20C,51C,193C,474C,499C,564C,588C,677C,725C,751C,765C 'unverandert':218C 'ursach':476C 'us':123C,399C 'us-bank':122C,398C 'uvm':276C 'verantwort':371C 'verliert':64C 'verlock':79C 'verschied':658C 'verstorb':517C 'vier':71C 'volltrunk':599C 'vorlauf':736C 'vorles':754C 'vorteilswoch':326C,346C 'warm':297C 'webseit':650C,659C 'wechsel':22C 'weg':713C 'weihnacht':675C 'weiss':704C 'wer':369C 'what':311C 'wichtig':607C 'woch':445C,494C 'wohn':11C 'wolfram':509C 'wurd':523C 'wuttk':510C 'zehn':574C 'ziel':14C,118C,393C 'zirka':466C 'zubuchbar':329C 'zwei':657C
6775098944879793994	Fallengelassener Antrag	Einfach so fallengelassen...			\N	2020-01-01 00:00:00	\N	\N	ABANDONED	\N	\N	2	\N	\N	http://example.com	{}	PUBLIC	'antrag':2A 'einfach':3C 'fallengelass':1A,5C
6775098944879878150	Sich ändernder Antrag	Einfach so ändernd...			\N	2020-01-01 00:00:00	\N	\N	CHANGING	\N	\N	3	\N	\N	http://example.com	{}	PUBLIC	'andernd':2A,6C 'antrag':3A 'einfach':4C
6775098944882475370	Entstehender Antrag	Einfach so entstehend...			\N	2020-01-06 00:00:00	\N	\N	DRAFT	\N	2	4	\N	\N	\N	{}	PUBLIC	'antrag':2A 'einfach':3C 'entsteh':1A,5C
6775098944883426365	Übertragener Antrag	Einfach so Übertragen...			\N	2020-01-06 00:00:00	2020-01-06 00:00:00	\N	SUBMITTED	\N	\N	5	\N	\N	http://example.com	{}	PUBLIC	'antrag':2A 'einfach':3C 'ubertrag':1A,5C
6775098944888558306	Qualifizierter Antrag	Einfach so qualifiziert...			\N	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	QUALIFIED	\N	\N	6	\N	\N	\N	{}	PUBLIC	'antrag':2A 'einfach':3C 'qualifiziert':1A,5C
6775098944887195566	Antrag mit nicht unterstütztem Ergebnisformat	13. Etappe - Degenkolb bei Van-Avermaet-Sieg auf Platz vier Der deutsche Sprintstar John Degenkolb (Gera/Giant-Alpecin) hat auf der 13. Etappe der Tour de France erneut einen Sieg verpasst. 11.02.2017 Marvels Spider-Man geht voraussichtlich wieder zur Schule Keine gute Nachricht ohne einen kleinen Wermutstropfen. 17.21 Uhr, Nato-Generalsekretär legt sich bei Waffenlieferungen nicht fest Nato-Generalsekretär Jens Stoltenberg legt sich in der Frage möglicher Waffenlieferungen an die Ukraine nicht fest. 12.01.2017Menschen sind darauf programmiert, mit Angehörigen ihrer eigenen Gruppe, kaum aber mit „den anderen“ zu fühlen. 16 junge Fotografen rückten sich selber sowie mitgebrachte Gegenstände im Fotostudio in Frick ins beste Licht. 10:39 Gerresheimer AG: Kreuzen des GD 20 nach unten (63.8 Euro, Short) 02.09. Best of MDAX - Die aussichtsreichsten Kandidaten bei einer Rally? 31.08. 1899 Hoffenheim - Bayern München (Samstag, 15.30 Uhr) SITUATION: Die Bayern kommen nach dem 5:0 gegen den HSV als Tabellenführer in den Kraichgau. 1953 verschob das Londoner Schuldenabkommen die Regelung deutscher Reparationen auf die Zeit nach Abschluss eines „förmlichen Friedensvertrages“. 10. Mit je einer Aprikosenhälfte (oder kleiner geschnittenen Pfirsichhälfte) belegen und nochmals mit etwas Puderzucker bestäuben. 16.39 Uhr: Dann geht es wieder um Russland. 1Spiel: Süßigkeiten Es sollen diverse Süßigkeiten wie Puffreis und Lakritzschnecken in vorgegebenen Gramm-Zahlen abgewogen werden – allerdings nach Gefühl. 17' Das muss das 2:1 für die Zürcher sein! 19. Februar 2015 12:00 - Aktualisiert 13:00 von B.Z. Innerhalb von rund zwei Wochen soll dieser Mann zwei jungen Frauen die Haare angezündet haben! 124613 Kiew befürchtet stillschweigende Einigung des Westens mit Russland - MedienUkrainische Politiker vermuten, dass der Westen „in Russlands Interesse“ agiert. 17.01 Uhr: Die Favoritinnen werden hier nichts holen. 18:00 DGAP-Adhoc: Airopack Technology Group AG - Reorganisation der Aktionärsstruktur: Quint Kelders übernimmt Mehrheit der von der Familie kontrollierten Aktien (deutsch) 10.06. 17.28 Uhr: Es geht um die taktische Ausrichtung der Bayern. 12.51 Uhr: Das Hilfsprogramm für Griechenland dürfte nach Einschätzung von EZB-Direktor Benoit Coeure abgeändert werden, um der griechischen Regierung entgegenzukommen. Granatapfel Foto: volff - Fotolia/volff/Fotolia Der Granatapfel wird als Superfruit gehandelt, einige Wirkungen sind belegt. 102. Tour de France Alle Ausfälle im Überblick Auch die 102. Tour de France muss bereits nach der ersten Woche viele prominente Ausfälle verkraften.			PP001	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	FINISHED	\N	\N	7	\N	\N	http://example.com	{}	PUBLIC	'0':152C '00':236C,239C,285C '02.09':127C '1':227C '10':114C,178C '10.06':307C '102':354C,364C '11.02.2017':36C '12':235C '12.01.2017':81C '12.51':318C '124613':257C '13':6C,26C,238C '15.30':143C '16':98C '16.39':194C '17':222C '17.01':276C '17.21':53C '17.28':308C '18':284C '1899':138C '19':232C '1953':161C '1spiel':202C '2':226C '20':121C '2015':234C '31.08':137C '39':115C '5':151C '63.8':124C 'abgeandert':333C 'abgewog':217C 'abschluss':174C 'adhoc':288C 'ag':117C,292C 'agiert':275C 'airopack':289C 'akti':305C 'aktionarsstruktur':295C 'aktualisiert':237C 'allerding':219C 'angehor':87C 'angezundet':255C 'antrag':1A 'aprikosenhalft':182C 'ausfall':359C,376C 'ausricht':315C 'aussichtsreich':132C 'avermaet':12C 'b.z':241C 'bay':140C,147C,317C 'befurchtet':259C 'beleg':187C 'belegt':353C 'benoit':331C 'bereit':369C 'best':112C,128C 'bestaub':193C 'coeur':332C 'darauf':84C 'dass':269C 'de':30C,356C,366C 'degenkolb':8C,21C 'deutsch':18C,168C,306C 'dgap':287C 'dgap-adhoc':286C 'direktor':330C 'divers':206C 'durft':324C 'eig':89C 'einig':261C 'einschatz':326C 'entgegenzukomm':339C 'ergebnisformat':5A 'erneut':32C 'erst':372C 'etapp':7C,27C 'euro':125C 'ezb':329C 'ezb-direktor':328C 'famili':303C 'favoritinn':279C 'februar':233C 'fest':63C,80C 'formlich':176C 'foto':341C 'fotograf':100C 'fotolia/volff/fotolia':343C 'fotostudio':108C 'frag':73C 'franc':31C,357C,367C 'frau':252C 'frick':110C 'friedensvertrag':177C 'fuhl':97C 'gd':120C 'gefuhl':221C 'gegenstand':106C 'gehandelt':349C 'geht':41C,197C,311C 'generalsekretar':57C,66C 'gera/giant-alpecin':22C 'gerresheim':116C 'geschnitt':185C 'gramm':215C 'gramm-zahl':214C 'granatapfel':340C,345C 'griechenland':323C 'griechisch':337C 'group':291C 'grupp':90C 'gut':47C 'haar':254C 'hilfsprogramm':321C 'hoffenheim':139C 'hol':283C 'hsv':155C 'innerhalb':242C 'interess':274C 'je':180C 'jen':67C 'john':20C 'jung':99C,251C 'kandidat':133C 'kaum':91C 'keld':297C 'kiew':258C 'klein':51C,184C 'komm':148C 'kontrolliert':304C 'kraichgau':160C 'kreuz':118C 'lakritzschneck':211C 'legt':58C,69C 'licht':113C 'london':164C 'mann':249C 'marvel':37C 'mdax':130C 'medienukrain':266C 'mehrheit':299C 'mensch':82C 'mitgebracht':105C 'moglich':74C 'munch':141C 'nachricht':48C 'nato':56C,65C 'nato-generalsekretar':55C,64C 'nochmal':189C 'of':129C 'pfirsichhalft':186C 'platz':15C 'polit':267C 'pp001':378A 'programmiert':85C 'prominent':375C 'puderzuck':192C 'puffreis':209C 'quint':296C 'rally':136C 'regel':167C 'regier':338C 'reorganisation':293C 'reparation':169C 'ruckt':101C 'rund':244C 'russland':201C,265C,273C 'samstag':142C 'schul':45C 'schuldenabkomm':165C 'selb':103C 'short':126C 'sieg':13C,34C 'situation':145C 'soll':205C 'sowi':104C 'spid':39C 'spider-man':38C 'sprintstar':19C 'stillschweig':260C 'stoltenberg':68C 'superfruit':348C 'sussig':203C,207C 'tabellenfuhr':157C 'taktisch':314C 'technology':290C 'tour':29C,355C,365C 'uberblick':361C 'ubernimmt':298C 'uhr':54C,144C,195C,277C,309C,319C 'ukrain':78C 'unt':123C 'unterstutzt':4A 'van':11C 'van-avermaet-sieg':10C 'verkraft':377C 'vermut':268C 'verpasst':35C 'verschob':162C 'viel':374C 'vier':16C 'volff':342C 'voraussicht':42C 'vorgegeb':213C 'waffenliefer':61C,75C 'wermutstropf':52C 'west':263C,271C 'wirkung':351C 'woch':246C,373C 'zahl':216C 'zeit':172C 'zurch':230C 'zwei':245C,250C
6775098944889674652	Angenommener Antrag	1 4 0 0 Keine Kommentare Andre ist Jahrgang 1983 und unterstützt seit September 2013 die Redaktion von silicon.de als Volontär. 1637472Rund 6.000 Demonstranten haben Mittwochvormittag an der Blockupy-Randale in Frankfurt teilgenommen, gaben Vertreter des linksradikalen Bündnisses Blockupy bei einer Pressekonferenz an.			PP005	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	FINISHED	\N	\N	8	\N	\N	http://example.com	{}	PUBLIC	'0':5C,6C '1':3C '1637472rund':24C '1983':12C '2013':17C '4':4C '6.000':25C 'andr':9C 'angenomm':1A 'antrag':2A 'blockupy':32C,42C 'blockupy-randal':31C 'bundnis':41C 'demonstrant':26C 'frankfurt':35C 'gab':37C 'jahrgang':11C 'kommentar':8C 'linksradikal':40C 'mittwochvormittag':28C 'pp005':46A 'pressekonferenz':45C 'randal':33C 'redaktion':19C 'seit':15C 'septemb':16C 'silicon.de':21C 'teilgenomm':36C 'unterstutzt':14C 'vertret':38C 'volontar':23C
6775098944896508215	Abgelehnter Antrag	Bla			PP006	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	FINISHED	\N	\N	9	\N	\N	http://example.com	{}	PUBLIC	'abgelehnt':1A 'antrag':2A 'bla':3C 'pp006':4A
6775098944893885687	Verschobener Antrag	Blubb			PP007	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	FINISHED	\N	\N	10	\N	\N	http://example.com	{}	PUBLIC	'antrag':2A 'blubb':3C 'pp007':4A 'verschob':1A
6775098944901260129	Änderungsantrag zu PP001	will was ändern			PP004	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	SCHEDULED	\N	\N	1	6775098944857779980	\N	\N	{}	PUBLIC	'and':6C 'anderungsantrag':1A 'pp001':3A 'pp004':7A
6775098944904276933	Gegenantrag zu PP001	will was anderes			PP002	2020-01-02 00:00:00	2020-01-07 00:00:00	2020-01-10 00:00:00	SCHEDULED	\N	\N	1	\N	6775098944857779980	\N	{}	PUBLIC	'gegenantrag':1A 'pp001':3A 'pp002':4A
6775098944903155235	Noch ein Gegenantrag zu PP001 mit Volltextsuche	will was ganz anderes, ich will Volltextsuche			PP003	2020-01-03 00:00:00	2020-01-09 00:00:00	2020-01-24 00:00:00	SCHEDULED	\N	\N	1	\N	6775098944857779980	\N	{}	PUBLIC	'ganz':10C 'gegenantrag':3A 'pp001':5A 'pp003':15A 'volltextsuch':7A,14C
6775098944905282473	Abgelehnter Gegenantrag zum Verschobenen Antrag PP007	Gegenantrag von PP008			PP008	2020-01-06 00:00:00	2020-01-06 00:00:00	2020-01-11 00:00:00	FINISHED	\N	\N	10	6775098944893885687	\N	http://example.com	{}	PUBLIC	'abgelehnt':1A 'antrag':5A 'gegenantrag':2A,7C 'pp007':6A 'pp008':9C,10A 'verschob':4A
\.


--
-- Data for Name: propositiontags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.propositiontags (proposition_id, tag_id) FROM stdin;
6775098944879793994	1
6775098944879878150	1
6775098944882475370	1
6775098944857779980	2
6775098944857779980	3
6775098944887195566	1
6775098944889674652	1
6775098944896508215	1
6775098944893885687	1
6775098944905282473	1
\.


--
-- Data for Name: propositiontypes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.propositiontypes (id, name, abbreviation, description, policy_id) FROM stdin;
1	Positionspapier	PP	11:31 Berenberg belässt FMC auf 'Buy' - Ziel 90 Euro Die Privatbank Berenberg hat die Einstufung für FMC vor Quartalszahlen auf "Buy" mit einem Kursziel von 90 Euro belassen. 16.54 Uhr: Der Chef der BASF-Tochter Wintershall, Mario Mehren, sieht den Tausch von Firmenanteilen mit dem Energieriesen Gazprom als Zeichen einer Entspannung der deutsch-russischen Beziehungen. 15 Berliner Gymnasiasten gingen auf Klassenfahrt – nach New York.	1
2	Wahlprogrammantrag	WP	13.12 Uhr: Der Flugzeughersteller Airbus will nach dem Absturz einer A320 über Südfrankreich so schnell wie möglich die Situation analysieren. 19.04.2017 1 Antwort von Christof Kochanowski finden das kostenlose G 36 also super und hätten zu den 8000 gelieferten gerne noch mehr? 123> weiter Bewerten 28 3 Die mit * gekennzeichneten Felder sind Pflichtfelder.	1
\.


--
-- Data for Name: secretvoters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.secretvoters (member_id, ballot_id, status, last_change) FROM stdin;
2	5	ACTIVE	2021-07-13 17:25:06.878134
\.


--
-- Data for Name: subjectareas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subjectareas (id, name, description, department_id) FROM stdin;
1	Allgemein	\N	3
2	Innerparteiliches	\N	4
3	Politik	\N	4
4	Innerparteiliches	\N	5
\.


--
-- Data for Name: supporters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.supporters (member_id, proposition_id, submitter, status, last_change) FROM stdin;
2	6775098944857779980	t	ACTIVE	2021-03-09 17:04:23.664292
3	6775098944904276933	t	ACTIVE	2021-03-09 17:04:23.664292
2	6775098944887195566	f	ACTIVE	2021-03-09 17:04:23.664292
2	6775098944889674652	f	ACTIVE	2021-03-09 17:04:23.664292
2	6775098944896508215	f	ACTIVE	2021-03-09 17:04:23.664292
2	6775098944893885687	f	ACTIVE	2021-03-09 17:04:23.664292
3	6775098944857779980	f	RETRACTED	2021-03-09 17:04:23.664292
3	6775098944887195566	f	EXPIRED	2021-03-09 17:04:23.664292
2	6775098944883426365	f	RETRACTED	2021-07-13 16:59:57.559861
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tags (id, name, parent_id, mut_exclusive) FROM stdin;
1	Täääg3	\N	f
2	Tag1	\N	f
3	Tag2	\N	f
\.


--
-- Data for Name: urns; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.urns (id, voting_id, accepted, location, description, opening) FROM stdin;
\.


--
-- Data for Name: urnsupporters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.urnsupporters (member_id, urn_id, type, voted) FROM stdin;
\.


--
-- Data for Name: user_login_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_login_token (token, user_id, valid_until) FROM stdin;
\.


--
-- Data for Name: userpassword; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.userpassword (user_id, hashed_password) FROM stdin;
1	admin
2	test
\.


--
-- Data for Name: userprofiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.userprofiles (id, sub, eligible, verified, profile) FROM stdin;
3	sub_egon	t	t	ich halt
4	sub_olaf	f	t	## Markdown\n\nText
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, auth_type, joined, active, last_active, can_login_until) FROM stdin;
1	testadmin	\N	system	2021-03-09 17:04:23.664292	t	2021-03-09 17:04:23.664292	\N
2	testuser	\N	system	2021-03-09 17:04:23.664292	t	2021-03-09 17:04:23.664292	\N
3	egon	\N	oauth	2021-03-09 17:04:23.664292	t	2021-03-09 17:04:23.664292	\N
4	depadmin	\N	oauth	2021-03-09 17:04:23.664292	t	2021-03-09 17:04:23.664292	\N
\.


--
-- Data for Name: voting_module; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.voting_module (id, name, description, base_url, module_type) FROM stdin;
\.


--
-- Data for Name: voting_phase_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.voting_phase_types (id, name, abbreviation, secret_voting_possible, voting_type, description, voting_days, registration_start_days, registration_end_days) FROM stdin;
1	Bundesparteitag	BPT	t	ASSEMBLY		\N	\N	\N
2	Online-Urabstimmung	UR	f	ONLINE		14	\N	\N
\.


--
-- Data for Name: votingphases; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.votingphases (id, status, target, department_id, phase_type_id, secret, name, title, description, voting_module_data, voting_days, registration_start_days, registration_end_days) FROM stdin;
2	PREPARING	\N	5	2	f	ur19+	Urabstimmung 2019+	eine **Urabstimmung** in Zentalschweiz	{}	\N	\N	\N
3	FINISHED	2019-11-10 00:00:00	3	1	t	bpt192	BPT 2019.2	Der BPT in Bad Homburg	{}	\N	\N	\N
1	PREPARING	2020-11-11 00:00:00	3	1	t	bpt201	BPT 2020.1	Der nächste Parteitag irgendwo	{}	2	\N	\N
\.


--
-- Name: argumentrelations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.argumentrelations_id_seq', 463, true);


--
-- Name: arguments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.arguments_id_seq', 463, true);


--
-- Name: ballots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ballots_id_seq', 1436, true);


--
-- Name: changeset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.changeset_id_seq', 46, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.departments_id_seq', 2489, true);


--
-- Name: document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.document_id_seq', 185, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.groups_id_seq', 830, true);


--
-- Name: policies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.policies_id_seq', 1749, true);


--
-- Name: propositiontypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.propositiontypes_id_seq', 1704, true);


--
-- Name: subjectareas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subjectareas_id_seq', 6260, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tags_id_seq', 2211, true);


--
-- Name: urns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.urns_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 2350, true);


--
-- Name: voting_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.voting_module_id_seq', 1, false);


--
-- Name: voting_phase_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.voting_phase_types_id_seq', 416, true);


--
-- Name: votingphases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.votingphases_id_seq', 325, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: areamembers pk_areamembers; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areamembers
    ADD CONSTRAINT pk_areamembers PRIMARY KEY (area_id, member_id);


--
-- Name: argumentrelations pk_argumentrelations; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentrelations
    ADD CONSTRAINT pk_argumentrelations PRIMARY KEY (id);


--
-- Name: arguments pk_arguments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arguments
    ADD CONSTRAINT pk_arguments PRIMARY KEY (id);


--
-- Name: argumentvotes pk_argumentvotes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentvotes
    ADD CONSTRAINT pk_argumentvotes PRIMARY KEY (member_id, relation_id);


--
-- Name: ballots pk_ballots; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ballots
    ADD CONSTRAINT pk_ballots PRIMARY KEY (id);


--
-- Name: changeset pk_changeset; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changeset
    ADD CONSTRAINT pk_changeset PRIMARY KEY (id);


--
-- Name: customizable_text pk_customizable_text; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customizable_text
    ADD CONSTRAINT pk_customizable_text PRIMARY KEY (name, lang);


--
-- Name: departmentmembers pk_departmentmembers; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departmentmembers
    ADD CONSTRAINT pk_departmentmembers PRIMARY KEY (department_id, member_id);


--
-- Name: departments pk_departments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT pk_departments PRIMARY KEY (id);


--
-- Name: document pk_document; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT pk_document PRIMARY KEY (id);


--
-- Name: groupmembers pk_groupmembers; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groupmembers
    ADD CONSTRAINT pk_groupmembers PRIMARY KEY (group_id, member_id);


--
-- Name: groups pk_groups; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT pk_groups PRIMARY KEY (id);


--
-- Name: oauth_token pk_oauth_token; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_token
    ADD CONSTRAINT pk_oauth_token PRIMARY KEY (id);


--
-- Name: page pk_page; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page
    ADD CONSTRAINT pk_page PRIMARY KEY (name, lang);


--
-- Name: policies pk_policies; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT pk_policies PRIMARY KEY (id);


--
-- Name: postalvotes pk_postalvotes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postalvotes
    ADD CONSTRAINT pk_postalvotes PRIMARY KEY (member_id, voting_id);


--
-- Name: propositionnotes pk_propositionnotes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositionnotes
    ADD CONSTRAINT pk_propositionnotes PRIMARY KEY (proposition_id, user_id);


--
-- Name: propositions pk_propositions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositions
    ADD CONSTRAINT pk_propositions PRIMARY KEY (id);


--
-- Name: propositiontags pk_propositiontags; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontags
    ADD CONSTRAINT pk_propositiontags PRIMARY KEY (proposition_id, tag_id);


--
-- Name: propositiontypes pk_propositiontypes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontypes
    ADD CONSTRAINT pk_propositiontypes PRIMARY KEY (id);


--
-- Name: secretvoters pk_secretvoters; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secretvoters
    ADD CONSTRAINT pk_secretvoters PRIMARY KEY (member_id, ballot_id);


--
-- Name: subjectareas pk_subjectareas; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjectareas
    ADD CONSTRAINT pk_subjectareas PRIMARY KEY (id);


--
-- Name: supporters pk_supporters; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supporters
    ADD CONSTRAINT pk_supporters PRIMARY KEY (member_id, proposition_id);


--
-- Name: tags pk_tags; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT pk_tags PRIMARY KEY (id);


--
-- Name: urns pk_urns; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urns
    ADD CONSTRAINT pk_urns PRIMARY KEY (id);


--
-- Name: urnsupporters pk_urnsupporters; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urnsupporters
    ADD CONSTRAINT pk_urnsupporters PRIMARY KEY (member_id, urn_id);


--
-- Name: user_login_token pk_user_login_token; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_login_token
    ADD CONSTRAINT pk_user_login_token PRIMARY KEY (token);


--
-- Name: userpassword pk_userpassword; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpassword
    ADD CONSTRAINT pk_userpassword PRIMARY KEY (user_id);


--
-- Name: userprofiles pk_userprofiles; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userprofiles
    ADD CONSTRAINT pk_userprofiles PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: voting_module pk_voting_module; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_module
    ADD CONSTRAINT pk_voting_module PRIMARY KEY (id);


--
-- Name: voting_phase_types pk_voting_phase_types; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_phase_types
    ADD CONSTRAINT pk_voting_phase_types PRIMARY KEY (id);


--
-- Name: votingphases pk_votingphases; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votingphases
    ADD CONSTRAINT pk_votingphases PRIMARY KEY (id);


--
-- Name: departments uq_departments_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT uq_departments_name UNIQUE (name);


--
-- Name: document uq_document_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT uq_document_name UNIQUE (name, lang, area_id);


--
-- Name: groups uq_groups_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT uq_groups_name UNIQUE (name);


--
-- Name: policies uq_policies_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT uq_policies_name UNIQUE (name);


--
-- Name: propositiontypes uq_propositiontypes_abbreviation; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontypes
    ADD CONSTRAINT uq_propositiontypes_abbreviation UNIQUE (abbreviation);


--
-- Name: propositiontypes uq_propositiontypes_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontypes
    ADD CONSTRAINT uq_propositiontypes_name UNIQUE (name);


--
-- Name: tags uq_tags_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT uq_tags_name UNIQUE (name);


--
-- Name: userprofiles uq_userprofiles_sub; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userprofiles
    ADD CONSTRAINT uq_userprofiles_sub UNIQUE (sub);


--
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: users uq_users_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_name UNIQUE (name);


--
-- Name: voting_module uq_voting_module_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_module
    ADD CONSTRAINT uq_voting_module_name UNIQUE (name);


--
-- Name: ix_propositions_search_vector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_propositions_search_vector ON public.propositions USING gin (search_vector);


--
-- Name: propositions propositions_search_vector_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER propositions_search_vector_trigger BEFORE INSERT OR UPDATE ON public.propositions FOR EACH ROW EXECUTE FUNCTION public.propositions_search_vector_update();


--
-- Name: areamembers fk_areamembers_area_id_subjectareas; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areamembers
    ADD CONSTRAINT fk_areamembers_area_id_subjectareas FOREIGN KEY (area_id) REFERENCES public.subjectareas(id);


--
-- Name: areamembers fk_areamembers_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areamembers
    ADD CONSTRAINT fk_areamembers_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: argumentrelations fk_argumentrelations_argument_id_arguments; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentrelations
    ADD CONSTRAINT fk_argumentrelations_argument_id_arguments FOREIGN KEY (argument_id) REFERENCES public.arguments(id);


--
-- Name: argumentrelations fk_argumentrelations_parent_id_argumentrelations; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentrelations
    ADD CONSTRAINT fk_argumentrelations_parent_id_argumentrelations FOREIGN KEY (parent_id) REFERENCES public.argumentrelations(id);


--
-- Name: argumentrelations fk_argumentrelations_proposition_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentrelations
    ADD CONSTRAINT fk_argumentrelations_proposition_id_propositions FOREIGN KEY (proposition_id) REFERENCES public.propositions(id);


--
-- Name: arguments fk_arguments_author_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arguments
    ADD CONSTRAINT fk_arguments_author_id_users FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: argumentvotes fk_argumentvotes_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentvotes
    ADD CONSTRAINT fk_argumentvotes_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: argumentvotes fk_argumentvotes_relation_id_argumentrelations; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.argumentvotes
    ADD CONSTRAINT fk_argumentvotes_relation_id_argumentrelations FOREIGN KEY (relation_id) REFERENCES public.argumentrelations(id);


--
-- Name: ballots fk_ballots_area_id_subjectareas; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ballots
    ADD CONSTRAINT fk_ballots_area_id_subjectareas FOREIGN KEY (area_id) REFERENCES public.subjectareas(id);


--
-- Name: ballots fk_ballots_proposition_type_id_propositiontypes; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ballots
    ADD CONSTRAINT fk_ballots_proposition_type_id_propositiontypes FOREIGN KEY (proposition_type_id) REFERENCES public.propositiontypes(id);


--
-- Name: ballots fk_ballots_voting_id_votingphases; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ballots
    ADD CONSTRAINT fk_ballots_voting_id_votingphases FOREIGN KEY (voting_id) REFERENCES public.votingphases(id);


--
-- Name: changeset fk_changeset_document_id_document; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changeset
    ADD CONSTRAINT fk_changeset_document_id_document FOREIGN KEY (document_id) REFERENCES public.document(id);


--
-- Name: changeset fk_changeset_proposition_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changeset
    ADD CONSTRAINT fk_changeset_proposition_id_propositions FOREIGN KEY (proposition_id) REFERENCES public.propositions(id);


--
-- Name: departmentmembers fk_departmentmembers_department_id_departments; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departmentmembers
    ADD CONSTRAINT fk_departmentmembers_department_id_departments FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: departmentmembers fk_departmentmembers_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departmentmembers
    ADD CONSTRAINT fk_departmentmembers_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: document fk_document_area_id_subjectareas; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT fk_document_area_id_subjectareas FOREIGN KEY (area_id) REFERENCES public.subjectareas(id);


--
-- Name: document fk_document_proposition_type_id_propositiontypes; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT fk_document_proposition_type_id_propositiontypes FOREIGN KEY (proposition_type_id) REFERENCES public.propositiontypes(id);


--
-- Name: groupmembers fk_groupmembers_group_id_groups; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groupmembers
    ADD CONSTRAINT fk_groupmembers_group_id_groups FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: groupmembers fk_groupmembers_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groupmembers
    ADD CONSTRAINT fk_groupmembers_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: oauth_token fk_oauth_token_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_token
    ADD CONSTRAINT fk_oauth_token_id_users FOREIGN KEY (id) REFERENCES public.users(id);


--
-- Name: postalvotes fk_postalvotes_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postalvotes
    ADD CONSTRAINT fk_postalvotes_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: postalvotes fk_postalvotes_voting_id_votingphases; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postalvotes
    ADD CONSTRAINT fk_postalvotes_voting_id_votingphases FOREIGN KEY (voting_id) REFERENCES public.votingphases(id);


--
-- Name: propositionnotes fk_propositionnotes_proposition_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositionnotes
    ADD CONSTRAINT fk_propositionnotes_proposition_id_propositions FOREIGN KEY (proposition_id) REFERENCES public.propositions(id);


--
-- Name: propositionnotes fk_propositionnotes_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositionnotes
    ADD CONSTRAINT fk_propositionnotes_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: propositions fk_propositions_author_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositions
    ADD CONSTRAINT fk_propositions_author_id_users FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: propositions fk_propositions_ballot_id_ballots; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositions
    ADD CONSTRAINT fk_propositions_ballot_id_ballots FOREIGN KEY (ballot_id) REFERENCES public.ballots(id);


--
-- Name: propositions fk_propositions_modifies_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositions
    ADD CONSTRAINT fk_propositions_modifies_id_propositions FOREIGN KEY (modifies_id) REFERENCES public.propositions(id);


--
-- Name: propositions fk_propositions_replaces_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositions
    ADD CONSTRAINT fk_propositions_replaces_id_propositions FOREIGN KEY (replaces_id) REFERENCES public.propositions(id);


--
-- Name: propositiontags fk_propositiontags_proposition_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontags
    ADD CONSTRAINT fk_propositiontags_proposition_id_propositions FOREIGN KEY (proposition_id) REFERENCES public.propositions(id);


--
-- Name: propositiontags fk_propositiontags_tag_id_tags; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontags
    ADD CONSTRAINT fk_propositiontags_tag_id_tags FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: propositiontypes fk_propositiontypes_policy_id_policies; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.propositiontypes
    ADD CONSTRAINT fk_propositiontypes_policy_id_policies FOREIGN KEY (policy_id) REFERENCES public.policies(id);


--
-- Name: secretvoters fk_secretvoters_ballot_id_ballots; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secretvoters
    ADD CONSTRAINT fk_secretvoters_ballot_id_ballots FOREIGN KEY (ballot_id) REFERENCES public.ballots(id);


--
-- Name: secretvoters fk_secretvoters_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secretvoters
    ADD CONSTRAINT fk_secretvoters_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: subjectareas fk_subjectareas_department_id_departments; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjectareas
    ADD CONSTRAINT fk_subjectareas_department_id_departments FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: supporters fk_supporters_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supporters
    ADD CONSTRAINT fk_supporters_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: supporters fk_supporters_proposition_id_propositions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supporters
    ADD CONSTRAINT fk_supporters_proposition_id_propositions FOREIGN KEY (proposition_id) REFERENCES public.propositions(id);


--
-- Name: tags fk_tags_parent_id_tags; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_tags_parent_id_tags FOREIGN KEY (parent_id) REFERENCES public.tags(id);


--
-- Name: urns fk_urns_voting_id_votingphases; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urns
    ADD CONSTRAINT fk_urns_voting_id_votingphases FOREIGN KEY (voting_id) REFERENCES public.votingphases(id);


--
-- Name: urnsupporters fk_urnsupporters_member_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urnsupporters
    ADD CONSTRAINT fk_urnsupporters_member_id_users FOREIGN KEY (member_id) REFERENCES public.users(id);


--
-- Name: urnsupporters fk_urnsupporters_urn_id_urns; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urnsupporters
    ADD CONSTRAINT fk_urnsupporters_urn_id_urns FOREIGN KEY (urn_id) REFERENCES public.urns(id);


--
-- Name: user_login_token fk_user_login_token_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_login_token
    ADD CONSTRAINT fk_user_login_token_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: userpassword fk_userpassword_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpassword
    ADD CONSTRAINT fk_userpassword_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: userprofiles fk_userprofiles_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userprofiles
    ADD CONSTRAINT fk_userprofiles_id_users FOREIGN KEY (id) REFERENCES public.users(id);


--
-- Name: votingphases fk_votingphases_department_id_departments; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votingphases
    ADD CONSTRAINT fk_votingphases_department_id_departments FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: votingphases fk_votingphases_phase_type_id_voting_phase_types; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votingphases
    ADD CONSTRAINT fk_votingphases_phase_type_id_voting_phase_types FOREIGN KEY (phase_type_id) REFERENCES public.voting_phase_types(id);


--
-- PostgreSQL database dump complete
--

