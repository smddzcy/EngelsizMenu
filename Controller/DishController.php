<?php

use Luracast\Restler\RestException;

/**
 * Dish controller
 */
class DishController
{

    /**
     * Get dishes of a menu
     *
     * @param int $id ID of the menu
     * @return array Restaurant ID, name and location - as latitude & longitude
     * @throws RestException DB couldn't be reached
     * @url GET get/{id}
     */
    public static function getDishesWithMenuID(int $id)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM dishes WHERE menu_id = :id");
        if ($query->execute([
                ":id" => $id
            ]) === false
        ) {
            throw new RestException(412, "Yemek verisi veritabanından getirilemedi.");
        }
        $ret = $query->fetchAll();
        if($ret === false){
            throw new RestException(404, "Yemek bulunamadı.");
        }
        return $ret;
    }

    /**
     * Add dish to a menu
     *
     * @param int $id ID of the menu
     * @param string $dishName Name of the dish
     * @param string $dishDescription Description of the dish
     * @param string $dishPrice Price of the dish
     * @return int Dish ID of the newly added dish
     * @throws RestException DB couldn't be reached
     * @url GET add/{id}/{dishName}/{dishPrice}/{dishDescription}
     */
    public static function addDishWithMenuID(int $id, string $dishName, string $dishPrice, string $dishDescription)
    {
        $db = DB::getInstance();
        $query = $db->prepare("INSERT INTO dishes (menu_id, dish_name, dish_description, dish_price) VALUES (:id, :dishName, :dishDescription, :dishPrice)");
        if ($query->execute([
                ":id" => $id,
                ":dishName" => $dishName,
                ":dishDescription" => $dishDescription,
                ":dishPrice" => $dishPrice
            ]) === false
        ) {
            throw new RestException(412, "Menu veritabanına eklenemedi.");
        }
        return (int)$db->lastInsertId();
    }


}