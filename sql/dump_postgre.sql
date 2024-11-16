--
-- PostgreSQL database dump
--

-- Dumped from database version 16.5
-- Dumped by pg_dump version 16.1

-- Started on 2024-11-16 16:31:15

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

--
-- TOC entry 6 (class 2615 OID 32768)
-- Name: raja_laundry; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA raja_laundry;


--
-- TOC entry 252 (class 1255 OID 49166)
-- Name: on_delete_item_pesanan(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_delete_item_pesanan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM recalculate_total_item(OLD.ID_PESANAN);
    RETURN OLD;
END;
$$;


--
-- TOC entry 249 (class 1255 OID 49160)
-- Name: on_delete_kupon(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_delete_kupon() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM recalculate_total_item(OLD.ID_PESANAN);
    RETURN OLD;
END;
$$;


--
-- TOC entry 245 (class 1255 OID 49152)
-- Name: on_insert_item_kupon(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_insert_item_kupon() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT TRUE
        FROM pesanan P, kupon K
        WHERE P.ID_PESANAN = K.ID_PESANAN
            AND P.ID_PESANAN = NEW.ID_PESANAN
            AND K.ID_KUPON = NEW.ID_KUPON
    ) THEN
        RAISE EXCEPTION 'Pesanan tidak boleh menjadi kupon pesanan itu sendiri';
    END IF;

    IF NOT EXISTS (
        SELECT TRUE 
        FROM pesanan P
        WHERE P.ID_PESANAN = NEW.ID_PESANAN
            AND P.TANGGAL_LUNAS IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Kwitansi tidak ditemukan';
    END IF;

    RETURN NEW;
END;
$$;


--
-- TOC entry 250 (class 1255 OID 49162)
-- Name: on_insert_item_pesanan(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_insert_item_pesanan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$;


--
-- TOC entry 246 (class 1255 OID 49154)
-- Name: on_insert_kupon(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_insert_kupon() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$;


--
-- TOC entry 247 (class 1255 OID 49156)
-- Name: on_update_item_kupon(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_update_item_kupon() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT TRUE
        FROM pesanan P, kupon K
        WHERE P.ID_PESANAN = K.ID_PESANAN
            AND P.ID_PESANAN = NEW.ID_PESANAN
            AND K.ID_KUPON = NEW.ID_KUPON
    ) THEN
        RAISE EXCEPTION 'Pesanan tidak boleh menjadi kupon pesanan itu sendiri';
    END IF;

    IF NOT EXISTS (
        SELECT TRUE 
        FROM pesanan P
        WHERE P.ID_PESANAN = NEW.ID_PESANAN
            AND P.TANGGAL_LUNAS IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Kwitansi tidak ditemukan';
    END IF;

    RETURN NEW;
END;
$$;


--
-- TOC entry 251 (class 1255 OID 49164)
-- Name: on_update_item_pesanan(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_update_item_pesanan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$;


--
-- TOC entry 248 (class 1255 OID 49158)
-- Name: on_update_kupon(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.on_update_kupon() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$;


--
-- TOC entry 253 (class 1255 OID 49168)
-- Name: pengeluaran_default_date(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.pengeluaran_default_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.TANGGAL_PENGELUARAN IS NULL THEN
        NEW.TANGGAL_PENGELUARAN := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 254 (class 1255 OID 49170)
-- Name: pesanan_default_date(); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.pesanan_default_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.TANGGAL_PESANAN IS NULL THEN
        NEW.TANGGAL_PESANAN := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 255 (class 1255 OID 49172)
-- Name: recalculate_total_item(integer); Type: FUNCTION; Schema: raja_laundry; Owner: -
--

CREATE FUNCTION raja_laundry.recalculate_total_item(id_pesanan integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE pesanan p
    SET p.subtotal = (
            SELECT SUM(ip.HARGA) 
            FROM item_pesanan ip 
            WHERE ip.ID_PESANAN = ID_PESANAN
        ),
        p.total = p.subtotal - COALESCE((
            SELECT k.POTONGAN
            FROM kupon k
            WHERE k.ID_PESANAN = ID_PESANAN
        ), 0)
    WHERE p.ID_PESANAN = ID_PESANAN;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 32769)
-- Name: customer; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.customer (
    id_customer bigint NOT NULL,
    nama_customer character varying(50) NOT NULL,
    alamat_customer character varying(100),
    telepon_customer character varying(16)
);


--
-- TOC entry 217 (class 1259 OID 32772)
-- Name: customer_id_customer_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.customer_id_customer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 217
-- Name: customer_id_customer_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.customer_id_customer_seq OWNED BY raja_laundry.customer.id_customer;


--
-- TOC entry 218 (class 1259 OID 32773)
-- Name: item_kupon; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.item_kupon (
    id_pesanan bigint NOT NULL,
    id_kupon bigint NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 32776)
-- Name: item_pesanan; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.item_pesanan (
    id_item bigint NOT NULL,
    id_pesanan bigint NOT NULL,
    id_paket bigint NOT NULL,
    id_unit bigint DEFAULT '10'::bigint,
    qty bigint DEFAULT '1'::bigint,
    harga bigint DEFAULT '0'::bigint NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 32782)
-- Name: item_pesanan_id_item_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.item_pesanan_id_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3460 (class 0 OID 0)
-- Dependencies: 220
-- Name: item_pesanan_id_item_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.item_pesanan_id_item_seq OWNED BY raja_laundry.item_pesanan.id_item;


--
-- TOC entry 221 (class 1259 OID 32783)
-- Name: kupon; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.kupon (
    id_kupon bigint NOT NULL,
    id_pesanan bigint,
    id_customer bigint,
    potongan bigint NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 32786)
-- Name: kupon_id_kupon_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.kupon_id_kupon_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 222
-- Name: kupon_id_kupon_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.kupon_id_kupon_seq OWNED BY raja_laundry.kupon.id_kupon;


--
-- TOC entry 227 (class 1259 OID 32795)
-- Name: pesanan; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.pesanan (
    id_pesanan bigint NOT NULL,
    id_customer bigint NOT NULL,
    nota bigint,
    tanggal_pesanan date,
    tanggal_lunas date,
    tanggal_ambil date,
    subtotal bigint DEFAULT '0'::bigint NOT NULL,
    total bigint DEFAULT '0'::bigint NOT NULL,
    keterangan character varying(255)
);


--
-- TOC entry 231 (class 1259 OID 49173)
-- Name: monthly_pemasukan_stats; Type: VIEW; Schema: raja_laundry; Owner: -
--

CREATE VIEW raja_laundry.monthly_pemasukan_stats AS
 SELECT EXTRACT(year FROM tanggal_lunas) AS tahun,
    EXTRACT(month FROM tanggal_lunas) AS bulan,
    count(0) AS jumlah,
    sum(total) AS total
   FROM raja_laundry.pesanan p
  WHERE (tanggal_lunas IS NOT NULL)
  GROUP BY (EXTRACT(year FROM tanggal_lunas)), (EXTRACT(month FROM tanggal_lunas))
  ORDER BY (EXTRACT(year FROM tanggal_lunas)) DESC, (EXTRACT(month FROM tanggal_lunas)) DESC;


--
-- TOC entry 225 (class 1259 OID 32791)
-- Name: pengeluaran; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.pengeluaran (
    id_pengeluaran bigint NOT NULL,
    tanggal_pengeluaran date NOT NULL,
    item_pengeluaran character varying(50) NOT NULL,
    jumlah_pengeluaran bigint NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 49177)
-- Name: monthly_pengeluaran_stats; Type: VIEW; Schema: raja_laundry; Owner: -
--

CREATE VIEW raja_laundry.monthly_pengeluaran_stats AS
 SELECT EXTRACT(year FROM tanggal_pengeluaran) AS tahun,
    EXTRACT(month FROM tanggal_pengeluaran) AS bulan,
    count(0) AS jumlah,
    sum(jumlah_pengeluaran) AS total
   FROM raja_laundry.pengeluaran pl
  GROUP BY (EXTRACT(year FROM tanggal_pengeluaran)), (EXTRACT(month FROM tanggal_pengeluaran))
  ORDER BY (EXTRACT(year FROM tanggal_pengeluaran)) DESC, (EXTRACT(month FROM tanggal_pengeluaran)) DESC;


--
-- TOC entry 223 (class 1259 OID 32787)
-- Name: paket; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.paket (
    id_paket bigint NOT NULL,
    paket character varying(16) NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 32790)
-- Name: paket_id_paket_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.paket_id_paket_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 224
-- Name: paket_id_paket_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.paket_id_paket_seq OWNED BY raja_laundry.paket.id_paket;


--
-- TOC entry 226 (class 1259 OID 32794)
-- Name: pengeluaran_id_pengeluaran_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.pengeluaran_id_pengeluaran_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 226
-- Name: pengeluaran_id_pengeluaran_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.pengeluaran_id_pengeluaran_seq OWNED BY raja_laundry.pengeluaran.id_pengeluaran;


--
-- TOC entry 233 (class 1259 OID 49181)
-- Name: pesanan_customer; Type: VIEW; Schema: raja_laundry; Owner: -
--

CREATE VIEW raja_laundry.pesanan_customer AS
 SELECT p.id_pesanan,
    p.id_customer,
    p.tanggal_pesanan,
    p.tanggal_lunas,
    p.tanggal_ambil,
    p.subtotal,
    p.total,
    p.keterangan,
    c.nama_customer
   FROM (raja_laundry.pesanan p
     JOIN raja_laundry.customer c ON ((p.id_customer = c.id_customer)));


--
-- TOC entry 228 (class 1259 OID 32800)
-- Name: pesanan_id_pesanan_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.pesanan_id_pesanan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 228
-- Name: pesanan_id_pesanan_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.pesanan_id_pesanan_seq OWNED BY raja_laundry.pesanan.id_pesanan;


--
-- TOC entry 229 (class 1259 OID 32801)
-- Name: unit; Type: TABLE; Schema: raja_laundry; Owner: -
--

CREATE TABLE raja_laundry.unit (
    id_unit bigint NOT NULL,
    unit character varying(16) NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 32804)
-- Name: unit_id_unit_seq; Type: SEQUENCE; Schema: raja_laundry; Owner: -
--

CREATE SEQUENCE raja_laundry.unit_id_unit_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 230
-- Name: unit_id_unit_seq; Type: SEQUENCE OWNED BY; Schema: raja_laundry; Owner: -
--

ALTER SEQUENCE raja_laundry.unit_id_unit_seq OWNED BY raja_laundry.unit.id_unit;


--
-- TOC entry 3238 (class 2604 OID 32805)
-- Name: customer id_customer; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.customer ALTER COLUMN id_customer SET DEFAULT nextval('raja_laundry.customer_id_customer_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 32806)
-- Name: item_pesanan id_item; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_pesanan ALTER COLUMN id_item SET DEFAULT nextval('raja_laundry.item_pesanan_id_item_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 32807)
-- Name: kupon id_kupon; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.kupon ALTER COLUMN id_kupon SET DEFAULT nextval('raja_laundry.kupon_id_kupon_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 32808)
-- Name: paket id_paket; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.paket ALTER COLUMN id_paket SET DEFAULT nextval('raja_laundry.paket_id_paket_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 32809)
-- Name: pengeluaran id_pengeluaran; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.pengeluaran ALTER COLUMN id_pengeluaran SET DEFAULT nextval('raja_laundry.pengeluaran_id_pengeluaran_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 32810)
-- Name: pesanan id_pesanan; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.pesanan ALTER COLUMN id_pesanan SET DEFAULT nextval('raja_laundry.pesanan_id_pesanan_seq'::regclass);


--
-- TOC entry 3249 (class 2604 OID 32811)
-- Name: unit id_unit; Type: DEFAULT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.unit ALTER COLUMN id_unit SET DEFAULT nextval('raja_laundry.unit_id_unit_seq'::regclass);


--
-- TOC entry 3439 (class 0 OID 32769)
-- Dependencies: 216
-- Data for Name: customer; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--

INSERT INTO raja_laundry.customer VALUES (1, '??', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (2, 'Aan', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (3, 'Adiu', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (4, 'AE9', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (5, 'Agus', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (6, 'Ailis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (7, 'Aji', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (8, 'Akbar', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (9, 'Aldi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (10, 'Ali', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (11, 'Alsi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (12, 'Ambar', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (13, 'Amel', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (14, 'Amil', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (15, 'Amin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (16, 'Aminah', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (17, 'Amira', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (18, 'Ana', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (19, 'Andre', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (20, 'Ani', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (21, 'Anies', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (22, 'Anik', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (23, 'Anin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (24, 'Anis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (25, 'Ansri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (26, 'Antho', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (27, 'Arina', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (28, 'Asad', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (29, 'Atik', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (30, 'Aulia', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (31, 'Bambang', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (32, 'Boneka', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (33, 'Brei', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (34, 'Budiarso', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (35, 'Caca', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (36, 'Celsi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (37, 'Cili', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (38, 'D116', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (39, 'Dani', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (40, 'Dava', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (41, 'Debi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (42, 'Dedi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (43, 'Dedy', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (44, 'Deni', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (45, 'Denis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (46, 'Deri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (47, 'Devi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (48, 'Devita', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (49, 'Dewi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (50, 'Dias', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (51, 'Didin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (52, 'Didit', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (53, 'Dika', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (54, 'Dimin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (55, 'Dina', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (56, 'Disnin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (57, 'Duwi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (58, 'E', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (59, 'Elis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (60, 'Elok', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (61, 'Emi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (62, 'Enis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (63, 'Enum', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (64, 'Epani', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (65, 'Erlin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (66, 'Eruni', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (67, 'Erwin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (68, 'Etik', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (69, 'Falent', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (70, 'Fani', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (71, 'Feni', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (72, 'Feri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (73, 'Fitri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (74, 'Frida', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (75, 'Haito', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (76, 'Hana', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (77, 'Haris', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (78, 'Harto', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (79, 'Hen', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (80, 'Hendra', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (81, 'Hendrik', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (82, 'Heri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (83, 'Hestia', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (84, 'Hidayat', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (85, 'Ida', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (86, 'Iin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (87, 'Iis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (88, 'Ika', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (89, 'Ilis', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (90, 'Ima', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (91, 'Imran', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (92, 'Ina', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (93, 'Indah', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (94, 'Ipul', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (95, 'Ita', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (96, 'Iwan', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (97, 'Jani', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (98, 'Jeli', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (99, 'Joko', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (100, 'K10', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (101, 'K4', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (102, 'Kaban', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (103, 'Karpet', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (104, 'Keizi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (105, 'Kinan', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (106, 'KLbu', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (107, 'Kondan', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (108, 'Koyum', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (109, 'Leli', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (110, 'Lia', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (111, 'Lili', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (112, 'Ling', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (113, 'Malika', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (114, 'Malka', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (115, 'Maria', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (116, 'Maula', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (117, 'Maulana', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (118, 'Mega', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (119, 'Melinda', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (120, 'Micel', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (121, 'Miya', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (122, 'Mulyana', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (123, 'Nadi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (124, 'Nam', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (125, 'Nama lupa', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (126, 'Nanda', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (127, 'Nasya', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (128, 'Nia', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (129, 'Nikfuk', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (130, 'Nita', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (131, 'Nur', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (132, 'Nyata', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (133, 'Padi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (134, 'Pipit', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (135, 'Priska', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (136, 'Putri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (137, 'R 10', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (138, 'Ramli', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (139, 'Rani', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (140, 'RI4', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (141, 'Riadi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (142, 'Rifa', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (143, 'Rin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (144, 'Rizal', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (145, 'Rudi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (146, 'Saiji', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (147, 'Salma', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (148, 'Samsi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (149, 'Sandi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (150, 'Santi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (151, 'Sari', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (152, 'Sate', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (153, 'Sausi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (154, 'SI Ktuk', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (155, 'Silir', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (156, 'Sinta', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (157, 'Siva', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (158, 'Sofa', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (159, 'Suisa?', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (160, 'Sukina', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (161, 'Sukma', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (162, 'Sum', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (163, 'Susi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (164, 'Tabita', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (165, 'Tanto', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (166, 'Tarno', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (167, 'Taso', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (168, 'Teli', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (169, 'Tias', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (170, 'Tiko', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (171, 'Tina', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (172, 'Tito', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (173, 'Tiwo', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (174, 'Toluk', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (175, 'Tono', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (176, 'Totok', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (177, 'Vidi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (178, 'Viktor', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (179, 'Vin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (180, 'Vita', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (181, 'Vivi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (182, 'W', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (183, 'Webi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (184, 'Wedi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (185, 'Weni', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (186, 'Widi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (187, 'Wili', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (188, 'Wito', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (189, 'Wiwin', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (190, 'Wuri', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (191, 'Yanti', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (192, 'Yeni', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (193, 'Yogi', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (194, 'Yuni', NULL, NULL);
INSERT INTO raja_laundry.customer VALUES (195, 'Yusuf', NULL, NULL);


--
-- TOC entry 3441 (class 0 OID 32773)
-- Dependencies: 218
-- Data for Name: item_kupon; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--



--
-- TOC entry 3442 (class 0 OID 32776)
-- Dependencies: 219
-- Data for Name: item_pesanan; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--

INSERT INTO raja_laundry.item_pesanan VALUES (1, 1, 6, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (2, 2, 7, 17, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (3, 3, 6, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (4, 4, 9, 10, 9, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (5, 5, 4, 10, 9, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (6, 6, 6, 7, 1, 5000);
INSERT INTO raja_laundry.item_pesanan VALUES (7, 7, 5, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (8, 8, 6, 10, 9, 45000);
INSERT INTO raja_laundry.item_pesanan VALUES (9, 9, 9, 10, 14, 54000);
INSERT INTO raja_laundry.item_pesanan VALUES (10, 10, 6, 10, 7, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (11, 10, 6, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (12, 11, 9, 10, 3, 12000);
INSERT INTO raja_laundry.item_pesanan VALUES (13, 12, 6, 10, 6, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (14, 13, 11, 16, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (15, 14, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (16, 15, 6, 10, 7, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (17, 15, 6, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (18, 16, 9, 10, 10, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (19, 17, 9, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (20, 18, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (21, 19, 5, 10, 11, 44000);
INSERT INTO raja_laundry.item_pesanan VALUES (22, 20, 7, 4, 2, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (23, 21, 9, 10, 6, 22000);
INSERT INTO raja_laundry.item_pesanan VALUES (24, 22, 6, 10, 10, 47500);
INSERT INTO raja_laundry.item_pesanan VALUES (25, 23, 4, 10, 9, 25500);
INSERT INTO raja_laundry.item_pesanan VALUES (26, 24, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (27, 25, 4, 10, 5, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (28, 26, 6, 1, 2, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (29, 27, 6, 10, 12, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (30, 28, 6, 15, 1, 55000);
INSERT INTO raja_laundry.item_pesanan VALUES (31, 29, 6, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (32, 30, 6, 1, 1, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (33, 31, 5, 10, 6, 34000);
INSERT INTO raja_laundry.item_pesanan VALUES (34, 31, 5, 15, 2, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (35, 32, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (36, 33, 4, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (37, 34, 5, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (38, 35, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (39, 36, 9, 10, 7, 26000);
INSERT INTO raja_laundry.item_pesanan VALUES (40, 37, 9, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (41, 38, 9, 10, 2, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (42, 39, 9, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (43, 40, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (44, 41, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (45, 42, 6, 10, 1, 26000);
INSERT INTO raja_laundry.item_pesanan VALUES (46, 42, 9, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (47, 43, 5, 10, 7, 26000);
INSERT INTO raja_laundry.item_pesanan VALUES (48, 44, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (49, 45, 9, 10, 15, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (50, 46, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (51, 47, 5, 10, 3, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (52, 48, 11, 14, 3, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (53, 49, 6, 10, 5, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (54, 49, 6, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (55, 50, 5, 10, 25, 100000);
INSERT INTO raja_laundry.item_pesanan VALUES (56, 51, 11, 14, 5, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (57, 52, 5, 10, 8, 32000);
INSERT INTO raja_laundry.item_pesanan VALUES (58, 53, 6, 10, 1, 75000);
INSERT INTO raja_laundry.item_pesanan VALUES (59, 54, 5, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (60, 55, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (61, 56, 9, 10, 1, 85000);
INSERT INTO raja_laundry.item_pesanan VALUES (62, 56, 6, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (63, 57, 5, 10, 4, 14000);
INSERT INTO raja_laundry.item_pesanan VALUES (64, 58, 6, 10, 10, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (65, 59, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (66, 60, 9, 10, 4, 18000);
INSERT INTO raja_laundry.item_pesanan VALUES (67, 61, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (68, 62, 9, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (69, 63, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (70, 64, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (71, 65, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (72, 65, 10, 10, 2, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (73, 66, 6, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (74, 67, 6, 10, 13, 65000);
INSERT INTO raja_laundry.item_pesanan VALUES (75, 68, 5, 8, 1, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (76, 69, 9, 10, 20, 78000);
INSERT INTO raja_laundry.item_pesanan VALUES (77, 70, 7, 9, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (78, 71, 9, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (79, 72, 9, 10, 5, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (80, 73, 5, 10, 4, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (81, 74, 4, 10, 10, 28500);
INSERT INTO raja_laundry.item_pesanan VALUES (82, 75, 5, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (83, 76, 6, 10, 1, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (84, 77, 9, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (85, 78, 9, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (86, 79, 6, 10, 7, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (87, 80, 6, 10, 7, 32500);
INSERT INTO raja_laundry.item_pesanan VALUES (88, 81, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (89, 82, 9, 10, 10, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (90, 83, 9, 10, 3, 12000);
INSERT INTO raja_laundry.item_pesanan VALUES (91, 84, 6, 10, 1, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (92, 85, 5, 10, 7, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (93, 86, 5, 10, 5, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (94, 87, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (95, 88, 9, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (96, 89, 9, 10, 2, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (97, 90, 9, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (98, 91, 9, 10, 10, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (99, 92, 5, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (100, 93, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (101, 94, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (102, 95, 5, 10, 6, 22000);
INSERT INTO raja_laundry.item_pesanan VALUES (103, 96, 6, 1, 2, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (104, 97, 9, 10, 8, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (105, 98, 5, 10, 1, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (106, 99, 5, 10, 6, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (107, 100, 6, 10, 9, 45000);
INSERT INTO raja_laundry.item_pesanan VALUES (108, 101, 6, 10, 1, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (109, 101, 6, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (110, 102, 6, 1, 1, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (111, 103, 6, 15, 1, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (112, 103, 6, 1, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (113, 104, 9, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (114, 105, 6, 10, 7, 32500);
INSERT INTO raja_laundry.item_pesanan VALUES (115, 106, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (116, 107, 9, 10, 2, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (117, 108, 4, 10, 9, 27000);
INSERT INTO raja_laundry.item_pesanan VALUES (118, 109, 5, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (119, 110, 9, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (120, 111, 6, 10, 7, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (121, 112, 6, 10, 8, 37000);
INSERT INTO raja_laundry.item_pesanan VALUES (122, 113, 5, 10, 6, 22000);
INSERT INTO raja_laundry.item_pesanan VALUES (123, 114, 6, 15, 1, 10000);
INSERT INTO raja_laundry.item_pesanan VALUES (124, 115, 7, 10, 4, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (125, 116, 9, 10, 4, 18000);
INSERT INTO raja_laundry.item_pesanan VALUES (126, 117, 9, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (127, 118, 5, 10, 3, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (128, 119, 9, 10, 6, 22000);
INSERT INTO raja_laundry.item_pesanan VALUES (129, 120, 6, 10, 10, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (130, 121, 5, 10, 12, 48000);
INSERT INTO raja_laundry.item_pesanan VALUES (131, 122, 6, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (132, 123, 6, 10, 3, 12500);
INSERT INTO raja_laundry.item_pesanan VALUES (133, 124, 6, 10, 7, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (134, 125, 6, 10, 1, 70000);
INSERT INTO raja_laundry.item_pesanan VALUES (135, 126, 4, 10, 12, 36000);
INSERT INTO raja_laundry.item_pesanan VALUES (136, 127, 9, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (137, 128, 5, 10, 5, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (138, 129, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (139, 130, 6, 1, 1, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (140, 131, 5, 10, 38, 152000);
INSERT INTO raja_laundry.item_pesanan VALUES (141, 132, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (142, 133, 9, 10, 8, 32000);
INSERT INTO raja_laundry.item_pesanan VALUES (143, 134, 5, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (144, 135, 6, 10, 9, 45000);
INSERT INTO raja_laundry.item_pesanan VALUES (145, 136, 6, 10, 8, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (146, 136, 6, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (147, 137, 7, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (148, 138, 5, 10, 6, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (149, 139, 6, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (150, 140, 7, 7, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (151, 141, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (152, 142, 6, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (153, 143, 6, 10, 6, 27500);
INSERT INTO raja_laundry.item_pesanan VALUES (154, 144, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (155, 145, 5, 10, 1, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (156, 146, 4, 10, 8, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (157, 147, 9, 10, 11, 44000);
INSERT INTO raja_laundry.item_pesanan VALUES (158, 148, 6, 10, 5, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (159, 149, 9, 10, 5, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (160, 150, 4, 10, 5, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (161, 151, 5, 10, 8, 32000);
INSERT INTO raja_laundry.item_pesanan VALUES (162, 152, 6, 10, 3, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (163, 153, 6, 15, 1, 45000);
INSERT INTO raja_laundry.item_pesanan VALUES (164, 153, 6, 1, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (165, 154, 5, 12, 1, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (166, 155, 9, 10, 15, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (167, 156, 5, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (168, 157, 6, 10, 7, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (169, 158, 6, 10, 7, 32000);
INSERT INTO raja_laundry.item_pesanan VALUES (170, 159, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (171, 160, 5, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (172, 161, 6, 15, 1, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (173, 161, 6, 10, 6, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (174, 162, 11, 14, 3, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (175, 163, 9, 10, 11, 42500);
INSERT INTO raja_laundry.item_pesanan VALUES (176, 164, 6, 10, 10, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (177, 165, 5, 10, 8, 32000);
INSERT INTO raja_laundry.item_pesanan VALUES (178, 166, 9, 10, 10, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (179, 167, 6, 1, 2, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (180, 167, 6, 15, 2, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (181, 168, 9, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (182, 169, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (183, 170, 5, 10, 15, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (184, 171, 5, 10, 22, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (185, 172, 6, 10, 1, 55000);
INSERT INTO raja_laundry.item_pesanan VALUES (186, 173, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (187, 174, 6, 10, 7, 37000);
INSERT INTO raja_laundry.item_pesanan VALUES (188, 174, 9, 10, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (189, 175, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (190, 176, 6, 1, 1, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (191, 177, 4, 10, 5, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (192, 178, 6, 10, 6, 27500);
INSERT INTO raja_laundry.item_pesanan VALUES (193, 179, 6, 10, 3, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (194, 180, 6, 10, 5, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (195, 181, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (196, 182, 6, 15, 2, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (197, 183, 9, 10, 6, 34000);
INSERT INTO raja_laundry.item_pesanan VALUES (198, 184, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (199, 185, 9, 10, 13, 52000);
INSERT INTO raja_laundry.item_pesanan VALUES (200, 186, 6, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (201, 187, 5, 10, 3, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (202, 188, 6, 10, 9, 45000);
INSERT INTO raja_laundry.item_pesanan VALUES (203, 189, 6, 9, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (204, 190, 9, 10, 12, 48000);
INSERT INTO raja_laundry.item_pesanan VALUES (205, 191, 6, 15, 2, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (206, 191, 6, 13, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (207, 192, 9, 10, 9, 36000);
INSERT INTO raja_laundry.item_pesanan VALUES (208, 193, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (209, 194, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (210, 195, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (211, 196, 9, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (212, 197, 6, 15, 2, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (213, 198, 5, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (214, 199, 5, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (215, 200, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (216, 201, 6, 10, 6, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (217, 201, 6, 15, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (218, 202, 6, 15, 4, 50000);
INSERT INTO raja_laundry.item_pesanan VALUES (219, 202, 6, 5, 2, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (220, 203, 6, 11, 4, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (221, 204, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (222, 205, 11, 14, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (223, 206, 5, 10, 16, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (224, 207, 6, 10, 9, 45000);
INSERT INTO raja_laundry.item_pesanan VALUES (225, 208, 5, 10, 5, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (226, 209, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (227, 210, 5, 10, 11, 42000);
INSERT INTO raja_laundry.item_pesanan VALUES (228, 211, 6, 1, 1, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (229, 212, 4, 10, 8, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (230, 213, 6, 10, 9, 42500);
INSERT INTO raja_laundry.item_pesanan VALUES (231, 214, 6, 10, 8, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (232, 215, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (233, 216, 6, 1, 2, 40000);
INSERT INTO raja_laundry.item_pesanan VALUES (234, 217, 11, 14, 1, 60000);
INSERT INTO raja_laundry.item_pesanan VALUES (235, 217, 6, 1, 1, 0);
INSERT INTO raja_laundry.item_pesanan VALUES (236, 218, 6, 10, 13, 65000);
INSERT INTO raja_laundry.item_pesanan VALUES (237, 219, 5, 10, 8, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (238, 220, 6, 10, 4, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (239, 221, 6, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (240, 222, 5, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (241, 223, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (242, 224, 5, 10, 5, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (243, 225, 6, 15, 1, 100000);
INSERT INTO raja_laundry.item_pesanan VALUES (244, 226, 6, 1, 1, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (245, 227, 9, 10, 7, 28000);
INSERT INTO raja_laundry.item_pesanan VALUES (246, 228, 6, 10, 6, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (247, 229, 9, 10, 15, 58000);
INSERT INTO raja_laundry.item_pesanan VALUES (248, 230, 6, 15, 1, 35000);
INSERT INTO raja_laundry.item_pesanan VALUES (249, 231, 5, 10, 6, 24000);
INSERT INTO raja_laundry.item_pesanan VALUES (250, 232, 9, 10, 9, 36000);
INSERT INTO raja_laundry.item_pesanan VALUES (251, 233, 6, 15, 2, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (252, 234, 6, 10, 12, 57500);
INSERT INTO raja_laundry.item_pesanan VALUES (253, 235, 6, 15, 1, 15000);
INSERT INTO raja_laundry.item_pesanan VALUES (254, 236, 6, 10, 4, 20000);
INSERT INTO raja_laundry.item_pesanan VALUES (255, 237, 4, 10, 10, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (256, 238, 6, 10, 3, 25000);
INSERT INTO raja_laundry.item_pesanan VALUES (257, 239, 9, 10, 9, 30000);
INSERT INTO raja_laundry.item_pesanan VALUES (258, 240, 9, 10, 10, 40000);


--
-- TOC entry 3444 (class 0 OID 32783)
-- Dependencies: 221
-- Data for Name: kupon; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--



--
-- TOC entry 3446 (class 0 OID 32787)
-- Dependencies: 223
-- Data for Name: paket; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--

INSERT INTO raja_laundry.paket VALUES (2, '3X/EX');
INSERT INTO raja_laundry.paket VALUES (3, '9S');
INSERT INTO raja_laundry.paket VALUES (1, '?');
INSERT INTO raja_laundry.paket VALUES (4, 'Cuci Basah');
INSERT INTO raja_laundry.paket VALUES (5, 'Cuci Kering');
INSERT INTO raja_laundry.paket VALUES (6, 'Cuci Setrika');
INSERT INTO raja_laundry.paket VALUES (7, 'Dry Clean');
INSERT INTO raja_laundry.paket VALUES (8, 'LTA');
INSERT INTO raja_laundry.paket VALUES (9, 'Setrika');
INSERT INTO raja_laundry.paket VALUES (10, 'SL');
INSERT INTO raja_laundry.paket VALUES (11, 'Toe n Tas');


--
-- TOC entry 3448 (class 0 OID 32791)
-- Dependencies: 225
-- Data for Name: pengeluaran; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--

INSERT INTO raja_laundry.pengeluaran VALUES (1, '2019-10-01', 'Elpiji? + aqua', 37000);
INSERT INTO raja_laundry.pengeluaran VALUES (2, '2019-10-01', 'Dry clean', 77000);
INSERT INTO raja_laundry.pengeluaran VALUES (3, '2019-10-02', 'Proklin', 20000);
INSERT INTO raja_laundry.pengeluaran VALUES (4, '2019-10-02', 'Iuran RT', 40000);
INSERT INTO raja_laundry.pengeluaran VALUES (5, '2019-10-03', 'Dry Clean', 70000);
INSERT INTO raja_laundry.pengeluaran VALUES (6, '2019-10-04', 'Elpiji', 18000);
INSERT INTO raja_laundry.pengeluaran VALUES (7, '2019-10-05', 'Sepatu', 160000);
INSERT INTO raja_laundry.pengeluaran VALUES (8, '2019-10-06', 'Proklin + Sunlight', 19500);
INSERT INTO raja_laundry.pengeluaran VALUES (9, '2019-10-08', 'Parfum + Sabun', 140000);
INSERT INTO raja_laundry.pengeluaran VALUES (10, '2019-10-08', 'Elpiji?', 18000);
INSERT INTO raja_laundry.pengeluaran VALUES (11, '2019-10-08', 'Dry Clean', 40000);
INSERT INTO raja_laundry.pengeluaran VALUES (12, '2019-10-09', 'Gaji Mbak Nis', 1120000);
INSERT INTO raja_laundry.pengeluaran VALUES (13, '2019-10-09', 'Pro/Sukeni?', 48000);
INSERT INTO raja_laundry.pengeluaran VALUES (14, '2019-10-10', 'Bayar Tas', 45000);
INSERT INTO raja_laundry.pengeluaran VALUES (15, '2019-10-10', 'Dry clean', 130000);
INSERT INTO raja_laundry.pengeluaran VALUES (16, '2019-10-11', 'Sepatu', 400000);
INSERT INTO raja_laundry.pengeluaran VALUES (17, '2019-10-12', 'Beli token', 102500);
INSERT INTO raja_laundry.pengeluaran VALUES (18, '2019-10-12', 'Beli sabun', 142000);
INSERT INTO raja_laundry.pengeluaran VALUES (19, '2019-10-13', 'Elpiji/galon', 37000);
INSERT INTO raja_laundry.pengeluaran VALUES (20, '2019-10-14', 'Proklin + Sunlight', 38000);
INSERT INTO raja_laundry.pengeluaran VALUES (21, '2019-10-15', 'Plastik', 51000);
INSERT INTO raja_laundry.pengeluaran VALUES (22, '2019-10-17', '5 Pak Kemeja? Keresek?', 75000);
INSERT INTO raja_laundry.pengeluaran VALUES (23, '2019-10-17', 'Dry clean', 44000);
INSERT INTO raja_laundry.pengeluaran VALUES (24, '2019-10-17', 'Elpiji', 18000);
INSERT INTO raja_laundry.pengeluaran VALUES (25, '2019-10-18', 'B. TS', 100000);
INSERT INTO raja_laundry.pengeluaran VALUES (26, '2019-10-21', 'Dry clean', 57000);
INSERT INTO raja_laundry.pengeluaran VALUES (27, '2019-10-21', 'Proklin + Sunlight', 28000);
INSERT INTO raja_laundry.pengeluaran VALUES (28, '2019-10-22', 'Elpiji', 18000);
INSERT INTO raja_laundry.pengeluaran VALUES (29, '2019-10-22', 'Sabun', 77000);
INSERT INTO raja_laundry.pengeluaran VALUES (30, '2019-10-24', 'Byr Mesin?', 417000);
INSERT INTO raja_laundry.pengeluaran VALUES (31, '2019-10-24', 'Byr Sepatu', 64000);
INSERT INTO raja_laundry.pengeluaran VALUES (32, '2019-10-25', '2 Proclin', 30000);
INSERT INTO raja_laundry.pengeluaran VALUES (33, '2019-10-25', 'Dry Clean', 60000);
INSERT INTO raja_laundry.pengeluaran VALUES (34, '2019-10-25', 'Elpiji', 17500);
INSERT INTO raja_laundry.pengeluaran VALUES (35, '2019-10-25', 'Isolasi', 5500);
INSERT INTO raja_laundry.pengeluaran VALUES (36, '2019-10-26', 'Sabun', 60000);
INSERT INTO raja_laundry.pengeluaran VALUES (37, '2019-10-28', 'Dry clean', 28000);
INSERT INTO raja_laundry.pengeluaran VALUES (38, '2019-10-29', 'Plastik 2 pak', 47000);
INSERT INTO raja_laundry.pengeluaran VALUES (39, '2019-10-29', 'Aqua & Elpiji', 37000);
INSERT INTO raja_laundry.pengeluaran VALUES (40, '2019-11-01', 'Dry clean', 115000);
INSERT INTO raja_laundry.pengeluaran VALUES (41, '2019-11-02', 'Elpiji', 18000);
INSERT INTO raja_laundry.pengeluaran VALUES (42, '2019-11-02', 'Isolasi', 11000);
INSERT INTO raja_laundry.pengeluaran VALUES (43, '2019-11-02', 'Kresek?', 75000);
INSERT INTO raja_laundry.pengeluaran VALUES (44, '2019-11-03', 'Proklin + Sunlight', 25000);


--
-- TOC entry 3450 (class 0 OID 32795)
-- Dependencies: 227
-- Data for Name: pesanan; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--

INSERT INTO raja_laundry.pesanan VALUES (1, 79, NULL, '2019-10-01', '2019-10-04', '2019-10-04', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (2, 90, NULL, '2019-10-01', '2019-10-14', '2019-10-14', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (3, 4, NULL, '2019-10-01', '2019-10-10', '2019-10-10', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (4, 171, NULL, '2019-10-01', '2019-10-16', '2019-10-16', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (5, 22, NULL, '2019-10-01', '2019-10-05', '2019-10-05', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (6, 172, NULL, '2019-10-02', '2019-11-02', '2019-11-02', 5000, 5000, '');
INSERT INTO raja_laundry.pesanan VALUES (7, 188, NULL, '2019-10-02', '2019-10-29', '2019-10-29', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (8, 72, NULL, '2019-10-02', '2019-10-05', '2019-10-05', 45000, 45000, '');
INSERT INTO raja_laundry.pesanan VALUES (9, 139, NULL, '2019-10-02', '2019-10-16', '2019-10-16', 54000, 54000, '');
INSERT INTO raja_laundry.pesanan VALUES (10, 84, NULL, '2019-10-02', '2019-10-20', '2019-10-20', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (11, 74, NULL, '2019-10-02', '2019-10-05', '2019-10-05', 12000, 12000, '');
INSERT INTO raja_laundry.pesanan VALUES (12, 160, NULL, '2019-10-03', '2019-10-06', '2019-10-06', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (13, 92, NULL, '2019-10-03', '2019-11-04', '2019-11-04', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (14, 102, NULL, '2019-10-03', '2019-10-07', '2019-10-07', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (15, 132, NULL, '2019-10-03', '2019-10-03', '2019-10-06', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (16, 93, NULL, '2019-10-04', '2019-10-04', '2019-10-07', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (17, 128, NULL, '2019-10-04', '2019-10-07', '2019-10-07', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (18, 152, NULL, '2019-10-04', '2019-10-07', '2019-10-07', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (19, 101, NULL, '2019-10-04', '2019-10-07', '2019-10-07', 44000, 44000, '');
INSERT INTO raja_laundry.pesanan VALUES (20, 162, NULL, '2019-10-04', '2019-10-07', '2019-10-07', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (21, 93, NULL, '2019-10-04', '2019-10-07', '2019-10-07', 22000, 22000, '');
INSERT INTO raja_laundry.pesanan VALUES (22, 33, NULL, '2019-10-04', '2019-10-07', '2019-10-07', 47500, 47500, '');
INSERT INTO raja_laundry.pesanan VALUES (23, 22, NULL, '2019-10-05', '2019-10-17', '2019-10-17', 25500, 25500, '');
INSERT INTO raja_laundry.pesanan VALUES (24, 51, NULL, '2019-10-05', '2019-10-06', '2019-10-06', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (25, 62, NULL, '2019-10-05', '2019-10-08', '2019-10-08', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (26, 64, NULL, '2019-10-05', '2019-10-08', '2019-10-08', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (27, 130, NULL, '2019-10-05', '2019-10-10', '2019-10-10', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (28, 110, NULL, '2019-10-05', '2019-10-17', '2019-10-17', 55000, 55000, '');
INSERT INTO raja_laundry.pesanan VALUES (29, 77, NULL, '2019-10-05', '2019-10-06', '2019-10-06', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (30, 61, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 25000, 25000, 'Diantar');
INSERT INTO raja_laundry.pesanan VALUES (31, 158, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 34000, 34000, '');
INSERT INTO raja_laundry.pesanan VALUES (32, 51, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (33, 77, NULL, '2019-10-06', '2019-10-07', '2019-10-07', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (34, 117, NULL, '2019-10-06', '2019-10-01', '2019-10-01', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (35, 105, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (36, 70, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 26000, 26000, '');
INSERT INTO raja_laundry.pesanan VALUES (37, 151, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (38, 36, NULL, '2019-10-06', '2019-10-13', '2019-10-13', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (39, 113, NULL, '2019-10-06', '2019-10-11', '2019-10-11', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (40, 129, NULL, '2019-10-06', '2019-10-09', '2019-10-09', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (41, 121, NULL, '2019-10-07', '2019-10-27', '2019-10-27', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (42, 77, NULL, '2019-10-07', '2019-10-07', '2019-10-10', 26000, 26000, '');
INSERT INTO raja_laundry.pesanan VALUES (43, 101, NULL, '2019-10-07', '2019-10-12', '2019-10-12', 26000, 26000, '');
INSERT INTO raja_laundry.pesanan VALUES (44, 187, NULL, '2019-10-07', '2019-10-10', '2019-10-10', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (45, 108, NULL, '2019-10-07', '2019-10-12', '2019-10-12', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (46, 128, NULL, '2019-10-07', '2019-10-18', '2019-10-18', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (47, 156, NULL, '2019-10-07', '2019-10-18', '2019-10-18', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (48, 174, NULL, '2019-10-07', '2019-10-10', '2019-10-10', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (49, 124, NULL, '2019-10-07', '2019-10-10', '2019-10-10', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (50, 16, NULL, '2019-10-07', '2019-10-27', '2019-10-27', 100000, 100000, '');
INSERT INTO raja_laundry.pesanan VALUES (51, 180, NULL, '2019-10-08', '2019-10-11', '2019-10-11', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (52, 69, NULL, '2019-10-08', '2019-10-11', '2019-10-11', 32000, 32000, '');
INSERT INTO raja_laundry.pesanan VALUES (53, 54, NULL, '2019-10-08', '2019-10-11', '2019-10-11', 75000, 75000, '');
INSERT INTO raja_laundry.pesanan VALUES (54, 14, NULL, '2019-10-08', '2019-10-11', '2019-10-11', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (55, 170, NULL, '2019-10-08', '2019-10-11', '2019-10-11', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (56, 50, NULL, '2019-10-09', '2019-10-09', '2019-10-12', 85000, 85000, '');
INSERT INTO raja_laundry.pesanan VALUES (57, 194, NULL, '2019-10-09', '2019-10-12', '2019-10-12', 14000, 14000, '');
INSERT INTO raja_laundry.pesanan VALUES (58, 60, NULL, '2019-10-10', '2019-10-25', '2019-10-25', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (59, 147, NULL, '2019-10-10', '2019-10-13', '2019-10-13', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (60, 93, NULL, '2019-10-10', '2019-10-12', '2019-10-12', 18000, 18000, '');
INSERT INTO raja_laundry.pesanan VALUES (61, 86, NULL, '2019-10-10', '2019-10-16', '2019-10-16', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (62, 96, NULL, '2019-10-10', '2019-10-29', '2019-10-29', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (63, 130, NULL, '2019-10-10', '2019-10-12', '2019-10-12', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (64, 6, NULL, '2019-10-10', '2019-10-13', '2019-10-13', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (65, 31, NULL, '2019-10-10', '2019-10-18', '2019-10-18', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (66, 187, NULL, '2019-10-10', '2019-10-19', '2019-10-19', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (67, 4, NULL, '2019-10-10', '2019-10-10', '2019-10-13', 65000, 65000, '');
INSERT INTO raja_laundry.pesanan VALUES (68, 163, NULL, '2019-10-11', '2019-10-13', '2019-10-13', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (69, 192, NULL, '2019-10-11', '2019-10-14', '2019-10-14', 78000, 78000, '');
INSERT INTO raja_laundry.pesanan VALUES (70, 191, NULL, '2019-10-11', '2019-10-14', '2019-10-14', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (71, 12, NULL, '2019-10-11', '2019-10-14', '2019-10-14', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (72, 113, NULL, '2019-10-11', '2019-10-12', '2019-10-12', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (73, 73, NULL, '2019-10-12', '2019-10-26', '2019-10-26', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (74, 82, NULL, '2019-10-12', '2019-10-12', '2019-10-15', 28500, 28500, '');
INSERT INTO raja_laundry.pesanan VALUES (75, 47, NULL, '2019-10-12', '2019-10-17', '2019-10-17', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (76, 182, NULL, '2019-10-12', '2019-10-15', '2019-10-15', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (77, 49, NULL, '2019-10-12', '2019-10-15', '2019-10-15', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (78, 4, NULL, '2019-10-12', '2019-10-17', '2019-10-17', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (79, 95, NULL, '2019-10-12', '2019-10-15', '2019-10-15', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (80, 81, NULL, '2019-10-12', '2019-10-16', '2019-10-16', 32500, 32500, '');
INSERT INTO raja_laundry.pesanan VALUES (81, 141, NULL, '2019-10-12', '2019-10-30', '2019-10-30', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (82, 93, NULL, '2019-10-12', '2019-10-04', '2019-10-04', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (83, 69, NULL, '2019-10-12', '2019-10-17', '2019-10-17', 12000, 12000, '');
INSERT INTO raja_laundry.pesanan VALUES (84, 132, NULL, '2019-10-13', '2019-10-22', '2019-10-22', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (85, 181, NULL, '2019-10-13', '2019-10-20', '2019-10-20', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (86, 117, NULL, '2019-10-13', '2019-10-01', '2019-10-01', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (87, 67, NULL, '2019-10-13', '2019-10-13', '2019-10-16', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (88, 146, NULL, '2019-10-13', '2019-10-16', '2019-10-16', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (89, 37, NULL, '2019-10-13', '2019-10-16', '2019-10-16', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (90, 98, NULL, '2019-10-14', '2019-10-17', '2019-10-17', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (91, 70, NULL, '2019-10-14', '2019-10-24', '2019-10-24', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (92, 38, NULL, '2019-10-14', '2019-10-17', '2019-10-17', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (93, 90, NULL, '2019-10-14', '2019-10-27', '2019-10-27', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (94, 77, NULL, '2019-10-14', '2019-10-21', '2019-10-21', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (95, 101, NULL, '2019-10-14', '2019-10-16', '2019-10-16', 22000, 22000, '');
INSERT INTO raja_laundry.pesanan VALUES (96, 29, NULL, '2019-10-01', '2019-10-04', '2019-10-04', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (97, 116, NULL, '2019-10-16', '2019-10-16', '2019-10-19', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (98, 35, NULL, '2019-10-16', '2019-10-19', '2019-10-19', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (99, 101, NULL, '2019-10-16', '2019-10-21', '2019-10-21', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (100, 86, NULL, '2019-10-16', '2019-10-23', '2019-10-23', 45000, 45000, '');
INSERT INTO raja_laundry.pesanan VALUES (101, 139, NULL, '2019-10-16', '2019-10-29', '2019-10-29', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (102, 116, NULL, '2019-10-16', '2019-10-19', '2019-10-19', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (103, 87, NULL, '2019-10-16', '2019-10-29', '2019-10-29', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (104, 97, NULL, '2019-10-16', '2019-10-19', '2019-10-19', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (105, 130, NULL, '2019-10-16', '2019-10-28', '2019-10-28', 32500, 32500, '');
INSERT INTO raja_laundry.pesanan VALUES (106, 126, NULL, '2019-10-16', '2019-10-23', '2019-10-23', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (107, 171, NULL, '2019-10-16', '2019-10-19', '2019-10-19', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (108, 22, NULL, '2019-10-17', '2019-10-24', '2019-10-24', 27000, 27000, '');
INSERT INTO raja_laundry.pesanan VALUES (109, 195, NULL, '2019-10-17', '2019-10-22', '2019-10-22', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (110, 109, NULL, '2019-10-17', '2019-10-23', '2019-10-23', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (111, 4, NULL, '2019-10-17', '2019-10-27', '2019-10-27', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (112, 69, NULL, '2019-10-17', '2019-10-20', '2019-10-20', 37000, 37000, '');
INSERT INTO raja_laundry.pesanan VALUES (113, 186, NULL, '2019-10-17', '2019-10-20', '2019-10-20', 22000, 22000, '');
INSERT INTO raja_laundry.pesanan VALUES (114, 110, NULL, '2019-10-17', '2019-10-20', '2019-10-20', 10000, 10000, '');
INSERT INTO raja_laundry.pesanan VALUES (115, 47, NULL, '2019-10-17', '2019-10-20', '2019-10-20', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (116, 128, NULL, '2019-10-18', '2019-10-21', '2019-10-21', 18000, 18000, '');
INSERT INTO raja_laundry.pesanan VALUES (117, 134, NULL, '2019-10-18', '2019-10-21', '2019-10-21', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (118, 159, NULL, '2019-10-18', '2019-10-21', '2019-10-21', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (119, 93, NULL, '2019-10-18', '2019-10-07', '2019-10-07', 22000, 22000, '');
INSERT INTO raja_laundry.pesanan VALUES (120, 31, NULL, '2019-10-18', '2019-10-27', '2019-10-27', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (121, 164, NULL, '2019-10-18', '2019-10-21', '2019-10-21', 48000, 48000, '');
INSERT INTO raja_laundry.pesanan VALUES (122, 190, NULL, '2019-10-19', '2019-10-03', '2019-10-03', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (123, 187, NULL, '2019-10-19', '2019-11-01', '2019-11-01', 12500, 12500, '');
INSERT INTO raja_laundry.pesanan VALUES (124, 165, NULL, '2019-10-19', '2019-10-21', '2019-10-21', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (125, 167, NULL, '2019-10-19', '2019-10-22', '2019-10-22', 70000, 70000, '');
INSERT INTO raja_laundry.pesanan VALUES (126, 8, NULL, '2019-10-19', '2019-10-19', '2019-10-22', 36000, 36000, '');
INSERT INTO raja_laundry.pesanan VALUES (127, 113, NULL, '2019-10-19', '2019-10-22', '2019-10-22', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (128, 117, NULL, '2019-10-20', '2019-10-01', '2019-10-01', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (129, 181, NULL, '2019-10-20', '2019-11-03', '2019-11-03', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (130, 131, NULL, '2019-10-20', '2019-10-23', '2019-10-23', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (131, 17, NULL, '2019-10-20', '2019-10-23', '2019-10-23', 152000, 152000, '');
INSERT INTO raja_laundry.pesanan VALUES (132, 69, NULL, '2019-10-20', '2019-10-20', '2019-10-23', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (133, 112, NULL, '2019-10-21', '2019-10-24', '2019-10-24', 32000, 32000, '');
INSERT INTO raja_laundry.pesanan VALUES (134, 101, NULL, '2019-10-21', '2019-10-22', '2019-10-22', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (135, 193, NULL, '2019-10-21', '2019-10-24', '2019-10-24', 45000, 45000, '');
INSERT INTO raja_laundry.pesanan VALUES (136, 165, NULL, '2019-10-21', '2019-11-01', '2019-11-01', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (137, 117, NULL, '2019-10-21', '2019-11-03', '2019-11-03', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (138, 100, NULL, '2019-10-21', '2019-10-24', '2019-10-24', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (139, 128, NULL, '2019-10-21', '2019-10-24', '2019-10-24', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (140, 77, NULL, '2019-10-21', '2019-10-25', '2019-10-25', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (141, 40, NULL, '2019-10-22', '2019-10-22', '2019-10-25', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (142, 57, NULL, '2019-10-22', '2019-10-25', '2019-10-25', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (143, 41, NULL, '2019-10-22', '2019-10-25', '2019-10-25', 27500, 27500, '');
INSERT INTO raja_laundry.pesanan VALUES (144, 86, NULL, '2019-10-23', '2019-10-29', '2019-10-29', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (145, 84, NULL, '2019-10-23', '2019-10-25', '2019-10-25', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (146, 22, NULL, '2019-10-24', '2019-10-27', '2019-10-27', 20000, 20000, '2?');
INSERT INTO raja_laundry.pesanan VALUES (147, 70, NULL, '2019-10-24', '2019-10-28', '2019-10-28', 44000, 44000, '');
INSERT INTO raja_laundry.pesanan VALUES (148, 60, NULL, '2019-10-25', '2019-10-28', '2019-10-28', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (149, 123, NULL, '2019-10-25', '2019-10-28', '2019-10-28', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (150, 77, NULL, '2019-10-25', '2019-10-25', '2019-10-28', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (151, 101, NULL, '2019-10-25', '2019-10-27', '2019-10-27', 32000, 32000, '');
INSERT INTO raja_laundry.pesanan VALUES (152, 186, NULL, '2019-10-25', '2019-10-28', '2019-10-28', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (153, 56, NULL, '2019-10-25', '2019-10-28', '2019-10-28', 45000, 45000, '');
INSERT INTO raja_laundry.pesanan VALUES (154, 104, NULL, '2019-10-25', '2019-10-28', '2019-10-28', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (155, 145, NULL, '2019-10-25', '2019-10-27', '2019-10-27', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (156, 177, NULL, '2019-10-25', '2019-10-28', '2019-10-28', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (157, 69, NULL, '2019-10-25', '2019-11-01', '2019-11-01', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (158, 77, NULL, '2019-10-25', '2019-10-27', '2019-10-27', 32000, 32000, '');
INSERT INTO raja_laundry.pesanan VALUES (159, 132, NULL, '2019-10-25', '2019-11-01', '2019-11-01', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (160, 73, NULL, '2019-10-26', '2019-10-13', '2019-10-13', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (161, 99, NULL, '2019-10-26', '2019-10-29', '2019-10-29', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (162, 88, NULL, '2019-10-26', '2019-10-29', '2019-10-29', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (163, 144, NULL, '2019-10-26', '2019-11-03', '2019-11-03', 42500, 42500, '');
INSERT INTO raja_laundry.pesanan VALUES (164, 31, NULL, '2019-10-26', '2019-10-27', '2019-10-27', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (165, 164, NULL, '2019-10-26', '2019-10-28', '2019-10-28', 32000, 32000, '');
INSERT INTO raja_laundry.pesanan VALUES (166, 184, NULL, '2019-10-26', '2019-11-01', '2019-11-01', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (167, 155, NULL, '2019-10-26', '2019-10-26', '2019-10-29', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (168, 4, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (169, 39, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (170, 127, NULL, '2019-10-27', '2019-10-29', '2019-10-29', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (171, 16, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (172, 121, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 55000, 55000, '');
INSERT INTO raja_laundry.pesanan VALUES (173, 58, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (174, 77, NULL, '2019-10-27', '2019-11-03', '2019-11-03', 37000, 37000, '');
INSERT INTO raja_laundry.pesanan VALUES (175, 134, NULL, '2019-10-27', '2019-10-27', '2019-10-30', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (176, 134, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (177, 90, NULL, '2019-10-27', '2019-10-30', '2019-10-30', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (178, 83, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 27500, 27500, '');
INSERT INTO raja_laundry.pesanan VALUES (179, 163, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (180, 154, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (181, 130, NULL, '2019-10-28', '2019-10-30', '2019-10-30', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (182, 106, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (183, 75, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 34000, 34000, '');
INSERT INTO raja_laundry.pesanan VALUES (184, 34, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (185, 93, NULL, '2019-10-28', '2019-10-31', '2019-10-31', 52000, 52000, '');
INSERT INTO raja_laundry.pesanan VALUES (186, 139, NULL, '2019-10-29', '2019-10-08', '2019-10-08', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (187, 53, NULL, '2019-10-29', '2019-10-16', '2019-10-16', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (188, 86, NULL, '2019-10-29', '2019-11-01', '2019-11-01', 45000, 45000, '');
INSERT INTO raja_laundry.pesanan VALUES (189, 87, NULL, '2019-10-29', '2019-11-01', '2019-11-01', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (190, 96, NULL, '2019-10-29', '2019-11-03', '2019-11-03', 48000, 48000, '');
INSERT INTO raja_laundry.pesanan VALUES (191, 188, NULL, '2019-10-29', '2019-11-01', '2019-11-01', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (192, 70, 1, '2019-10-30', '2019-11-05', '2019-11-05', 36000, 36000, '');
INSERT INTO raja_laundry.pesanan VALUES (193, 130, 2, '2019-10-30', '2019-11-02', '2019-11-02', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (194, 69, 8, '2019-11-01', '2019-11-04', '2019-11-04', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (195, 187, 9, '2019-11-01', '2019-11-04', '2019-11-04', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (196, 12, 10, '2019-11-01', '2019-11-05', '2019-11-05', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (197, 31, 11, '2019-11-01', '2019-11-02', '2019-11-02', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (198, 177, 12, '2019-11-01', '2019-11-03', '2019-11-03', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (199, 2, 13, '2019-11-01', '2019-11-04', '2019-11-04', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (200, 165, 14, '2019-11-01', '2019-11-01', '2019-11-04', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (201, 132, 15, '2019-11-01', '2019-11-01', '2019-11-04', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (202, 165, 16, '2019-11-01', '2019-11-04', '2019-11-04', 50000, 50000, '');
INSERT INTO raja_laundry.pesanan VALUES (203, 184, 17, '2019-11-01', '2019-11-04', '2019-11-04', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (204, 28, 18, '2019-11-01', '2019-11-01', '2019-11-04', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (205, 18, NULL, '2019-11-01', '2019-11-02', '2019-11-02', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (206, 27, 19, '2019-11-02', '2019-11-05', '2019-11-05', 0, 0, '');
INSERT INTO raja_laundry.pesanan VALUES (207, 31, 20, '2019-11-02', '2019-11-05', '2019-11-05', 45000, 45000, '');
INSERT INTO raja_laundry.pesanan VALUES (208, 73, 21, '2019-11-02', '2019-10-13', '2019-10-13', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (209, 139, 22, '2019-11-02', '2019-11-05', '2019-11-05', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (210, 101, 23, '2019-11-02', '2019-11-05', '2019-11-05', 42000, 42000, '');
INSERT INTO raja_laundry.pesanan VALUES (211, 18, 24, '2019-11-02', '2019-11-05', '2019-11-05', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (212, 59, 25, '2019-11-02', '2019-11-02', '2019-11-05', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (213, 135, 26, '2019-11-02', '2019-11-05', '2019-11-05', 42500, 42500, '');
INSERT INTO raja_laundry.pesanan VALUES (214, 157, 27, '2019-11-02', '2019-11-05', '2019-11-05', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (215, 172, 28, '2019-11-02', '2019-10-03', '2019-10-03', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (216, 66, 29, '2019-11-02', '2019-11-05', '2019-11-05', 40000, 40000, '');
INSERT INTO raja_laundry.pesanan VALUES (217, 111, 30, '2019-11-02', '2019-11-05', '2019-11-05', 60000, 60000, '');
INSERT INTO raja_laundry.pesanan VALUES (218, 45, 31, '2019-11-02', '2019-11-05', '2019-11-05', 65000, 65000, '');
INSERT INTO raja_laundry.pesanan VALUES (219, 21, 32, '2019-11-02', '2019-11-02', '2019-11-05', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (220, 115, 33, '2019-11-02', '2019-11-05', '2019-11-05', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (221, 178, 34, '2019-11-03', '2019-11-06', '2019-11-06', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (222, 181, 35, '2019-11-03', '2019-10-20', '2019-10-20', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (223, 77, 36, '2019-11-03', '2019-11-06', '2019-11-06', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (224, 117, 37, '2019-11-03', '2019-10-01', '2019-10-01', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (225, 96, 38, '2019-11-03', '2019-11-05', '2019-11-05', 100000, 100000, '');
INSERT INTO raja_laundry.pesanan VALUES (226, 144, 39, '2019-11-03', '2019-11-06', '2019-11-06', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (227, 148, NULL, '2019-11-03', '2019-11-06', '2019-11-06', 28000, 28000, '');
INSERT INTO raja_laundry.pesanan VALUES (228, 138, 40, '2019-11-04', '2019-11-07', '2019-11-07', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (229, 92, 41, '2019-11-04', '2019-11-07', '2019-11-07', 58000, 58000, '');
INSERT INTO raja_laundry.pesanan VALUES (230, 42, 42, '2019-11-04', '2019-11-07', '2019-11-07', 35000, 35000, '');
INSERT INTO raja_laundry.pesanan VALUES (231, 195, 43, '2019-11-04', '2019-10-22', '2019-10-22', 24000, 24000, '');
INSERT INTO raja_laundry.pesanan VALUES (232, 114, 44, '2019-11-04', '2019-11-07', '2019-11-07', 36000, 36000, '');
INSERT INTO raja_laundry.pesanan VALUES (233, 161, 45, '2019-11-04', '2019-11-07', '2019-11-07', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (234, 69, 46, '2019-11-04', '2019-11-07', '2019-11-07', 57500, 57500, '');
INSERT INTO raja_laundry.pesanan VALUES (235, 55, 47, '2019-11-04', '2019-11-07', '2019-11-07', 15000, 15000, '');
INSERT INTO raja_laundry.pesanan VALUES (236, 13, 48, '2019-11-04', '2019-11-07', '2019-11-07', 20000, 20000, '');
INSERT INTO raja_laundry.pesanan VALUES (237, 82, 49, '2019-11-04', '2019-11-04', '2019-11-07', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (238, 126, 50, '2019-11-04', '2019-11-07', '2019-11-07', 25000, 25000, '');
INSERT INTO raja_laundry.pesanan VALUES (239, 70, 51, '2019-11-05', '2019-11-08', '2019-11-08', 30000, 30000, '');
INSERT INTO raja_laundry.pesanan VALUES (240, 96, 52, '2019-11-05', '2019-11-08', '2019-11-08', 40000, 40000, '');


--
-- TOC entry 3452 (class 0 OID 32801)
-- Dependencies: 229
-- Data for Name: unit; Type: TABLE DATA; Schema: raja_laundry; Owner: -
--

INSERT INTO raja_laundry.unit VALUES (1, 'Bed Cover');
INSERT INTO raja_laundry.unit VALUES (2, 'CPR');
INSERT INTO raja_laundry.unit VALUES (3, 'Da');
INSERT INTO raja_laundry.unit VALUES (4, 'Gorden');
INSERT INTO raja_laundry.unit VALUES (5, 'HD');
INSERT INTO raja_laundry.unit VALUES (6, 'Jaket');
INSERT INTO raja_laundry.unit VALUES (7, 'Jas');
INSERT INTO raja_laundry.unit VALUES (8, 'Kambal');
INSERT INTO raja_laundry.unit VALUES (9, 'Karpet');
INSERT INTO raja_laundry.unit VALUES (10, 'Kg');
INSERT INTO raja_laundry.unit VALUES (11, 'Melar');
INSERT INTO raja_laundry.unit VALUES (12, 'RSE');
INSERT INTO raja_laundry.unit VALUES (13, 'Selimut');
INSERT INTO raja_laundry.unit VALUES (14, 'Sepatu');
INSERT INTO raja_laundry.unit VALUES (15, 'Seprai');
INSERT INTO raja_laundry.unit VALUES (16, 'Tas');
INSERT INTO raja_laundry.unit VALUES (17, 'Tikar');


--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 217
-- Name: customer_id_customer_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.customer_id_customer_seq', 195, true);


--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 220
-- Name: item_pesanan_id_item_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.item_pesanan_id_item_seq', 258, true);


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 222
-- Name: kupon_id_kupon_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.kupon_id_kupon_seq', 1, true);


--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 224
-- Name: paket_id_paket_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.paket_id_paket_seq', 11, true);


--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 226
-- Name: pengeluaran_id_pengeluaran_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.pengeluaran_id_pengeluaran_seq', 44, true);


--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 228
-- Name: pesanan_id_pesanan_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.pesanan_id_pesanan_seq', 240, true);


--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 230
-- Name: unit_id_unit_seq; Type: SEQUENCE SET; Schema: raja_laundry; Owner: -
--

SELECT pg_catalog.setval('raja_laundry.unit_id_unit_seq', 17, true);


--
-- TOC entry 3251 (class 2606 OID 32813)
-- Name: customer idx_16501_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.customer
    ADD CONSTRAINT idx_16501_primary PRIMARY KEY (id_customer);


--
-- TOC entry 3254 (class 2606 OID 32815)
-- Name: item_kupon idx_16505_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_kupon
    ADD CONSTRAINT idx_16505_primary PRIMARY KEY (id_pesanan);


--
-- TOC entry 3259 (class 2606 OID 32817)
-- Name: item_pesanan idx_16509_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_pesanan
    ADD CONSTRAINT idx_16509_primary PRIMARY KEY (id_item);


--
-- TOC entry 3263 (class 2606 OID 32819)
-- Name: kupon idx_16517_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.kupon
    ADD CONSTRAINT idx_16517_primary PRIMARY KEY (id_kupon);


--
-- TOC entry 3265 (class 2606 OID 32821)
-- Name: paket idx_16522_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.paket
    ADD CONSTRAINT idx_16522_primary PRIMARY KEY (id_paket);


--
-- TOC entry 3268 (class 2606 OID 32823)
-- Name: pengeluaran idx_16527_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.pengeluaran
    ADD CONSTRAINT idx_16527_primary PRIMARY KEY (id_pengeluaran);


--
-- TOC entry 3271 (class 2606 OID 32825)
-- Name: pesanan idx_16532_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.pesanan
    ADD CONSTRAINT idx_16532_primary PRIMARY KEY (id_pesanan);


--
-- TOC entry 3273 (class 2606 OID 32827)
-- Name: unit idx_16539_primary; Type: CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.unit
    ADD CONSTRAINT idx_16539_primary PRIMARY KEY (id_unit);


--
-- TOC entry 3252 (class 1259 OID 32828)
-- Name: idx_16505_fk_item_kup_relations_kupon; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16505_fk_item_kup_relations_kupon ON raja_laundry.item_kupon USING btree (id_kupon);


--
-- TOC entry 3255 (class 1259 OID 32829)
-- Name: idx_16509_fk_item_pes_memiliki__pesanan; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16509_fk_item_pes_memiliki__pesanan ON raja_laundry.item_pesanan USING btree (id_pesanan);


--
-- TOC entry 3256 (class 1259 OID 32830)
-- Name: idx_16509_fk_paket; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16509_fk_paket ON raja_laundry.item_pesanan USING btree (id_paket);


--
-- TOC entry 3257 (class 1259 OID 32831)
-- Name: idx_16509_fk_unit; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16509_fk_unit ON raja_laundry.item_pesanan USING btree (id_unit);


--
-- TOC entry 3260 (class 1259 OID 32832)
-- Name: idx_16517_fk_kupon_dipakai_p_pesanan; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16517_fk_kupon_dipakai_p_pesanan ON raja_laundry.kupon USING btree (id_pesanan);


--
-- TOC entry 3261 (class 1259 OID 32833)
-- Name: idx_16517_fk_kupon_memiliki__customer; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16517_fk_kupon_memiliki__customer ON raja_laundry.kupon USING btree (id_customer);


--
-- TOC entry 3266 (class 1259 OID 32834)
-- Name: idx_16522_unique_paket; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE UNIQUE INDEX idx_16522_unique_paket ON raja_laundry.paket USING btree (paket);


--
-- TOC entry 3269 (class 1259 OID 32835)
-- Name: idx_16532_fk_pesanan_memiliki__customer; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE INDEX idx_16532_fk_pesanan_memiliki__customer ON raja_laundry.pesanan USING btree (id_customer);


--
-- TOC entry 3274 (class 1259 OID 32836)
-- Name: idx_16539_unique_unit; Type: INDEX; Schema: raja_laundry; Owner: -
--

CREATE UNIQUE INDEX idx_16539_unique_unit ON raja_laundry.unit USING btree (unit);


--
-- TOC entry 3288 (class 2620 OID 49167)
-- Name: item_pesanan on_delete_item_pesanan; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_delete_item_pesanan AFTER DELETE ON raja_laundry.item_pesanan FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_delete_item_pesanan();


--
-- TOC entry 3283 (class 2620 OID 49161)
-- Name: item_kupon on_delete_kupon; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_delete_kupon AFTER DELETE ON raja_laundry.item_kupon FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_delete_kupon();


--
-- TOC entry 3284 (class 2620 OID 49153)
-- Name: item_kupon on_insert_item_kupon; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_insert_item_kupon BEFORE INSERT ON raja_laundry.item_kupon FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_insert_item_kupon();


--
-- TOC entry 3289 (class 2620 OID 49163)
-- Name: item_pesanan on_insert_item_pesanan; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_insert_item_pesanan AFTER INSERT ON raja_laundry.item_pesanan FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_insert_item_pesanan();


--
-- TOC entry 3285 (class 2620 OID 49155)
-- Name: item_kupon on_insert_kupon; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_insert_kupon AFTER INSERT ON raja_laundry.item_kupon FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_insert_kupon();


--
-- TOC entry 3286 (class 2620 OID 49157)
-- Name: item_kupon on_update_item_kupon; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_update_item_kupon BEFORE UPDATE ON raja_laundry.item_kupon FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_update_item_kupon();


--
-- TOC entry 3290 (class 2620 OID 49165)
-- Name: item_pesanan on_update_item_pesanan; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_update_item_pesanan AFTER UPDATE ON raja_laundry.item_pesanan FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_update_item_pesanan();


--
-- TOC entry 3287 (class 2620 OID 49159)
-- Name: item_kupon on_update_kupon; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER on_update_kupon AFTER UPDATE ON raja_laundry.item_kupon FOR EACH ROW EXECUTE FUNCTION raja_laundry.on_update_kupon();


--
-- TOC entry 3291 (class 2620 OID 49169)
-- Name: pengeluaran pengeluaran_default_date; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER pengeluaran_default_date BEFORE INSERT ON raja_laundry.pengeluaran FOR EACH ROW EXECUTE FUNCTION raja_laundry.pengeluaran_default_date();


--
-- TOC entry 3292 (class 2620 OID 49171)
-- Name: pesanan pesanan_default_date; Type: TRIGGER; Schema: raja_laundry; Owner: -
--

CREATE TRIGGER pesanan_default_date BEFORE INSERT ON raja_laundry.pesanan FOR EACH ROW EXECUTE FUNCTION raja_laundry.pesanan_default_date();


--
-- TOC entry 3275 (class 2606 OID 32837)
-- Name: item_kupon fk_item_kup_merupakan_pesanan; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_kupon
    ADD CONSTRAINT fk_item_kup_merupakan_pesanan FOREIGN KEY (id_pesanan) REFERENCES raja_laundry.pesanan(id_pesanan) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3276 (class 2606 OID 32842)
-- Name: item_kupon fk_item_kup_relations_kupon; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_kupon
    ADD CONSTRAINT fk_item_kup_relations_kupon FOREIGN KEY (id_kupon) REFERENCES raja_laundry.kupon(id_kupon) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3277 (class 2606 OID 32847)
-- Name: item_pesanan fk_item_pes_memiliki__pesanan; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_pesanan
    ADD CONSTRAINT fk_item_pes_memiliki__pesanan FOREIGN KEY (id_pesanan) REFERENCES raja_laundry.pesanan(id_pesanan) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3280 (class 2606 OID 32852)
-- Name: kupon fk_kupon_dipakai_p_pesanan; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.kupon
    ADD CONSTRAINT fk_kupon_dipakai_p_pesanan FOREIGN KEY (id_pesanan) REFERENCES raja_laundry.pesanan(id_pesanan) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3281 (class 2606 OID 32857)
-- Name: kupon fk_kupon_memiliki__customer; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.kupon
    ADD CONSTRAINT fk_kupon_memiliki__customer FOREIGN KEY (id_customer) REFERENCES raja_laundry.customer(id_customer) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3278 (class 2606 OID 32862)
-- Name: item_pesanan fk_paket; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_pesanan
    ADD CONSTRAINT fk_paket FOREIGN KEY (id_paket) REFERENCES raja_laundry.paket(id_paket) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3282 (class 2606 OID 32867)
-- Name: pesanan fk_pesanan_memiliki__customer; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.pesanan
    ADD CONSTRAINT fk_pesanan_memiliki__customer FOREIGN KEY (id_customer) REFERENCES raja_laundry.customer(id_customer) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3279 (class 2606 OID 32872)
-- Name: item_pesanan fk_unit; Type: FK CONSTRAINT; Schema: raja_laundry; Owner: -
--

ALTER TABLE ONLY raja_laundry.item_pesanan
    ADD CONSTRAINT fk_unit FOREIGN KEY (id_unit) REFERENCES raja_laundry.unit(id_unit) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2024-11-16 16:31:20

--
-- PostgreSQL database dump complete
--

