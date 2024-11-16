<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|   example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|   https://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|
| There are three reserved routes:
|
|   $route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|   $route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router which controller/method to use if those
| provided in the URL cannot be matched to a valid route.
|
|   $route['translate_uri_dashes'] = FALSE;
|
| This is not exactly a route, but allows you to automatically route
| controller and method names that contain dashes. '-' isn't a valid
| class or method name character, so it requires translation.
| When you set this option to TRUE, it will replace ALL dashes in the
| controller and method URI segments.
|
| Examples: my-controller/index -> my_controller/index
|       my-controller/my-method -> my_controller/my_method
*/
$route['(:num)'] = 'Main/index/$1';

$route['customer'] = 'Main/customer';
$route['pesanan'] = 'Main/pesanan';
$route['pengeluaran'] = 'Main/pengeluaran';


$route['customer/(:num)/pesanan'] = 'Main/pesanan/$1';
$route['pesanan/(:num)/items'] = 'Main/item_pesanan/$1';
$route['pesanan/(:num)/kupon'] = 'Main/kupon/$1';
$route['kupon/(:num)/items'] = 'Main/item_kupon/$1';

$route['customer/(:num)/pesanan/(:any)'] = 'Main/pesanan/$1/$2';
$route['pesanan/(:num)/items/(:any)'] = 'Main/item_pesanan/$1/$2';
$route['pesanan/(:num)/kupon/(:any)'] = 'Main/kupon/$1/$2';
$route['kupon/(:num)/items/(:any)'] = 'Main/item_kupon/$1/$2';


$route['customer/(:num)/pesanan/(:any)/(:any)'] = 'Main/pesanan/$1/$2/$3';
$route['pesanan/(:num)/items/(:any)/(:any)'] = 'Main/item_pesanan/$1/$2/$3';
$route['pesanan/(:num)/kupon/(:any)/(:any)'] = 'Main/kupon/$1/$2/$3';
$route['kupon/(:num)/items/(:any)/(:any)'] = 'Main/item_kupon/$1/$2/$3';

$route['customer/(:any)'] = 'Main/customer/$1';
$route['pesanan/(:any)'] = 'Main/pesanan/$1';
$route['pengeluaran/(:any)'] = 'Main/pengeluaran/$1';

$route['customer/(:any)/(:any)'] = 'Main/customer/$1/$2';
$route['pesanan/(:any)/(:any)'] = 'Main/pesanan/$1/$2';
$route['pengeluaran/(:any)/(:any)'] = 'Main/pengeluaran/$1/$2';

$route['customer/(:any)/(:any)/(:any)'] = 'Main/customer/$1/$2/$3';

$route['pesanan/(:any)'] = 'Main/pesanan//$1';
$route['item_pesanan/(:any)'] = 'Main/item_pesanan//$1';
$route['kupon/(:any)'] = 'Main/kupon//$1';
$route['item_kupon/(:any)'] = 'Main/item_kupon//$1';

$route['pesanan/(:any)/(:any)'] = 'Main/pesanan//$1/$2';
$route['item_pesanan/(:any)/(:any)'] = 'Main/item_pesanan//$1/$2';
$route['kupon/(:any)/(:any)'] = 'Main/kupon//$1/$2';
$route['item_kupon/(:any)/(:any)'] = 'Main/item_kupon//$1/$2';

$route['laporan'] = 'Main/laporan';
$route['laporan/(:any)'] = 'Main/laporan/$1';
$route['laporan/(:any)/(:num)'] = 'Main/laporan/$1/$2';
$route['laporan/(:any)/(:num)/(:num)'] = 'Main/laporan/$1/$2/$3';

$route['default_controller'] = 'Main';
$route['404_override'] = '';
$route['translate_uri_dashes'] = FALSE;

// $route['welcome'] = 'welcome/index';
// $route['welcome/(:any)'] = 'welcome/$1';
// $route['test'] = 'hungna/test';
