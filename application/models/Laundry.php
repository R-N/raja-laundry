<?php 

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Laundry extends CI_Model {
    public function __construct()
    {
        parent::__construct();

        if ($this->db->dbdriver == "postgre"){
            $schema = $this->db->schema;
            $this->db->query("SET search_path TO '{$schema}';");
            if (ENVIRONMENT !== "production"){
                $sql =  "SET lc_time = 'id_ID.UTF-8';";
                $query = $this->db->query($sql);
            }
        }else{
            $sql =  "SET lc_time_names = 'id_ID';";
            $query = $this->db->query($sql);
        }
    }

    
    function getIdCustomerPesanan($idPesanan){
        $sql =  "SELECT id_customer FROM pesanan WHERE id_pesanan=?;";
        
        $query = $this->db->query($sql, array($idPesanan));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->id_customer;
    }
    function getCustomerPesanan($idPesanan){
        $idCustomer = $this->getIdCustomerPesanan($idPesanan);
        if(!$idCustomer) return null;
        return $this->getCustomer($idPesanan);
    }
    function getCustomer($idCustomer){
        $sql =  "SELECT * FROM customer WHERE id_customer=?;";
        
        $query = $this->db->query($sql, array($idCustomer));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result;
    }
    function getIdPesananItem($idItem){
        $sql =  "SELECT id_pesanan FROM pesanan WHERE id_item=?;";
        
        $query = $this->db->query($sql, array($idItem));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->id_pesanan;
    }
    function getIdPesananKupon($idKupon){
        $sql =  "SELECT id_pesanan FROM kupon WHERE id_kupon=?;";
        
        $query = $this->db->query($sql, array($idKupon));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->id_pesanan;
    }
    function getPesanan($idPesanan){
        $sql =  "SELECT * FROM pesanan WHERE id_pesanan=?;";
        
        $query = $this->db->query($sql, array($idPesanan));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result;
    }
    function getIdKuponItem($idItem){
        $sql =  "SELECT id_kupon FROM item_kupon WHERE id_pesanan=?;";
        
        $query = $this->db->query($sql, array($idItem));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result->id_kupon;
    }
    function getKupon($idKupon){
        $sql =  "SELECT * FROM kupon WHERE id_kupon=?;";
        
        $query = $this->db->query($sql, array($idPesanan));
        if($query->num_rows() == 0) return null;
        $result = $query->row();
        if(!isset($result) || $result == null) return null;
        return $result;
    }
    function getWeekdayStats($tanggal = "pesanan", $lunas=null, $month=null, $idCustomer=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.tanggal_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        $customerQuery = $idCustomer ? " AND P.ID_CUSTOMER={$idCustomer}" : "";
        
        $sql = "
            SELECT 
                DAYNAME(tanggal_{$tanggal}) AS hari, 
                COUNT(*){$monthDivider} AS jumlah,
                SUM(total){$monthDivider} AS total 
            FROM pesanan P
            WHERE TRUE
                {$customerQuery}
                {$lunasQuery}
                {$monthQuery}
            GROUP BY WEEKDAY(tanggal_{$tanggal}), DAYNAME(tanggal_{$tanggal})
            ORDER BY WEEKDAY(tanggal_{$tanggal})";
        
        $query = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }
    function getTopCountStatsCustomer($tanggal="pesanan", $lunas=null, $month=null, $limit=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.tanggal_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        
        $sql = "
            SELECT 
                C.id_customer, 
                C.nama_customer, 
                COUNT(*){$monthDivider} AS jumlah_pesanan
            FROM customer C, pesanan P
            WHERE C.`id_customer`=P.`id_customer`
                {$lunasQuery}
                {$monthQuery}
            GROUP BY C.id_customer, C.nama_customer
            ORDER BY COUNT(*){$monthDivider} DESC
            {$limitQuery}";
        
        $query = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }
    function getTopAmountStatsCustomer($tanggal="pesanan", $lunas=null, $month=null, $limit=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.tanggal_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        
        $sql = "
            SELECT 
                C.id_customer, 
                C.nama_customer, 
                SUM(P.total){$monthDivider} AS total_pembayaran
            FROM customer C, pesanan P
            WHERE C.`id_customer`=P.`id_customer`
                {$lunasQuery}
                {$monthQuery}
            GROUP BY C.id_customer, C.nama_customer
            ORDER BY SUM(P.total){$monthDivider} DESC
            {$limitQuery}";
        
        $query = $this->db->query($sql);
        
        $result = $query->result();
        return $result;
    }
    function getMonthlyPesananStats($tanggal="pesanan", $lunas=null, $limit=null, $idCustomer=null){
        $tanggal = strtolower($tanggal);
        if($tanggal == "laba") return $this->getMonthlyLabaStats($limit);
        $limitQuery = $limit ? " LIMIT {$limit}" : "";
        if($tanggal == "LUNAS") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " WHERE P.tanggal_lunas IS NOT NULL"
                : " WHERE P.tanggal_lunas IS NULL");
        $customerQuery = $idCustomer ? " AND P.id_customer={$idCustomer}" : "";
        
        $sql = "
            SELECT
                YEAR(P.`tanggal_{$tanggal}`) AS `tahun`,
                MONTH(P.`tanggal_{$tanggal}`) AS `bulan`,
                COUNT(0) AS `jumlah`,
                SUM(P.`total`) AS `total`
            FROM `pesanan` P
            WHERE TRUE
                {$lunasQuery}   
                {$customerQuery}
            GROUP BY YEAR(P.tanggal_{$tanggal}),MONTH(P.tanggal_{$tanggal})
            ORDER BY YEAR(P.tanggal_{$tanggal})ASC,MONTH(P.tanggal_{$tanggal}) ASC
            {$limitQuery}";
        
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
                if($tahun == $row->tahun && $bulan == $row->bulan){
                    array_push($result, $row);
                    ++$j;
                    $found = true;
                }
            }
            if(!$found){
                $dummy = new stdClass();
                $dummy->tahun = $tahun;
                $dummy->bulan = $bulan;
                $dummy->jumlah = 0;
                $dummy->total = 0;
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
                P.tahun, P.bulan, 
                COALESCE(P.total, 0) AS pemasukan,
                COALESCE(PL.total, 0) AS pengeluaran
            FROM monthly_pemasukan_stats P 
                LEFT JOIN monthly_pengeluaran_stats PL 
                ON (P.tahun=PL.tahun AND P.bulan = PL.bulan)
            UNION ALL
            SELECT 
                PL.tahun, PL.bulan, 
                P.total AS pemasukan,
                PL.total AS pengeluaran
            FROM monthly_pemasukan_stats P 
                RIGHT JOIN monthly_pengeluaran_stats PL 
                ON (P.tahun=PL.tahun AND P.bulan = PL.bulan)
            WHERE P.tahun IS NULL
            ORDER BY tahun ASC, bulan ASC
            {$limitQuery}";
        
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
                if($tahun == $row->tahun && $bulan == $row->bulan){
                    array_push($result, $row);
                    ++$j;
                    $found = true;
                }
            }
            if(!$found){
                $dummy = new stdClass();
                $dummy->tahun = $tahun;
                $dummy->bulan = $bulan;
                $dummy->pemasukan = 0;
                $dummy->pengeluaran = 0;
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
                P.tahun, P.bulan, 
                (COALESCE(P.TOTAL, 0)-COALESCE(PL.TOTAL,0)) AS laba
            FROM monthly_pemasukan_stats P 
                LEFT JOIN monthly_pengeluaran_stats PL 
                ON (P.tahun=PL.tahun AND P.bulan = PL.bulan)
            UNION ALL
            SELECT 
                PL.tahun, PL.bulan, 
                (COALESCE(P.total, 0)-COALESCE(PL.total,0)) AS laba
            FROM monthly_pemasukan_stats P 
                RIGHT JOIN monthly_pengeluaran_stats PL 
                ON (P.tahun=PL.tahun AND P.bulan = PL.bulan)
            WHERE P.tahun IS NULL
            ORDER BY tahun ASC, bulan ASC
            {$limitQuery}";
        
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
                if($tahun == $row->tahun && $bulan == $row->bulan){
                    array_push($result, $row);
                    ++$j;
                    $found = true;
                }
            }
            if(!$found){
                $dummy = new stdClass();
                $dummy->tahun = $tahun;
                $dummy->bulan = $bulan;
                $dummy->laba = 0;
                array_push($result, $dummy);
            }
            
            ++$bulan;
        }
        return $result;
    }
    
    function getMonthlyIncome($tanggal="pesanan", $lunas=null, $month=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.tanggal_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        
        $sql = "
            SELECT SUM(P.total){$monthDivider} AS total
            FROM pesanan P
            WHERE TRUE
                {$monthQuery}
                {$lunasQuery}";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->total;
    }
    function getMonthlySpending($month=null){
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND PL.tanggal_pengeluaran > CURDATE() - INTERVAL {$month} MONTH" : "";
        
        $sql = "
            SELECT SUM(PL.jumlah_pengeluaran){$monthDivider} AS total
            FROM pengeluaran PL
            WHERE TRUE  
            {$monthQuery}";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->total;
    }
    function getCurrentMonthIncome($tanggal="pesanan",  $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        
        $sql = "
            SELECT SUM(P.total) AS total
            FROM pesanan P
            WHERE YEAR(P.tanggal_{$tanggal})=YEAR(CURDATE())
                AND MONTH(P.tanggal_{$tanggal})=MONTH(CURDATE())
                {$lunasQuery}";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->total;
    }
    function getCurrentMonthSpending(){
        $sql = "
            SELECT SUM(PL.jumlah_pengeluaran) AS total
            FROM pengeluaran PL
            WHERE YEAR(PL.tanggal_pengeluaran)=YEAR(CURDATE())
                AND MONTH(PL.tanggal_pengeluaran)=MONTH(CURDATE())";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->total;
    }
    
    
    function getMonthlyPesanan($tanggal="pesanan", $lunas=null, $month=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.tanggal_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        
        $sql = "
            SELECT COUNT(*){$monthDivider} AS count
            FROM pesanan P
            WHERE TRUE
                {$monthQuery}
                {$lunasQuery}";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->count;
    }
    function getCurrentMonthPesanan($tanggal="pesanan",  $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        
        $sql = "
            SELECT COUNT(*) AS count
            FROM pesanan P
            WHERE YEAR(P.tanggal_{$tanggal})=YEAR(CURDATE())
                AND MONTH(P.tanggal_{$tanggal})=MONTH(CURDATE())
                {$lunasQuery}";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->count;
    }
    function getOutstandingPesanan($belum="lunas"){
        $belum = strtoupper($belum);
        if (!$belum) $belum = "lunas";
        
        $sql = "
            SELECT COUNT(*) AS count
            FROM pesanan P
            WHERE tanggal_{$belum} IS NULL";
        
        $query = $this->db->query($sql);
        
        $result = $query->row();
        return $result->count;
    }
    
    function getMonthlyPaketSells($tanggal="pesanan", $lunas=null, $month=null, $idCustomer=null){
        $tanggal = strtoupper($tanggal);
        $monthDivider = $month ? "/{$month}" : "";
        $monthQuery = $month ? " AND P.tanggal_{$tanggal} > CURDATE() - INTERVAL {$month} MONTH" : "";
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        $customerQuery = $idCustomer ? " AND P.id_customer={$idCustomer}" : "";
        $sql = "
            SELECT 
                PK.id_paket,
                PK.paket,
                COUNT(*){$monthDivider} AS jumlah,
                SUM(QTY){$monthDivider} AS total
            FROM item_pesanan IP, paket PK, pesanan P
            WHERE IP.id_paket=PK.id_paket
                AND IP.id_pesanan=P.id_pesanan
                {$customerQuery}
                {$monthQuery}
                {$lunasQuery}
            GROUP BY PK.id_paket, PK.paket
            ORDER BY PK.id_paket";
        
        $query = $this->db->query($sql);
        
        $result = $query->result();
        return $result;
    }
    
    function getPaketReport($year, $month){
        $year = escape($year);
        $month = escape($month);
        $sql = "
            SELECT
                PK.id_paket,
                PK.paket,
                U.unit,
                COUNT(*) AS jumlah_pesanan,
                SUM(IP.QTY) AS jumlah_item,
                SUM(IP.HARGA) AS total
            FROM paket PK, item_pesanan IP, pesanan P, unit U
            WHERE PK.id_paket=IP.id_paket
                AND IP.id_pesanan=P.id_pesanan
                AND U.id_unit=IP.id_unit
                AND YEAR(P.tanggal_pesanan) = ?
                AND MONTH(P.tanggal_pesanan) = ?
            GROUP BY PK.id_paket, PK.paket, U.id_unit";
        
        $query = $this->db->query($sql, array($year, $month));
        $result = $query->result();
        return $result;
    }
    
    function getCustomerReport($year, $month){
        $year = escape($year);
        $month = escape($month);
        $sql = "
            SELECT
                C.id_customer,
                C.nama_customer,
                COUNT(*) AS jumlah_pesanan,
                SUM(P.total) AS total,
                SUM(COALESCE(K.potongan,0)) AS kupon
            FROM customer C, pesanan P
            LEFT JOIN kupon K
            ON P.id_pesanan=K.id_pesanan
            WHERE P.id_customer=C.id_customer
                AND YEAR(P.tanggal_pesanan) = ?
                AND MONTH(P.tanggal_pesanan) = ?
            GROUP BY C.id_customer, C.nama_customer";
        
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
                C.nama_customer,
                P.subtotal-P.total AS potongan
            FROM pesanan P, customer C
            WHERE P.ID_CUSTOMER=C.ID_CUSTOMER
                AND YEAR(P.tanggal_pesanan) = ?
                AND MONTH(P.tanggal_pesanan) = ?";
        
        $query = $this->db->query($sql, array($year, $month));
        $result = $query->result();
        return $result;
    }
    
    function getYears($tanggal="pesanan", $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        $sql = "
            SELECT DISTINCT YEAR(P.tanggal_{$tanggal}) AS tahun
            FROM pesanan P
            WHERE TRUE
                {$lunasQuery}";
        
        $query = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }
    function getMonths($year, $tanggal="pesanan", $lunas=null){
        $tanggal = strtoupper($tanggal);
        if($tanggal == "lunas") $lunas = true;
        $lunasQuery = $lunas == null ? "" : 
            ($lunas == true ? " AND P.tanggal_lunas IS NOT NULL"
                : " AND P.tanggal_lunas IS NULL");
        $sql = "
            SELECT DISTINCT MONTH(P.tanggal_{$tanggal}) AS bulan
            FROM pesanan P
            WHERE YEAR(P.tanggal_{$tanggal}) = ?
                {$lunasQuery}";
        
        $query = $this->db->query($sql, array($year));
        $result = $query->result();
        return $result;
    }
}