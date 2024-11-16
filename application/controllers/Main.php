<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Main extends HungNG_CI_Base_Controllers {

    public function __construct()
    {
        parent::__construct();

        $this->load->database();
        $this->load->helper('url');

        $this->load->library('grocery_CRUD');
        $this->load->model('Laundry');
        setlocale(LC_ALL, 'id_ID');
    }

    public function _example_output($output = null)
    {
        $this->load->view('general.html',(array)$output);
    }

    public function index($month=3)
    {
        $q = 0;
        $lineMonth = max($month, 6);
        $stats = new stdClass();
        $stats->pesananBulanan = $this->Laundry->getMonthlyPesanan("pesanan", null, $month);
        $stats->pesananBulanIni = $this->Laundry->getCurrentMonthPesanan("pesanan", null, $month);
        $stats->pesananBelumLunas = $this->Laundry->getOutstandingPesanan("lunas");
        $stats->pesananBelumDiambil = $this->Laundry->getOutstandingPesanan("ambil");
        $stats->pemasukanBulanan = $this->Laundry->getMonthlyIncome("lunas", true, $month);
        $stats->pemasukanBulanIni = $this->Laundry->getCurrentMonthIncome("lunas", true);
        $stats->pengeluaranBulanan = $this->Laundry->getMonthlySpending($month);
        $stats->pengeluaranBulanIni = $this->Laundry->getCurrentMonthSpending();
        $dataPesananHarian = $this->Laundry->getWeekdayStats("pesanan", null, $month);
        $dataPenjualanPaket = $this->Laundry->getMonthlyPaketSells("pesanan", null, $month);
        $dataTopPemesan = $this->Laundry->getTopCountStatsCustomer("pesanan", null, $month, 10);
        $dataTopPembayar = $this->Laundry->getTopAmountStatsCustomer("lunas", null, $month, 10);
        $dataPemasukanPengeluaran = $this->Laundry->getMonthlyCashflowStats($lineMonth);
        $dataLabaRugi = $this->Laundry->getMonthlyProfitStats($lineMonth);
        $data = array(
            "stats"=>$stats,
            "month"=>$month,
            "baseUrl"=>base_url(),
            "dataPesananHarian"=>$dataPesananHarian,
            "dataPenjualanPaket"=>$dataPenjualanPaket,
            "dataTopPemesan"=>$dataTopPemesan,
            "dataTopPembayar"=>$dataTopPembayar,
            "dataPemasukanPengeluaran"=>$dataPemasukanPengeluaran,
            "dataLabaRugi"=>$dataLabaRugi,
            "lineMonth"=>$lineMonth
        );
        $this->load->view("dashboard.html", $data);
    }
    
    public function customer($op='', $idCustomer='', $month=3){
        try{
            $crud = new grocery_CRUD();

            $crud->set_theme('datatables');
            $crud->set_table('customer');
            $crud->set_subject('Customer');
            $crud->required_fields('nama_customer');
            $crud->columns('id_customer', 'nama_customer', 'alamat_customer', 'telepon_customer');
            
            $crud->add_action('Pesanan', '', '','ui-icon-plus',array($this,'_callback_pesanan_customer_action'));
            $crud->display_as("id_customer", "ID");
            $crud->display_as("nama_customer", " NAMA");
            $crud->display_as("alamat_customer", "ALAMAT");
            $crud->display_as("telepon_customer", "TELEPON");

            $output = $crud->render();
            $output->title = "Customer";
            $output->titlePlain = "Customer";
            

            if($crud->getState() == "read"){
                $lineMonth = max(6, $month);
                $output->bulan = $month;
                $output->lineMonth=$lineMonth;
                $output->baseUrl = base_url()."customer/read/" . $idCustomer."/";
                $output->dataPesananHarian = $this->Laundry->getWeekdayStats("pesanan", null, $month, $idCustomer);
                $output->dataPesananPaket = $this->Laundry->getMonthlyPaketSells("pesanan", null, $month, $idCustomer);
                $output->dataPesanan = $this->Laundry->getMonthlyPesananStats("pesanan", null, $lineMonth, $idCustomer);
                $output->dataPembayaran = $this->Laundry->getMonthlyPesananStats("lunas", null, $lineMonth, $idCustomer);
                
                $this->load->view('profile.html',(array)$output);
            }else{
                $this->_example_output($output);
            }

        }catch(Exception $e){
            show_error($e->getMessage().' --- '.$e->getTraceAsString());
        }
    }
    
    
    public function pesanan($idCustomer='', $op='', $idPesanan=''){
        $this->output->enable_profiler(TRUE);
        try{
            if(!is_numeric($idCustomer) && $idCustomer != ''){
                $idPesanan = $op;
                $op = $idCustomer;
                $idCustomer = '';
            }
            
            $crud = new grocery_CRUD();

            $crud->set_theme('datatables');
            $crud->set_table('pesanan');
            $crud->set_subject('Pesanan');
            
            $crud->display_as('id_pesanan', "ID");
            $crud->display_as('id_customer', "Customer");
            if($op == 'add'){
                $crud->change_field_type('id_pesanan', 'integer');
                $crud->change_field_type('subtotal', 'hidden', 0);
                $crud->change_field_type('total', 'hidden', 0);
                $crud->add_fields('id_pesanan', "id_customer", "nota", "tanggal_pesanan", "tanggal_lunas", "tanggal_ambil", "keterangan");
            }else if ($op == '' || $op == 'success'){
                $crud->display_as('id_customer', "Cust");
                $crud->display_as('nota', "No");
                $crud->display_as('tanggal_pesanan', "Pesan");
                $crud->display_as('tanggal_lunas', "Lunas");
                $crud->display_as('tanggal_ambil', "Ambil");
            }
            if($idCustomer){
                $crud->columns('id_pesanan', 'nota', 'tanggal_pesanan', 'tanggal_lunas', 'tanggal_ambil', 'subtotal', 'total');
                
                $crud->where('id_customer', $idCustomer);
                if ($op == 'add'){
                   $crud->change_field_type('id_customer', 'hidden', $idCustomer);
                }else if ($op == 'read'){
                    $crud->callback_read_field('id_customer', function ($value, $primary_key) {
                        $idCustomer = $value;
                        $customer = $this->laundry->getCustomer($idCustomer);
                        $urlCustomer = $this->url_customer($idCustomer);
                        return "<a href='{$urlCustomer}'>{$customer->nama_customer} ({$idCustomer})</a>";
                    });
                }
            }else{
                $crud->required_fields('id_customer');
                $crud->columns('id_pesanan', 'id_customer',  'nota', 'tanggal_pesanan', 'tanggal_lunas', 'tanggal_ambil', 'total');
                
                if($op == ''){
                    $crud->callback_column('id_customer',array($this,'_callback_pesanan_customer_url'));
                }else if ($op == 'read'){
                    $crud->callback_read_field('id_customer', function ($value, $primary_key) {
                        $idCustomer = $value;
                        $customer = $this->laundry->getCustomer($idCustomer);
                        $urlCustomer = $this->url_customer($idCustomer);
                        return "<a href='{$urlCustomer}'>{$customer->nama_customer} ({$idCustomer})</a>";
                    });
                }else{
                    $crud->set_relation('id_customer','customer','{nama_customer} ({id_customer})');
                }
            }
            
            
            $crud->add_action('items', '', '','ui-icon-plus',array($this,'_callback_item_pesanan_action'));
            $crud->add_action('kupon', '', '','ui-icon-plus',array($this,'_callback_kupon_pesanan_action'));
            $crud->unset_clone();

            $output = $crud->render();
            $output->title = "pesanan";
            $output->titlePlain = "pesanan";
            if($idCustomer == '' && $idPesanan != ''){
                $idCustomer = $this->laundry->getIdCustomerPesanan($idPesanan);
            }
            if($idCustomer != ''){
                $customer = $this->laundry->getCustomer($idCustomer);
                $url = $this->url_customer($idCustomer);
                $output->title = $output->title . " milik <a href='{$url}'>{$customer->nama_customer} ({$idCustomer})</a>";
                $output->titlePlain = $output->titlePlain . " milik {$customer->nama_customer} ({$idCustomer})";
            }

            $this->_example_output($output);

        }catch(Exception $e){
            show_error($e->getMessage().' --- '.$e->getTraceAsString());
        }
    }
    function url_pesanan_customer($idCustomer){
        return site_url()."customer/".$idCustomer."/pesanan";
    }
    function url_customer($idCustomer){
        return site_url()."customer/read/".$idCustomer;
    }
    function url_pesanan_kupon($idCustomer){
        return site_url()."customer/".$idCustomer."/pesanan";
    }
    function _callback_pesanan_customer_action($primary_key , $row)
    {
        return $this->url_pesanan_customer($row->id_customer);
    }
    public function _callback_pesanan_customer_url($value, $row)
    {
        $cust = $this->Laundry->getCustomer($row->id_customer);
        $url = $this->url_pesanan_customer($row->id_customer);
        $el = "<a href='{$url}'>{$cust->nama_customer}</a>";
        return $el;
    }

    
    public function item_pesanan($idPesanan='', $op='', $idItem=''){
        try{
            if(!is_numeric($idPesanan) && $idPesanan != ''){
                $idItem = $op;
                $op = $idPesanan;
                $idPesanan = '';
            }
            $crud = new grocery_CRUD();

            $crud->set_theme('datatables');
            $crud->set_table('item_pesanan');
            $crud->set_subject('Item Pesanan');
            $crud->required_fields('paket', 'harga');
            $crud->columns('id_item', 'id_paket', 'id_unit', 'qty', 'harga');
            $crud->set_relation("id_paket", "paket", "paket");
            $crud->set_relation("id_unit", "unit", "unit");
            
            $crud->where("id_pesanan", $idPesanan);
            
            if ($op == 'add'){
               $crud->change_field_type('id_pesanan', 'hidden', $idPesanan);
            }
            

            $output = $crud->render();
            if($idPesanan == '' && $idItem != '') $idPesanan = $this->Laundry->getIdPesananItem($idPesanan);
            $pesanan = $this->Laundry->getPesanan($idPesanan);
            $customer = $this->Laundry->getCustomer($pesanan->id_customer);
            $urlCustomer = $this->url_pesanan_customer($pesanan->id_customer);
            $urlPesanan = $this->url_pesanan($idPesanan);
            $output->title = "Item Milik <a href='{$urlPesanan}'>Pesanan {$idPesanan}</a>";
            $output->titlePlan = "Item Milik {$idPesanan}";
            $output->info = "
                <p>
                    Customer: <a href='{$urlCustomer}'>{$customer->nama_customer} ({$customer->id_customer})</a></br>
                    Tanggal Pesan: {$pesanan->tanggal_pesanan}
                </p>";

            $this->_example_output($output);

        }catch(Exception $e){
            show_error($e->getMessage().' --- '.$e->getTraceAsString());
        }
    }
    
    public function kupon($idPesanan='', $op='', $idKupon=''){
        try{
            if(!is_numeric($idPesanan) && $idPesanan != ''){
                $idKupon = $op;
                $op = $idPesanan;
                $idPesanan = '';
            }
            
            $crud = new grocery_CRUD();

            $crud->set_theme('datatables');
            $crud->set_table('kupon');
            $crud->set_subject('Kupon');
            $crud->required_fields('potongan');
            $crud->columns('id_kupon', 'potongan');
            
            $crud->where("id_pesanan", $idPesanan);
            
            if($idPesanan == '' && $idKupon != '') $idPesanan = $this->Laundry->getIdPesananKupon($idKupon);
            $idCustomer = $this->Laundry->getIdCustomerPesanan($idPesanan);
            if(!$idCustomer){
                show_404();
                return;
            }
            if ($op == 'add'){
               $crud->change_field_type('id_pesanan', 'hidden', $idPesanan);
               $crud->change_field_type('id_customer', 'hidden', $idCustomer);
            }else{
                $crud->callback_column('id_customer',array($this,'_callback_customer_url'));
                $crud->display_as('id_customer', "customer");
            }
            
            $crud->add_action('Kwitansi', '', '','ui-icon-plus',array($this,'_callback_item_kupon_action'));

            $output = $crud->render();
            $pesanan = $this->Laundry->getPesanan($idPesanan);
            $customer = $this->Laundry->getCustomer($pesanan->id_customer);
            $urlCustomer = $this->url_pesanan_customer($pesanan->id_customer);
            $urlPesanan = $this->url_pesanan($idPesanan);
            $output->title = "Kupon Milik <a href='{$urlPesanan}'>Pesanan {$idPesanan}</a>";
            $output->titlePlain = "Kupon Milik Pesanan {$idPesanan}";
            $output->info = "
                <p>
                    Customer: <a href='{$urlCustomer}'>{$customer->nama_customer} ({$customer->id_customer})</a></br>
                    Tanggal Pesan: {$pesanan->tanggal_pesanan}
                </p>";

            $this->_example_output($output);

        }catch(Exception $e){
            show_error($e->getMessage().' --- '.$e->getTraceAsString());
        }
    }
    function url_pesanan($idPesanan){
        return site_url()."pesanan/read/".$idPesanan;
    }
    function _callback_kupon_pesanan_action($primary_key , $row)
    {
        return site_url()."pesanan/{$primary_key}/kupon";
    }
    function _callback_item_pesanan_action($primary_key , $row)
    {
        return site_url()."pesanan/{$primary_key}/items";
    }
    function _callback_item_kupon_action($primary_key , $row)
    {
        return site_url()."kupon/{$primary_key}/items";
    }
     
    public function item_kupon($idKupon='', $op='', $idItem=''){
        try{
            if(!is_numeric($idKupon) && $idKupon != ''){
                $idItem = $op;
                $op = $idKupon;
                $idKupon = '';
            }
            $crud = new grocery_CRUD();

            $crud->set_theme('datatables');
            $crud->set_table('item_kupon');
            $crud->set_subject('Kwitansi Kupon');
            $crud->required_fields('id_pesanan');
            $crud->columns('id_kupon', 'id_pesanan');
            
            $crud->where("id_kupon", $idKupon);
            
            if($idKupon == '' && $idItem != '') $idKupon = $this->Laundry->getIdKuponItem($idItem);
            $urlKupon = $this->url_kupon($idKupon);
            $idPesanan = $this->Laundry->getIdPesananKupon($idKupon);
            $pesanan = $this->Laundry->getPesanan($idPesanan);
            $idCustomer = $pesanan->ID_CUSTOMER;
            
            $relationWhere = array(
                "id_customer"=> $idCustomer
            );
            
            if ($op == 'add'){
                $crud->change_field_type('id_kupon', 'hidden', $idKupon);
                
            }
            
            
            $crud->set_relation('id_pesanan','pesanan','{id_pesanan}: {tanggal_pesanan}: {total}', $relationWhere);
            
            $output = $crud->render();
            
            $urlPesanan = $this->url_pesanan($idPesanan);
            $customer = $this->Laundry->getCustomer($idCustomer);
            $urlCustomer = $this->url_customer($idCustomer);
            $output->title = "Kwitansi Milik <a href='{$urlKupon}'>Kupon {$idKupon}</a>";
            $output->titlePlain = "Kwitansi Milik Kupon {$idKupon}";
            $output->info = "
                <p>
                    Customer: <a href='{$urlCustomer}'>{$customer->nama_customer} ({$customer->id_customer})</a></br>
                    Pesanan: <a href='{$urlPesanan}'>{$idPesanan}</a><br>
                    Tanggal Pesan: {$pesanan->tanggal_pesanan}
                </p>";

            $this->_example_output($output);

        }catch(Exception $e){
            show_error($e->getMessage().' --- '.$e->getTraceAsString());
        }
    }
    
    function url_kupon($idKupon){
        return site_url()."kupon/read/".$idKupon;
    }

    public function pengeluaran($op='', $idPengeluaran=''){
        try{
            $crud = new grocery_CRUD();

            $crud->set_theme('datatables');
            $crud->set_table('pengeluaran');
            $crud->set_subject('Pengeluaran');
            $crud->required_fields('item_pengeluaran', 'jumlah_pengeluaran');
            $crud->columns('id_pengeluaran', 'tanggal_pengeluaran', 'item_pengeluaran', 'jumlah_pengeluaran');
            $crud->display_as("id_pengeluaran", "ID");
            $crud->display_as("tanggal_pengeluaran", "TANGGAL");
            $crud->display_as("item_pengeluaran", "ITEM");
            $crud->display_as("jumlah_pengeluaran", "JUMLAH");
            

            $output = $crud->render();
            $output->title = "Pengeluaran";
            $output->titlePlain = "Pengeluaran";

            $this->_example_output($output);

        }catch(Exception $e){
            show_error($e->getMessage().' --- '.$e->getTraceAsString());
        }
    }
    public function laporan($laporan='customer', $tahun='', $bulan=''){
        if($tahun == '' || !$tahun){
            $tahun = date('Y');
        }
        if($bulan == '' || !$bulan){
            $bulan = date('m');
        }
        $laporan = strtolower($laporan);
        if($laporan=='paket'){
            $items = $this->Laundry->getPaketReport($tahun, $bulan);
        }else if ($laporan=="customer"){
            $items = $this->Laundry->getCustomerReport($tahun, $bulan);
        }else{
            $laporan = 'pesanan';
            $items = $this->Laundry->getPesananReport($tahun, $bulan);
        }
        $tahuns = $this->Laundry->getYears();
        if(count($tahuns) == 0){
            $tahuns = array((object)array("tahun" => $tahun));
        }
        $bulans = $this->Laundry->getMonths($tahun);
        if(count($bulans) == 0){
            $bulans = array((object)array("bulan" => $bulan));
        }
        $baseUrl = base_url()."laporan/";
        $data = array(
            "laporan"=>$laporan,
            "tahun"=>$tahun,
            "bulan"=>$bulan,
            "tahuns"=>$tahuns,
            "bulans"=>$bulans,
            "baseUrl"=>$baseUrl,
            //"sBulan"=>date('F', mktime(0,0,0,$bulan)),
            "items"=>$items
        );
        $this->load->view("report.html", $data);
    }
}
