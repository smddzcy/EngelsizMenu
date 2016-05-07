<?php

use Luracast\Restler\RestException;

/**
 * Menu controller
 */
class MenuController
{

    /**
     * Get menus of a restaurant
     *
     * @param int $id ID of the restaurant
     * @return array Restaurant ID, name and location - as latitude & longitude
     * @throws RestException DB couldn't be reached
     * @url GET get/{id}
     */
    public function getMenusWithRestaurantID(int $id)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM menus WHERE restaurant_id = :id");
        if ($query->execute([
                ":id" => $id
            ]) === false
        ) {
            throw new RestException(412, "Menu verisi veritabanından getirilemedi.");
        }
        $ret = $query->fetchAll();
        if ($ret === false) {
            throw new RestException(404, "Menü bulunamadı.");
        }
        return $ret;
    }

    /**
     * Add menu to a restaurant
     *
     * @param int $id ID of the restaurant
     * @param string $menuName Menu name
     * @return int Menu ID of newly added menu
     * @throws RestException DB couldn't be reached
     * @url GET add/{id}/{menuName}
     */
    public function addMenuWithRestaurantID(int $id, string $menuName)
    {
        $db = DB::getInstance();
        if (!RestaurantController::restaurantExists($id)) {
            throw new RestException(404, "Restoran veritabanında bulunamadı.");
        }
        $query = $db->prepare("INSERT INTO menus (restaurant_id, menu_name) VALUES (:id, :menuName)");
        if ($query->execute([
                ":id" => $id,
                ":menuName" => $menuName
            ]) === false
        ) {
            throw new RestException(412, "Menu veritabanına eklenemedi.");
        }
        return (int)$db->lastInsertId();
    }


}