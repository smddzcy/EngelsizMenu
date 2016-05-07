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
    public function getDishesWithMenuID(int $id)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM dishes WHERE menu_id = :id");
        if ($query->execute([
                ":id" => $id
            ]) === false
        ) {
            throw new RestException(412, "Yemek verisi veritabanından getirilemedi.");
        }
        return $query->fetchAll();
    }


}