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
        return $query->fetchAll();
    }


}