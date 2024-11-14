<?php 

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Laundry extends CI_Model {
    public function __construct()
    {
        parent::__construct();

        if ($this->db->dbdriver == "postgre"){
            if (ENVIRONMENT !== "production"){
                $sql =  "SET lc_time = 'id_ID.UTF-8';";
                $query = $this->db->query($sql);
            }
        }else{
            $sql =  "SET lc_time_names = 'id_ID';";
            $query = $this->db->query($sql);
        }
    }

    function adjustPostgres($query){
        if ($this->db->dbdriver !== "postgre")
            return $query;
        // Replace CURDATE() with CURRENT_DATE
        $query = preg_replace('/\bCURDATE\(\)/i', 'CURRENT_DATE', $query);
        // Replace INTERVAL X UNIT with INTERVAL 'X units', ensuring unit is plural
        $query = preg_replace_callback('/INTERVAL\s+(\d+)\s+(\w+)/i', function($matches) {
            $unit = strtolower($matches[2]);
            // Ensure unit is plural for PostgreSQL
            if (substr($unit, -1) !== 's') {
                $unit .= 's';
            }
            return "INTERVAL '{$matches[1]} $unit'";
        }, $query);
        // Add schema name to all table names (assuming schema is "public")
        // Handle FROM, JOIN, LEFT JOIN, RIGHT JOIN, etc.
        $query = preg_replace_callback('/\b(FROM|JOIN|LEFT\s+JOIN|RIGHT\s+JOIN)\s+([^,]+)(?=\s*(?:,|\s|\b))/i', function($matches) {
            // Match and replace table names in the FROM, JOIN, LEFT JOIN, RIGHT JOIN clauses
            $tables = array_merge(explode(',', $matches[2]), explode(',', $matches[2])); // Split comma-separated tables
            foreach ($tables as &$table) {
                $table = "{$this->db->schema}." . trim($table); // Add schema prefix
            }
            return $matches[1] . ' ' . implode(', ', $tables); // Return the JOIN clause with schema-prefixed tables
        }, $query);
        // Replace YEAR(<column>) with EXTRACT(YEAR FROM <column>)
        $query = preg_replace('/YEAR\(([^)]+)\)/i', 'EXTRACT(YEAR FROM $1)', $query);
        // Replace MONTH(<column>) with EXTRACT(MONTH FROM <column>)
        $query = preg_replace('/MONTH\(([^)]+)\)/i', 'EXTRACT(MONTH FROM $1)', $query);
        // Replace DAYNAME(<column>) with TO_CHAR(<column>, 'Day')
        $query = preg_replace('/DAYNAME\(([^)]+)\)/i', "TO_CHAR($1, 'Day')", $query);
        // Replace WEEKDAY(<column>) with EXTRACT(DOW FROM <column>)
        $query = preg_replace('/WEEKDAY\(([^)]+)\)/i', 'EXTRACT(DOW FROM $1)', $query);
        // Replace backticks
        $query = str_replace('`', '', $query);
        

        return $query;
    }
    
    function getIdCustomerPesanan($idPesanan){
        $sql =  "SELECT ID_CUSTOMER FROM pesanan WHERE ID_PESANAN=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idPesanan));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->ID_CUSTOMER;
    }
    function getCustomerPesanan($idPesanan){
        $idCustomer = $this->getIdCustomerPesanan($idPesanan);
        if(!$idCustomer) return null;
        return $this->getCustomer($idPesanan);
    }
    function getCustomer($idCustomer){
        $sql =  "SELECT * FROM customer WHERE ID_CUSTOMER=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idCustomer));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result;
    }
    function getIdPesananItem($idItem){
        $sql =  "SELECT ID_PESANAN FROM pesanan WHERE ID_ITEM=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idItem));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->ID_PESANAN;
    }
    function getIdPesananKupon($idKupon){
        $sql =  "SELECT ID_PESANAN FROM kupon WHERE ID_KUPON=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idKupon));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->ID_PESANAN;
    }
    function getPesanan($idPesanan){
        $sql =  "SELECT * FROM pesanan WHERE ID_PESANAN=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idPesanan));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result;
    }
    function getIdKuponItem($idItem){
        $sql =  "SELECT ID_KUPON FROM item_kupon WHERE ID_PESANAN=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idItem));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->ID_KUPON;
    }
    function getKupon($idKupon){
        $sql =  "SELECT * FROM kupon WHERE ID_KUPON=?;";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($idPesanan));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result;
    }
    function getWeekdayStats($tanggal = "PESANAN", $lunas=null, $month=null, $idCustomer=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.TANGGAL_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        $customerQuery = $idCustomer ? " AND P.ID_CUSTOMER={$idCustomer}" : "";
        
        $sql = "
            SELECT 
                DAYNAME(TANGGAL_{$tanggal}) AS HARI, 
                COUNT(*){$monthDivider} AS JUMLAH,
                SUM(TOTAL){$monthDivider} AS TOTAL 
            FROM pesanan P
            WHERE TRUE
                {$customerQuery}
                {$lunasQuery}
                {$monthQuery}
            GROUP BY WEEKDAY(TANGGAL_{$tanggal}), DAYNAME(TANGGAL_{$tanggal})
            ORDER BY WEEKDAY(TANGGAL_{$tanggal})";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }
    function getTopCountStatsCustomer($tanggal="PESANAN", $lunas=null, $month=null, $limit=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.TANGGAL_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        
        $sql = "
            SELECT 
                C.ID_CUSTOMER, 
                C.NAMA_CUSTOMER, 
                COUNT(*){$monthDivider} AS JUMLAH_PESANAN
            FROM customer C, pesanan P
            WHERE C.`ID_CUSTOMER`=P.`ID_CUSTOMER`
                {$lunasQuery}
                {$monthQuery}
            GROUP BY C.ID_CUSTOMER, C.NAMA_CUSTOMER
            ORDER BY COUNT(*){$monthDivider} DESC
            {$limitQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }
    function getTopAmountStatsCustomer($tanggal="PESANAN", $lunas=null, $month=null, $limit=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.TANGGAL_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        
        $sql = "
            SELECT 
                C.ID_CUSTOMER, 
                C.NAMA_CUSTOMER, 
                SUM(P.TOTAL){$monthDivider} AS TOTAL_PEMBAYARAN
            FROM customer C, pesanan P
            WHERE C.`ID_CUSTOMER`=P.`ID_CUSTOMER`
                {$lunasQuery}
                {$monthQuery}
            GROUP BY C.ID_CUSTOMER, C.NAMA_CUSTOMER
            ORDER BY SUM(P.TOTAL){$monthDivider} DESC
            {$limitQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->result();
        return $result;
    }
    function getMonthlyPesananStats($tanggal="PESANAN", $lunas=null, $limit=null, $idCustomer=null){
        $tanggal = strtolower($tanggal);
        if($tanggal == "laba") return $this->getMonthlyLabaStats($limit);
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " WHERE P.TANGGAL_LUNAS IS NOT NULL"
                : " WHERE P.TANGGAL_LUNAS IS NULL");
        $customerQuery = $idCustomer ? " AND P.ID_CUSTOMER={$idCustomer}" : "";
        
        $sql = "
            SELECT
                YEAR(P.`TANGGAL_{$tanggal}`) AS `TAHUN`,
                MONTH(P.`TANGGAL_{$tanggal}`) AS `BULAN`,
                COUNT(0) AS `JUMLAH`,
                SUM(P.`TOTAL`) AS `TOTAL`
            FROM `pesanan` P
            WHERE TRUE
                {$lunasQuery}   
                {$customerQuery}
            GROUP BY YEAR(P.TANGGAL_{$tanggal}),MONTH(P.TANGGAL_{$tanggal})
            ORDER BY YEAR(P.TANGGAL_{$tanggal})ASC,MONTH(P.TANGGAL_{$tanggal}) ASC
            {$limitQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        $result0 = $query->result();
        $result = array();
        $tahun = date("Y");
        $bulan = date("m")-$limit+1;
        $j = 0;
        $len = count($result0);
        for($i = 0; $i < $limit; ++$i){
            if($bulan > 12){
                $bulan = 1;
                $tahun++;
            }
            
            
            $found = false;
            if($j < $len){
                $row = $result0[$j];
                if($tahun == $row->TAHUN && $bulan == $row->BULAN){
                    array_push($result, $row);
                    ++$j;
                    $found = true;
                }
            }
            if(!$found){
                $dummy = new stdClass();
                $dummy->TAHUN = $tahun;
                $dummy->BULAN = $bulan;
                $dummy->JUMLAH = 0;
                $dummy->TOTAL = 0;
                array_push($result, $dummy);
            }
            
            ++$bulan;
        }
        return $result;
    }
    function getMonthlyCashflowStats($limit=null){
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        $sql = "
            SELECT 
                P.TAHUN, P.BULAN, 
                COALESCE(P.TOTAL, 0) AS PEMASUKAN,
                COALESCE(PL.TOTAL, 0) AS PENGELUARAN
            FROM monthly_pemasukan_stats P 
                LEFT JOIN monthly_pengeluaran_stats PL 
                ON (P.TAHUN=PL.TAHUN AND P.BULAN = PL.BULAN)
            UNION ALL
            SELECT 
                PL.TAHUN, PL.BULAN, 
                P.TOTAL AS PEMASUKAN,
                PL.TOTAL AS PENGELUARAN
            FROM monthly_pemasukan_stats P 
                RIGHT JOIN monthly_pengeluaran_stats PL 
                ON (P.TAHUN=PL.TAHUN AND P.BULAN = PL.BULAN)
            WHERE P.TAHUN IS NULL
            ORDER BY TAHUN ASC, BULAN ASC
            {$limitQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        $result0 = $query->result();
        $result = array();
        $tahun = date("Y");
        $bulan = date("m")-$limit+1;
        $j = 0;
        $len = count($result0);
        for($i = 0; $i < $limit; ++$i){
            if($bulan > 12){
                $bulan = 1;
                $tahun++;
            }
            
            
            $found = false;
            if($j < $len){
                $row = $result0[$j];
                if($tahun == $row->TAHUN && $bulan == $row->BULAN){
                    array_push($result, $row);
                    ++$j;
                    $found = true;
                }
            }
            if(!$found){
                $dummy = new stdClass();
                $dummy->TAHUN = $tahun;
                $dummy->BULAN = $bulan;
                $dummy->PEMASUKAN = 0;
                $dummy->PENGELUARAN = 0;
                array_push($result, $dummy);
            }
            
            ++$bulan;
        }
        return $result;
    }
    function getMonthlyProfitStats($limit=null){
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        $sql = "
            SELECT 
                P.TAHUN, P.BULAN, 
                (COALESCE(P.TOTAL, 0)-COALESCE(PL.TOTAL,0)) AS LABA
            FROM monthly_pemasukan_stats P 
                LEFT JOIN monthly_pengeluaran_stats PL 
                ON (P.TAHUN=PL.TAHUN AND P.BULAN = PL.BULAN)
            UNION ALL
            SELECT 
                PL.TAHUN, PL.BULAN, 
                (COALESCE(P.TOTAL, 0)-COALESCE(PL.TOTAL,0)) AS LABA
            FROM monthly_pemasukan_stats P 
                RIGHT JOIN monthly_pengeluaran_stats PL 
                ON (P.TAHUN=PL.TAHUN AND P.BULAN = PL.BULAN)
            WHERE P.TAHUN IS NULL
            ORDER BY TAHUN ASC, BULAN ASC
            {$limitQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        $result0 = $query->result();
        
        
        $result = array();
        $tahun = date("Y");
        $bulan = date("m")-$limit+1;
        $j = 0;
        $len = count($result0);
        for($i = 0; $i < $limit; ++$i){
            if($bulan > 12){
                $bulan = 1;
                $tahun++;
            }
            
            
            $found = false;
            if($j < $len){
                $row = $result0[$j];
                if($tahun == $row->TAHUN && $bulan == $row->BULAN){
                    array_push($result, $row);
                    ++$j;
                    $found = true;
                }
            }
            if(!$found){
                $dummy = new stdClass();
                $dummy->TAHUN = $tahun;
                $dummy->BULAN = $bulan;
                $dummy->LABA = 0;
                array_push($result, $dummy);
            }
            
            ++$bulan;
        }
        return $result;
    }
    
    function getMonthlyIncome($tanggal="PESANAN", $lunas=null, $month=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.TANGGAL_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        
        $sql = "
            SELECT SUM(P.TOTAL){$monthDivider} AS TOTAL
            FROM pesanan P
            WHERE TRUE
                {$monthQuery}
                {$lunasQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->TOTAL;
    }
    function getMonthlySpending($month=null){
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND PL.TANGGAL_PENGELUARAN > CURDATE() - INTERVAL {$month} MONTH" : "";
        
        $sql = "
            SELECT SUM(PL.JUMLAH_PENGELUARAN){$monthDivider} AS TOTAL
            FROM pengeluaran PL
            WHERE TRUE  
            {$monthQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->TOTAL;
    }
    function getCurrentMonthIncome($tanggal="PESANAN",  $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        
        $sql = "
            SELECT SUM(P.TOTAL) AS TOTAL
            FROM pesanan P
            WHERE YEAR(P.TANGGAL_{$tanggal})=YEAR(CURDATE())
                AND MONTH(P.TANGGAL_{$tanggal})=MONTH(CURDATE())
                {$lunasQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->TOTAL;
    }
    function getCurrentMonthSpending(){
        $sql = "
            SELECT SUM(PL.JUMLAH_PENGELUARAN) AS TOTAL
            FROM pengeluaran PL
            WHERE YEAR(PL.TANGGAL_PENGELUARAN)=YEAR(CURDATE())
                AND MONTH(PL.TANGGAL_PENGELUARAN)=MONTH(CURDATE())";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->TOTAL;
    }
    
    
    function getMonthlyPesanan($tanggal="PESANAN", $lunas=null, $month=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.TANGGAL_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        
        $sql = "
            SELECT COUNT(*){$monthDivider} AS COUNT
            FROM pesanan P
            WHERE TRUE
                {$monthQuery}
                {$lunasQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->COUNT;
    }
    function getCurrentMonthPesanan($tanggal="PESANAN",  $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        
        $sql = "
            SELECT COUNT(*) AS COUNT
            FROM pesanan P
            WHERE YEAR(P.TANGGAL_{$tanggal})=YEAR(CURDATE())
                AND MONTH(P.TANGGAL_{$tanggal})=MONTH(CURDATE())
                {$lunasQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->COUNT;
    }
    function getOutstandingPesanan($belum="LUNAS"){
        $belum = strtoupper($belum);
        if (!$belum) $belum = "LUNAS";
        
        $sql = "
            SELECT COUNT(*) AS COUNT
            FROM pesanan P
            WHERE TANGGAL_{$belum} IS NULL";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->COUNT;
    }
    
    function getMonthlyPaketSells($tanggal="PESANAN", $lunas=null, $month=null, $idCustomer=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.TANGGAL_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        $customerQuery = $idCustomer ? " AND P.ID_CUSTOMER={$idCustomer}" : "";
        $sql = "
            SELECT 
                PK.ID_PAKET,
                PK.PAKET,
                COUNT(*){$monthDivider} AS JUMLAH,
                SUM(QTY){$monthDivider} AS TOTAL
            FROM item_pesanan IP, paket PK, pesanan P
            WHERE IP.ID_PAKET=PK.ID_PAKET
                AND IP.ID_PESANAN=P.ID_PESANAN
                {$customerQuery}
                {$monthQuery}
                {$lunasQuery}
            GROUP BY PK.ID_PAKET, PK.PAKET
            ORDER BY PK.ID_PAKET";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        
        $result = $query->result();
        return $result;
    }
    
    function getPaketReport($year, $month){
        $year = escape($year);
        $month = escape($month);
        $sql = "
            SELECT
                PK.ID_PAKET,
                PK.PAKET,
                U.UNIT,
                COUNT(*) AS JUMLAH_PESANAN,
                SUM(IP.QTY) AS JUMLAH_ITEM,
                SUM(IP.HARGA) AS TOTAL
            FROM paket PK, item_pesanan IP, pesanan P, unit U
            WHERE PK.ID_PAKET=IP.ID_PAKET
                AND IP.ID_PESANAN=P.ID_PESANAN
                AND U.ID_UNIT=IP.ID_UNIT
                AND YEAR(P.TANGGAL_PESANAN) = ?
                AND MONTH(P.TANGGAL_PESANAN) = ?
            GROUP BY PK.ID_PAKET, PK.PAKET, U.ID_UNIT";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($year, $month));
        $result = $query->result();
        return $result;
    }
    
    function getCustomerReport($year, $month){
        $year = escape($year);
        $month = escape($month);
        $sql = "
            SELECT
                C.ID_CUSTOMER,
                C.NAMA_CUSTOMER,
                COUNT(*) AS JUMLAH_PESANAN,
                SUM(P.TOTAL) AS TOTAL,
                SUM(COALESCE(K.POTONGAN,0)) AS KUPON
            FROM customer C, pesanan P
            LEFT JOIN kupon K
            ON P.ID_PESANAN=K.ID_PESANAN
            WHERE P.ID_CUSTOMER=C.ID_CUSTOMER
                AND YEAR(P.TANGGAL_PESANAN) = ?
                AND MONTH(P.TANGGAL_PESANAN) = ?
            GROUP BY C.ID_CUSTOMER, C.NAMA_CUSTOMER";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($year, $month));
        $result = $query->result();
        return $result;
    }
    
    function getPesananReport($year, $month){
        $year = escape($year);
        $month = escape($month);
        $sql = "
            SELECT 
                P.*,
                C.NAMA_CUSTOMER,
                P.SUBTOTAL-P.TOTAL AS POTONGAN
            FROM pesanan P, customer C
            WHERE P.ID_CUSTOMER=C.ID_CUSTOMER
                AND YEAR(P.TANGGAL_PESANAN) = ?
                AND MONTH(P.TANGGAL_PESANAN) = ?";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($year, $month));
        $result = $query->result();
        return $result;
    }
    
    function getYears($tanggal="PESANAN", $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        $sql = "
            SELECT DISTINCT YEAR(P.TANGGAL_{$tanggal}) AS TAHUN
            FROM pesanan P
            WHERE TRUE
                {$lunasQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }
    function getMonths($year, $tanggal="PESANAN", $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.TANGGAL_LUNAS IS NOT NULL"
                : " AND P.TANGGAL_LUNAS IS NULL");
        $sql = "
            SELECT DISTINCT MONTH(P.TANGGAL_{$tanggal}) AS BULAN
            FROM pesanan P
            WHERE YEAR(P.TANGGAL_{$tanggal}) = ?
                {$lunasQuery}";
        $sql = $this->adjustPostgres($sql);
        $query = $this->db->query($sql, array($year));
        $result = $query->result();
        return $result;
    }
}