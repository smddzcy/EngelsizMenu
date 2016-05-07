<?php

use Luracast\Restler\RestException;

/**
 * Restaurant controller
 */
class RestaurantController
{
    /**
     * Get all restaurants available in the database
     *
     * @return array Restaurant IDs, names and locations - as latitudes & longitudes
     * @throws RestException DB couldn't be reached
     * @url GET getAll
     */
    public function getAllRestaurants()
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants");
        if($query->execute() === false){
            throw new RestException(503, "Veritabanı bağlantısı kurulamadı.");
        }
        return $query->fetchAll();
    }

    /**
     * Get details of a restaurant with ID
     *
     * @param int $id ID of the restaurant
     * @return array Restaurant ID, name and location - as latitude & longitude
     * @throws RestException DB couldn't be reached
     * @url GET get/{id}
     */
    public function getRestaurantDetailsWithID(int $id)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants WHERE restaurant_id = :id LIMIT 0,1");
        if($query->execute([
                ":id" => $id
            ]) === false){
            throw new RestException(412, "Restoran verisi veritabanından getirilemedi.");
        }
        return $query->fetch();
    }


}