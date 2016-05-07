<?php

error_reporting(E_ALL); // Development
//error_reporting(E_ERROR);

require_once 'vendor/luracast/restler/vendor/restler.php';
require_once "Controller/RestaurantController.php";
require_once "Controller/MenuController.php";
require_once "Controller/DishController.php";

use Luracast\Restler\Restler;

$r = new Restler();
$r->addAPIClass('RestaurantController', 'restaurant');
$r->addAPIClass('MenuController', 'menu');
$r->addAPIClass('DishController', 'dish');
$r->handle();
