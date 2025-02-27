enum AppRoutes {
  splashScreen("splash_screen"),

  bottomNavScreen("bottom_nav"),
  locationScreen("location_screen"),
  cartScreen("cart_screen"),
  orderScreen("order_screen"),
  restaurantDetailScreen("restaurant_detail_screen"),
  authScreen("auth_screen");

  const AppRoutes(this.path);

  final String path;
}
