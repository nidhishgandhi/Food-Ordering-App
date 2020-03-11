import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/bloc/listTileColorBloc.dart';
import 'bloc/cartlistBloc.dart';
import 'cart.dart';
import 'model/food_item.dart';
import 'package:permission/permission.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:gradient_text/gradient_text.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        //add yours BLoCs controlles
        Bloc((i) => CartListBloc()),
        Bloc((i) => ColorBloc()),
      ],
      child: MaterialApp(
        title: "Food Delivery",
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Home extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hi'),
      ),
      body: SafeArea(
          child: Container(
        child: ListView(
          children: <Widget>[
            FirstHalf(),
            SizedBox(height: 45),
            for (var foodItem in fooditemList.foodItems)
              Builder(
                builder: (context) {
                  return ItemContainer(foodItem: foodItem);
                },
              )
          ],
        ),
      )),
    );
  }
}

class ItemContainer extends StatelessWidget {
  
  ItemContainer({
    @required this.foodItem,
  });

  final FoodItem foodItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  
  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(FoodItem foodItem) {
    bloc.removeFromList(foodItem);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToCart(foodItem);
        final snackBar = SnackBar(
          content: Text('${foodItem.title} added to Cart'),
          duration: Duration(milliseconds: 550),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Items(
        hotel: foodItem.hotel,
        itemName: foodItem.title,
        itemPrice: foodItem.price,
        imgUrl: foodItem.imgUrl,
        leftAligned: (foodItem.id % 2) == 0 ? true : false,
      ),
    );
  }
}

class FirstHalf extends StatelessWidget {
  const FirstHalf({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          //you could also use the spacer widget to give uneven distances, i just decided to go with a sizebox
         // SizedBox(height: 30),
          title(),
          SizedBox(height: 30),
          CategoryListItem6(),
          SizedBox(height: 25),
          heading(),
          SizedBox(height: 15),
          categories(),
        ],
      ),
    );
  }
}

Widget categories() {
  return Container(
    height: 95,
       child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryListItem1(
           
          ),
          CategoryListItem2(
         
          ),
          CategoryListItem3(
           
          ),
          CategoryListItem4(
          
          ),
          CategoryListItem5(
          
          ),
          
        ],
      ),
    );
  }


class Items extends StatelessWidget {
  Items({
    @required this.leftAligned,
    @required this.imgUrl,
    @required this.itemName,
    @required this.itemPrice,
    @required this.hotel,
  });

  final bool leftAligned;
  final String imgUrl;
  final String itemName;
  final double itemPrice;
  final String hotel;

  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadius = 10;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding,
            right: leftAligned ? containerPadding : 0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: leftAligned
                        ? Radius.circular(0)
                        : Radius.circular(containerBorderRadius),
                    right: leftAligned
                        ? Radius.circular(containerBorderRadius)
                        : Radius.circular(0),
                  ),
                  child: Image.asset(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.only(
                    left: leftAligned ? 20 : 0,
                    right: leftAligned ? 0 : 20,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  )),
                            ),
                            Text("\₹$itemPrice",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                                children: [
                                  TextSpan(text: "by "),
                                  TextSpan(
                                      text: hotel,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700))
                                ]),
                          ),
                        ),
                        SizedBox(height: containerPadding),
                      ])),
            ],
          ),
        )
      ],
    );
  }
}

class CategoryListItem1 extends StatelessWidget {
  /*const CategoryListItem({
    Key key,
    //@required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.imagepath,
    //@required this.selected,
  }) : super(key: key);

 // final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final String imagepath;
  //final bool selected;
*/
  @override
 Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.only(right: 20.0),
    
