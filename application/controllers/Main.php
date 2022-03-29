<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Main extends CI_Controller {

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
		$lineMonth = max($month, 6);
		$stats = new stdClass();
		$stats->pesananBulanan = $this->Laundry->getMonthlyPesanan("PESANAN", null, $month);
		$stats->pesananBulanIni = $this->Laundry->getCurrentMonthPesanan("PESANAN", null, $month);
		$stats->pesananBelumLunas = $this->Laundry->getOutstandingPesanan("LUNAS");
		$stats->pesananBelumDiambil = $this->Laundry->getOutstandingPesanan("AMBIL");
		$stats->pemasukanBulanan = $this->Laundry->getMonthlyIncome("LUNAS", true, $month);
		$stats->pemasukanBulanIni = $this->Laundry->getCurrentMonthIncome("LUNAS", true);
		$stats->pengeluaranBulanan = $this->Laundry->getMonthlySpending($month);
		$stats->pengeluaranBulanIni = $this->Laundry->getCurrentMonthSpending();
		$dataPesananHarian = $this->Laundry->getWeekdayStats("PESANAN", null, $month);
		$dataPenjualanPaket = $this->Laundry->getMonthlyPaketSells("PESANAN", null, $month);
		$dataTopPemesan = $this->Laundry->getTopCountStatsCustomer("PESANAN", null, $month, 10);
		$dataTopPembayar = $this->Laundry->getTopAmountStatsCustomer("LUNAS", null, $month, 10);
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
			$crud->required_fields('NAMA_CUSTOMER');
			$crud->columns('ID_CUSTOMER', 'NAMA_CUSTOMER', 'ALAMAT_CUSTOMER', 'TELEPON_CUSTOMER');
			
			$crud->add_action('Pesanan', '', '','ui-icon-plus',array($this,'_callback_pesanan_customer_action'));
			$crud->display_as("ID_CUSTOMER", "ID");
			$crud->display_as("NAMA_CUSTOMER", " NAMA");
			$crud->display_as("ALAMAT_CUSTOMER", "ALAMAT");
			$crud->display_as("TELEPON_CUSTOMER", "TELEPON");

			$output = $crud->render();
			$output->title = "Customer";
			$output->titlePlain = "Customer";
			

			if($crud->getState() == "read"){
				$lineMonth = max(6, $month);
				$output->bulan = $month;
				$output->lineMonth=$lineMonth;
				$output->baseUrl = base_url()."customer/read/" . $idCustomer."/";
				$output->dataPesananHarian = $this->Laundry->getWeekdayStats("PESANAN", null, $month, $idCustomer);
				$output->dataPesananPaket = $this->Laundry->getMonthlyPaketSells("PESANAN", null, $month, $idCustomer);
				$output->dataPesanan = $this->Laundry->getMonthlyPesananStats("PESANAN", null, $lineMonth, $idCustomer);
				$output->dataPembayaran = $this->Laundry->getMonthlyPesananStats("LUNAS", null, $lineMonth, $idCustomer);
				
				$this->load->view('profile.html',(array)$output);
			}else{
				$this->_example_output($output);
			}

		}catch(Exception $e){
			show_error($e->getMessage().' --- '.$e->getTraceAsString());
		}
	}
	
	
	public function pesanan($idCustomer='', $op='', $idPesanan=''){
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
			
			$crud->display_as('ID_PESANAN', "ID");
			$crud->display_as('ID_CUSTOMER', "CUSTOMER");
			if($op == 'add'){
				$crud->change_field_type('ID_PESANAN', 'integer');
				$crud->change_field_type('SUBTOTAL', 'hidden', 0);
				$crud->change_field_type('TOTAL', 'hidden', 0);
				$crud->add_fields("ID_PESANAN", "ID_CUSTOMER", "NOTA", "TANGGAL_PESANAN", "TANGGAL_LUNAS", "TANGGAL_AMBIL", "KETERANGAN");
			}else if ($op == '' || $op == 'success'){
				$crud->display_as('ID_CUSTOMER', "CUST");
				$crud->display_as('NOTA', "NO");
				$crud->display_as('TANGGAL_PESANAN', "PESAN");
				$crud->display_as('TANGGAL_LUNAS', "LUNAS");
				$crud->display_as('TANGGAL_AMBIL', "AMBIL");
			}
			if($idCustomer){
				$crud->columns('ID_PESANAN', 'NOTA', 'TANGGAL_PESANAN', 'TANGGAL_LUNAS', 'TANGGAL_AMBIL', 'SUBTOTAL', 'TOTAL');
				
				$crud->where("ID_CUSTOMER", $idCustomer);
				if ($op == 'add'){
				   $crud->change_field_type('ID_CUSTOMER', 'hidden', $idCustomer);
				}else if ($op == 'read'){
					$crud->callback_read_field('ID_CUSTOMER', function ($value, $primary_key) {
						$idCustomer = $value;
						$customer = $this->Laundry->getCustomer($idCustomer);
						$urlCustomer = $this->url_customer($idCustomer);
						return "<a href='{$urlCustomer}'>{$customer->NAMA_CUSTOMER} ({$idCustomer})</a>";
					});
				}
			}else{
				$crud->required_fields('ID_CUSTOMER');
				$crud->columns('ID_PESANAN', 'ID_CUSTOMER',  'NOTA', 'TANGGAL_PESANAN', 'TANGGAL_LUNAS', 'TANGGAL_AMBIL', 'TOTAL');
				
				
				
				if($op == ''){
					$crud->callback_column('ID_CUSTOMER',array($this,'_callback_pesanan_customer_url'));
				}else if ($op == 'read'){
					$crud->callback_read_field('ID_CUSTOMER', function ($value, $primary_key) {
						$idCustomer = $value;
						$customer = $this->Laundry->getCustomer($idCustomer);
						$urlCustomer = $this->url_customer($idCustomer);
						return "<a href='{$urlCustomer}'>{$customer->NAMA_CUSTOMER} ({$idCustomer})</a>";
					});
				}else{
					$crud->set_relation('ID_CUSTOMER','CUSTOMER','{NAMA_CUSTOMER} ({ID_CUSTOMER})');
				}
			}
			
			
			$crud->add_action('Items', '', '','ui-icon-plus',array($this,'_callback_item_pesanan_action'));
			$crud->add_action('Kupon', '', '','ui-icon-plus',array($this,'_callback_kupon_pesanan_action'));
			$crud->unset_clone();

			$output = $crud->render();
			$output->title = "Pesanan";
			$output->titlePlain = "Pesanan";
			if($idCustomer == '' && $idPesanan != ''){
				$idCustomer = $this->Laundry->getIdCustomerPesanan($idPesanan);
			}
			if($idCustomer != ''){
				$customer = $this->Laundry->getCustomer($idCustomer);
				$url = $this->url_customer($idCustomer);
				$output->title = $output->title . " Milik <a href='{$url}'>{$customer->NAMA_CUSTOMER} ({$idCustomer})</a>";
				$output->titlePlain = $output->titlePlain . " Milik {$customer->NAMA_CUSTOMER} ({$idCustomer})";
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
		return $this->url_pesanan_customer($row->ID_CUSTOMER);
	}
	public function _callback_pesanan_customer_url($value, $row)
	{
		$cust = $this->Laundry->getCustomer($row->ID_CUSTOMER);
		$url = $this->url_pesanan_customer($row->ID_CUSTOMER);
		$el = "<a href='{$url}'>{$cust->NAMA_CUSTOMER}</a>";
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
			$crud->required_fields('PAKET', 'HARGA');
			$crud->columns('ID_ITEM', 'ID_PAKET', 'ID_UNIT', 'QTY', 'HARGA');
			$crud->set_relation("ID_PAKET", "paket", "PAKET");
			$crud->set_relation("ID_UNIT", "unit", "UNIT");
			
			$crud->where("ID_PESANAN", $idPesanan);
			
			if ($op == 'add'){
			   $crud->change_field_type('ID_PESANAN', 'hidden', $idPesanan);
			}
			

			$output = $crud->render();
			if($idPesanan == '' && $idItem != '') $idPesanan = $this->Laundry->getIdPesananItem($idPesanan);
			$pesanan = $this->Laundry->getPesanan($idPesanan);
			$customer = $this->Laundry->getCustomer($pesanan->ID_CUSTOMER);
			$urlCustomer = $this->url_pesanan_customer($pesanan->ID_CUSTOMER);
			$urlPesanan = $this->url_pesanan($idPesanan);
			$output->title = "Item Milik <a href='{$urlPesanan}'>Pesanan {$idPesanan}</a>";
			$output->titlePlan = "Item Milik {$idPesanan}";
			$output->info = "
				<p>
					Customer: <a href='{$urlCustomer}'>{$customer->NAMA_CUSTOMER} ({$customer->ID_CUSTOMER})</a></br>
					Tanggal Pesan: {$pesanan->TANGGAL_PESANAN}
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
			$crud->required_fields('POTONGAN');
			$crud->columns('ID_KUPON', 'POTONGAN');
			
			$crud->where("ID_PESANAN", $idPesanan);
			
			if($idPesanan == '' && $idKupon != '') $idPesanan = $this->Laundry->getIdPesananKupon($idKupon);
			$idCustomer = $this->Laundry->getIdCustomerPesanan($idPesanan);
			if(!$idCustomer){
				show_404();
				return;
			}
			if ($op == 'add'){
			   $crud->change_field_type('ID_PESANAN', 'hidden', $idPesanan);
			   $crud->change_field_type('ID_CUSTOMER', 'hidden', $idCustomer);
			}else{
				$crud->callback_column('ID_CUSTOMER',array($this,'_callback_customer_url'));
				$crud->display_as('ID_CUSTOMER', "CUSTOMER");
			}
			
			$crud->add_action('Kwitansi', '', '','ui-icon-plus',array($this,'_callback_item_kupon_action'));

			$output = $crud->render();
			$pesanan = $this->Laundry->getPesanan($idPesanan);
			$customer = $this->Laundry->getCustomer($pesanan->ID_CUSTOMER);
			$urlCustomer = $this->url_pesanan_customer($pesanan->ID_CUSTOMER);
			$urlPesanan = $this->url_pesanan($idPesanan);
			$output->title = "Kupon Milik <a href='{$urlPesanan}'>Pesanan {$idPesanan}</a>";
			$output->titlePlain = "Kupon Milik Pesanan {$idPesanan}";
			$output->info = "
				<p>
					Customer: <a href='{$urlCustomer}'>{$customer->NAMA_CUSTOMER} ({$customer->ID_CUSTOMER})</a></br>
					Tanggal Pesan: {$pesanan->TANGGAL_PESANAN}
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
			$crud->required_fields('ID_PESANAN');
			$crud->columns('ID_KUPON', 'ID_PESANAN');
			
			$crud->where("ID_KUPON", $idKupon);
			
			if($idKupon == '' && $idItem != '') $idKupon = $this->Laundry->getIdKuponItem($idItem);
			$urlKupon = $this->url_kupon($idKupon);
			$idPesanan = $this->Laundry->getIdPesananKupon($idKupon);
			$pesanan = $this->Laundry->getPesanan($idPesanan);
			$idCustomer = $pesanan->ID_CUSTOMER;
			
			$relationWhere = array(
				"ID_CUSTOMER"=> $idCustomer
			);
			
			if ($op == 'add'){
				$crud->change_field_type('ID_KUPON', 'hidden', $idKupon);
				
			}
			
			
			$crud->set_relation('ID_PESANAN','pesanan','{ID_PESANAN}: {TANGGAL_PESANAN}: {TOTAL}', $relationWhere);
			
			$output = $crud->render();
			
			$urlPesanan = $this->url_pesanan($idPesanan);
			$customer = $this->Laundry->getCustomer($idCustomer);
			$urlCustomer = $this->url_customer($idCustomer);
			$output->title = "Kwitansi Milik <a href='{$urlKupon}'>Kupon {$idKupon}</a>";
			$output->titlePlain = "Kwitansi Milik Kupon {$idKupon}";
			$output->info = "
				<p>
					Customer: <a href='{$urlCustomer}'>{$customer->NAMA_CUSTOMER} ({$customer->ID_CUSTOMER})</a></br>
					Pesanan: <a href='{$urlPesanan}'>{$idPesanan}</a><br>
					Tanggal Pesan: {$pesanan->TANGGAL_PESANAN}
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
			$crud->required_fields('ITEM_PENGELUARAN', 'JUMLAH_PENGELUARAN');
			$crud->columns('ID_PENGELUARAN', 'TANGGAL_PENGELUARAN', 'ITEM_PENGELUARAN', 'JUMLAH_PENGELUARAN');
			$crud->display_as("ID_PENGELUARAN", "ID");
			$crud->display_as("TANGGAL_PENGELUARAN", "TANGGAL");
			$crud->display_as("ITEM_PENGELUARAN", "ITEM");
			$crud->display_as("JUMLAH_PENGELUARAN", "JUMLAH");
			

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
			$tahuns = array($tahun);
		}
		$bulans = $this->Laundry->getMonths($tahun);
		if(count($bulans) == 0){
			$bulans = array($bulan);
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
