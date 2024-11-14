-- Trigger for `item_kupon` BEFORE INSERT
CREATE OR REPLACE FUNCTION on_insert_item_kupon() 
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_INSERT_ITEM_KUPON
BEFORE INSERT ON item_kupon
FOR EACH ROW EXECUTE FUNCTION on_insert_item_kupon();

-- Trigger for `item_kupon` AFTER INSERT
CREATE OR REPLACE FUNCTION on_insert_kupon() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_INSERT_KUPON
AFTER INSERT ON item_kupon
FOR EACH ROW EXECUTE FUNCTION on_insert_kupon();

-- Trigger for `item_kupon` BEFORE UPDATE
CREATE OR REPLACE FUNCTION on_update_item_kupon() 
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_UPDATE_ITEM_KUPON
BEFORE UPDATE ON item_kupon
FOR EACH ROW EXECUTE FUNCTION on_update_item_kupon();

-- Trigger for `item_kupon` AFTER UPDATE
CREATE OR REPLACE FUNCTION on_update_kupon() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_UPDATE_KUPON
AFTER UPDATE ON item_kupon
FOR EACH ROW EXECUTE FUNCTION on_update_kupon();

-- Trigger for `item_kupon` AFTER DELETE
CREATE OR REPLACE FUNCTION on_delete_kupon() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalculate_total_item(OLD.ID_PESANAN);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_DELETE_KUPON
AFTER DELETE ON item_kupon
FOR EACH ROW EXECUTE FUNCTION on_delete_kupon();

-- Trigger for `item_pesanan` AFTER INSERT
CREATE OR REPLACE FUNCTION on_insert_item_pesanan() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_INSERT_ITEM_PESANAN
AFTER INSERT ON item_pesanan
FOR EACH ROW EXECUTE FUNCTION on_insert_item_pesanan();

-- Trigger for `item_pesanan` AFTER UPDATE
CREATE OR REPLACE FUNCTION on_update_item_pesanan() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalculate_total_item(NEW.ID_PESANAN);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_UPDATE_ITEM_PESANAN
AFTER UPDATE ON item_pesanan
FOR EACH ROW EXECUTE FUNCTION on_update_item_pesanan();

-- Trigger for `item_pesanan` AFTER DELETE
CREATE OR REPLACE FUNCTION on_delete_item_pesanan() 
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalculate_total_item(OLD.ID_PESANAN);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ON_DELETE_ITEM_PESANAN
AFTER DELETE ON item_pesanan
FOR EACH ROW EXECUTE FUNCTION on_delete_item_pesanan();

-- Trigger for `pengeluaran` BEFORE INSERT
CREATE OR REPLACE FUNCTION pengeluaran_default_date() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.TANGGAL_PENGELUARAN IS NULL THEN
        NEW.TANGGAL_PENGELUARAN := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pengeluaran_default_date
BEFORE INSERT ON pengeluaran
FOR EACH ROW EXECUTE FUNCTION pengeluaran_default_date();

-- Trigger for `pesanan` BEFORE INSERT
CREATE OR REPLACE FUNCTION pesanan_default_date() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.TANGGAL_PESANAN IS NULL THEN
        NEW.TANGGAL_PESANAN := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pesanan_default_date
BEFORE INSERT ON pesanan
FOR EACH ROW EXECUTE FUNCTION pesanan_default_date();

-- Procedure for `RECALCULATE_TOTAL_ITEM`
CREATE OR REPLACE FUNCTION recalculate_total_item(ID_PESANAN INTEGER) 
RETURNS VOID AS $$
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
$$ LANGUAGE plpgsql;

-- Views
DROP VIEW IF EXISTS monthly_pemasukan_stats;

CREATE VIEW monthly_pemasukan_stats AS
SELECT EXTRACT(YEAR FROM p.TANGGAL_LUNAS) AS TAHUN,
       EXTRACT(MONTH FROM p.TANGGAL_LUNAS) AS BULAN,
       COUNT(0) AS JUMLAH,
       SUM(p.TOTAL) AS TOTAL
FROM pesanan p
WHERE p.TANGGAL_LUNAS IS NOT NULL
GROUP BY EXTRACT(YEAR FROM p.TANGGAL_LUNAS),
         EXTRACT(MONTH FROM p.TANGGAL_LUNAS)
ORDER BY TAHUN DESC, BULAN DESC;

DROP VIEW IF EXISTS monthly_pengeluaran_stats;

CREATE VIEW monthly_pengeluaran_stats AS
SELECT EXTRACT(YEAR FROM pl.TANGGAL_PENGELUARAN) AS TAHUN,
       EXTRACT(MONTH FROM pl.TANGGAL_PENGELUARAN) AS BULAN,
       COUNT(0) AS JUMLAH,
       SUM(pl.JUMLAH_PENGELUARAN) AS TOTAL
FROM pengeluaran pl
GROUP BY EXTRACT(YEAR FROM pl.TANGGAL_PENGELUARAN),
         EXTRACT(MONTH FROM pl.TANGGAL_PENGELUARAN)
ORDER BY TAHUN DESC, BULAN DESC;

DROP VIEW IF EXISTS pesanan_customer;

CREATE VIEW pesanan_customer AS
SELECT p.ID_PESANAN, p.ID_CUSTOMER, p.TANGGAL_PESANAN, p.TANGGAL_LUNAS, p.TANGGAL_AMBIL,
       p.SUBTOTAL, p.TOTAL, p.KETERANGAN, c.NAMA_CUSTOMER
FROM pesanan p
JOIN customer c ON p.ID_CUSTOMER = c.ID_CUSTOMER;