    child:  Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: <Widget>[
            Image(
               image: AssetImage('assets/burger.jpg'),
               height: 65.0,
               width: 65.0,
              ), 
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Burgers", style: TextStyle(fontWeight: FontWeight.bold) ,
                  ),
                  Text("44 Kinds",) 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryListItem2 extends StatelessWidget {
  /*const CategoryListItem({
    Key key,
    //@required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.imagepath,
    //@required this.selected,
  }) : super(key: key);

 // final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final String imagepath;
  //final bool selected;
*/
  @override
 Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.only(right: 20.0),
    
    child:  Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: <Widget>[
            Image(
               image: AssetImage('assets/cofee.jpg'),
               height: 65.0,
               width: 65.0,
              ), 
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Coffee", style: TextStyle(fontWeight: FontWeight.bold) ,
                  ),
                  Text("20 Kinds",) 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryListItem3 extends StatelessWidget {
  /*const CategoryListItem({
    Key key,
    //@required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.imagepath,
    //@required this.selected,
  }) : super(key: key);

 // final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final String imagepath;
  //final bool selected;
*/
  @override
 Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.only(right: 20.0),
    
    child:  Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: <Widget>[
            Image(
               image: AssetImage('assets/cupcake.jpg'),
               height: 65.0,
               width: 65.0,
              ), 
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Cupcakes", style: TextStyle(fontWeight: FontWeight.bold) ,
                  ),
                  Text("15 Kinds",) 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryListItem4 extends StatelessWidget {
  /*const CategoryListItem({
    Key key,
    //@required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.imagepath,
    //@required this.selected,
  }) : super(key: key);

 // final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final String imagepath;
  //final bool selected;
*/
  @override
 Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.only(right: 20.0),
    
    child:  Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: <Widget>[
            Image(
               image: AssetImage('assets/pizza.jpg'),
               height: 65.0,
               width: 65.0,
              ), 
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Pizza", style: TextStyle(fontWeight: FontWeight.bold) ,
                  ),
                  Text("35 Kinds",) 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryListItem5 extends StatelessWidget {
  /*const CategoryListItem({
    Key key,
    //@required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.imagepath,
    //@required this.selected,
  }) : super(key: key);

 // final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final String imagepath;
  //final bool selected;
*/
  @override
 Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.only(right: 20.0),
    
    child:  Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: <Widget>[
            Image(
               image: AssetImage('assets/breakfast.jpg'),
               height: 65.0,
               width: 65.0,
              ), 
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Breakfast", style: TextStyle(fontWeight: FontWeight.bold) ,
                  ),
                  Text("22 Kinds",) 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CategoryListItem6 extends StatelessWidget {
  /*const CategoryListItem({
    Key key,
    //@required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.imagepath,
    //@required this.selected,
  }) : super(key: key);

 // final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final String imagepath;
  //final bool selected;
*/
    _openURL1(){
      launch("https://app.engati.com/static/standalone/bot.html?bot_key=750f25a525ca4362&debug=true");
      } 
  @override
 Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.only(left: 35, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
              color: Colors.teal,
              child: Text('Chat with us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
              ),),onPressed: _openURL1,
            ),
        ],
      ),
    );
  }
}
/*Widget searchBar() {
    return Container(
      child: Column(
         children: <Widget>[
            RaisedButton(
              color: Colors.teal,
              child: Text('Get Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
              ),),onPressed: _openURL,
            ),
          ],
      ),
       
    );
  }
*/


Widget title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(width: 45),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "What Would You",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
          Text(
            "Like To Eat ?",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ],
      )
    ],
  );
}

Widget heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           Text(
            "Good Food..Good Feelings !!",
            style: TextStyle(
              fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent
            ),
          ),
          SizedBox(width: 10),
          Image(
            image: AssetImage('assets/icon2.JPG'),
            height: 30,
            
          )
          ],
      )
    ],
  );
}


class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Icon(Icons.menu),
          Image(
            image: AssetImage('assets/LOGO1.PNG'),
            height: 110,
          ),
          StreamBuilder(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<FoodItem> foodItems = snapshot.data;
              int length = foodItems != null ? foodItems.length : 0;

              return buildGestureDetector(length, context, foodItems);
            },
          )
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int length, BuildContext context, List<FoodItem> foodItems) {
    return GestureDetector(
      onTap: () {
        if (length > 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Cart()));
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 30),
        child: Text(length.toString()),
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Colors.yellow[800], borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}