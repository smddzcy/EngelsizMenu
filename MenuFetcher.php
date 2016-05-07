<?php

require_once 'vendor/luracast/restler/vendor/restler.php';
require_once "Controller/RestaurantController.php";
require_once "Controller/MenuController.php";
require_once "Controller/DishController.php";

/**
 * Class MenuFetcher
 */
class MenuFetcher
{
    public static function fetchMenuFromYemekSepeti(String $path)
    {
        $data = new CurlRequest("https://www.yemeksepeti.com/" . $path);
        preg_match('#AnalyticsData.RestaurantName\\s\\=\\s"([^\\|]*)#si', $data, $restaurantName);
        if (!array_key_exists(1, $restaurantName)) {
            preg_match('#ys-h2">([^,]*),#si', $data, $restaurantName);
        }
        $restaurantName = trim($restaurantName[1]);
        if (RestaurantController::checkIfRestaurantExistsWithName($restaurantName)) {
            $restaurantID = RestaurantController::getRestaurantDetailsWithName($restaurantName)["restaurant_id"];
        } else {
            $restaurantID = RestaurantController::addRestaurant($restaurantName);
        }

        // get all menus
        preg_match_all('#<div[^>]*id="menu_[^>]*>(.*?)</ul>#si', $data, $menus);
        foreach ($menus[1] as $menu) {
            // get menu name
            preg_match("#<h2>.*?<b>([^<]*)</b>#si", $menu, $menuName);
            if (!array_key_exists(1, $menuName)) throw new Exception("No menu for this restaurant");
            $menuName = $menuName[1];
            // add the menu
            $menuID = MenuController::addMenuWithRestaurantID($restaurantID, $menuName);

            // get all dishes from menu
            preg_match_all("#<li>(.*?)</li>#si", $menu, $dishes);
            foreach ($dishes[1] as $dish) {
                preg_match('#<a[^<]*data-product-id[^>]*>(.*?)</a>#si', $dish, $dishName);
                $dishName = $dishName[1];

                preg_match('#class="productInfo">[^<]*<p>([^<]*)</p>#si', $dish, $dishDescription);
                $dishDescription = $dishDescription[1];

                preg_match('#class="[^"]*newPrice">([^ ]*)#si', $dish, $dishPrice);
                $dishPrice = str_replace(",", ".", $dishPrice[1]);

                DishController::addDishWithMenuID($menuID, $dishName, $dishPrice, $dishDescription);
            }
        }
    }
}

if (count($argv) > 1) {
    MenuFetcher::fetchMenuFromYemekSepeti($argv[1]);
}