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
    public static function getAllRestaurants()
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants");
        if ($query->execute() === false) {
            throw new RestException(503, "Veritabanı bağlantısı kurulamadı.");
        }
        $ret = $query->fetchAll();
        if ($ret === false) {
            throw new RestException(404, "Restoran bulunamadı.");
        }
        return $ret;
    }

    /**
     * Get details of a restaurant with ID
     *
     * @param int $id ID of the restaurant
     * @return array Restaurant ID, name and location - as latitude & longitude
     * @throws RestException DB couldn't be reached
     * @url GET get/{id}
     */
    public static function getRestaurantDetailsWithID(int $id)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants WHERE restaurant_id = :id LIMIT 0,1");
        if ($query->execute([
                ":id" => $id
            ]) === false
        ) {
            throw new RestException(412, "Restoran verisi veritabanından getirilemedi.");
        }
        $ret = $query->fetch();
        if ($ret === false) {
            throw new RestException(404, "Restoran bulunamadı.");
        }
        return $ret;
    }

    /**
     * Get details of a restaurant with name
     *
     * @param string $name Name of the restaurant
     * @return array Restaurant ID, name and location - as latitude & longitude
     * @throws RestException DB couldn't be reached
     * @url GET get/{name}
     */
    public static function getRestaurantDetailsWithName(String $name)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants WHERE restaurant_name LIKE :name LIMIT 0,1");
        if ($query->execute([
                ":name" => '%' . $name . '%'
            ]) === false
        ) {
            throw new RestException(412, "Restoran verisi veritabanından getirilemedi.");
        }
        $ret = $query->fetch();
        if ($ret === false) {
            throw new RestException(404, "Restoran bulunamadı.");
        }
        return $ret;
    }

    /**
     * Add a new restaurant
     *
     * @param string $restaurantName Restaurant name
     * @param mixed $lat Latitude of the restaurant, default is 0
     * @param mixed $lng Longitude of the restaurant, default is 0
     * @return int Restaurant ID of newly added restaurant
     * @throws RestException DB couldn't be reached
     * @url GET add/{restaurantName}
     */
    public static function addRestaurant(string $restaurantName, $lat = 0, $lng = 0)
    {
        $db = DB::getInstance();
        $query = $db->prepare("INSERT INTO restaurants (restaurant_name, restaurant_lat, restaurant_lng) VALUES (:restaurantName, :lat, :lng)");
        if ($query->execute([
                ":restaurantName" => $restaurantName,
                ":lat" => $lat,
                ":lng" => $lng
            ]) === false
        ) {
            throw new RestException(412, "Restoran veritabanına eklenemedi.");
        }
        return (int)$db->lastInsertId();
    }

    /**
     * Check if a restaurant exists, with its ID
     *
     * @param int $id ID of the restaurant
     * @return boolean True if restaurant exists, false otherwise
     * @throws RestException DB couldn't be reached
     * @url GET check/{id}
     */
    public static function checkIfRestaurantExistsWithID(int $id)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants WHERE restaurant_id = :id LIMIT 0,1");
        if ($query->execute([
                ":id" => $id
            ]) === false
        ) {
            throw new RestException(412, "Restoran verisi veritabanından getirilemedi.");
        }
        $query->fetch();
        return $query->rowCount() > 0;
    }

    /**
     * Check if a restaurant exists, with its name
     *
     * @param string $name Name of the restaurant
     * @return boolean True if restaurant exists, false otherwise
     * @throws RestException DB couldn't be reached
     * @url GET check/{name}
     */
    public static function checkIfRestaurantExistsWithName(string $name)
    {
        $db = DB::getInstance();
        $query = $db->prepare("SELECT * FROM restaurants WHERE restaurant_name = :name LIMIT 0,1");
        if ($query->execute([
                ":name" => $name
            ]) === false
        ) {
            throw new RestException(412, "Restoran verisi veritabanından getirilemedi.");
        }
        $query->fetch();
        return $query->rowCount() > 0;
    }


}