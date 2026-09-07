/// Endpoints of the remote food-ordering API used by the app.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "http://kasimadalan.pe.hu/yemekler";

  static const String getAllFoods = "$baseUrl/tumYemekleriGetir.php";
  static const String addToCart = "$baseUrl/sepeteYemekEkle.php";
  static const String removeFromCart = "$baseUrl/sepettenYemekSil.php";
  static const String getCart = "$baseUrl/sepettekiYemekleriGetir.php";

  static String foodImageUrl(String imageName) => "$baseUrl/resimler/$imageName";
}
