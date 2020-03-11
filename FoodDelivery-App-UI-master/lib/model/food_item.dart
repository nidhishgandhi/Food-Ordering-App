import 'package:flutter/foundation.dart';

FooditemList fooditemList = FooditemList(foodItems: [
  FoodItem(
    id: 1,
    title: "Burgers",
    hotel: "Danny's Cafe",
    price: 50.0,
    imgUrl:
        "assets/burger.jpg",
  ),
  FoodItem(
    id: 2,
    title: "Breakfast Combo",
    hotel: "Cheese n Chips",
    price: 110.0,
    imgUrl:
        "assets/breakfast.jpg",
  ),
  FoodItem(
    id: 3,
    title: "Noodles",
    hotel: "HideOut Cafe",
    price: 75.0,
    imgUrl: "assets/noodles.jpg",
  ),
  FoodItem(
    id: 4,
    title: "Cheese 7 pizza",
    hotel: "Sweet Spot",
    price: 120.0,
    imgUrl: "assets/pizza.jpg",
  ),
  FoodItem(
    id: 5,
    title: "Fresh Juices",
    hotel: "Iceberg",
    price: 55,
    imgUrl: "assets/beer.jpg",
  ),
  FoodItem(
    id: 6,
    title: "Tea",
    hotel: "Tea Post",
    price: 20.0,
    imgUrl: "assets/cofee.jpg",
  ),
]);

class FooditemList {
  List<FoodItem> foodItems;

  FooditemList({@required this.foodItems});
}

class FoodItem {
  int id;
  String title;
  String hotel;
  double price;
  String imgUrl;
  int quantity;

  FoodItem({
    @required this.id,
    @required this.title,
    @required this.hotel,
    @required this.price,
    @required this.imgUrl,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}
