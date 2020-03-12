import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bloc/cartlistBloc.dart';
import 'bloc/listTileColorBloc.dart';
import 'model/food_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';


    double totalAmount = 0.0;
  int noOfPersons = 2;


class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    List<FoodItem> foodItems;
    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          foodItems = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: CartBody(foodItems),
            ),
            bottomNavigationBar: BottomBar(foodItems),
          );
        } else {
          return Container(
            child: Text("Something returned null"),
          );
        }
      },
    );
  }
}

class BottomBar extends StatelessWidget {
  final List<FoodItem> foodItems;
    int noOfPersons ;
     double totalAmounta = 0.0;


  BottomBar(this.foodItems);
  _openURL(){
    launch("https://www.google.com/maps/@22.5993532,72.8179224,17z");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
             gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.1],
      colors: [Colors.grey[50]])
  ),
      margin: EdgeInsets.only(left: 0, bottom: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          totalAmount(foodItems),
          Divider(
            height: 0,
            color: Colors.grey[700],
          ),
          persons(),
          
          Container(
            margin: EdgeInsets.only(left: 140, bottom: 10),
            child: Row(
              children: <Widget>[
                RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                      child: Text(
                        'Get Location',
                        style: TextStyle(
                  fontSize: 16.0,
                ),
                      ),
                      onPressed: _openURL,
                    color: Colors.red,
                      textColor: Colors.white,
                  ),
                  SizedBox(height:1,),
                  new Icon(
                  Icons.add_location,
                  size: 50,
          ),
              ],
            ),
          ),
          
         
        ],
      ),
    );
  }

  Container persons() {
    return Container(
      
      margin: EdgeInsets.only(left:20,right: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Coke",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),),
          Text(" 20/- ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),),    
          CustomPersonWidget(totalAmounta),
        ],
      ),
    );
  }

  Container totalAmount(List<FoodItem> foodItems) {
    
    return Container(
      
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Total:",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300,color: Colors.black),
          ),
          Text(
            "\₹${returnTotalAmount(foodItems)}",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          ),
        ],
      ),
    );
  }

  String returnTotalAmount(List<FoodItem> foodItems) {
   
    
    for (int i = 0; i < foodItems.length; i++) {
      totalAmounta = totalAmounta + foodItems[i].price * foodItems[i].quantity;
    }
    return  totalAmounta.toStringAsFixed(2);
  }

  
}

class CustomPersonWidget extends StatefulWidget {
    double totalAmounta = 0.0;
    


  CustomPersonWidget(this.totalAmounta);
  @override
  _CustomPersonWidgetState createState() => _CustomPersonWidgetState();
}

class _CustomPersonWidgetState extends State<CustomPersonWidget> {
  int noOfPersons = 0;
  
  double _buttonWidth = 30;
  
  Razorpay _razorpay;
  
  @override
  void initState() {
    super.initState();
    _razorpay =Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async{
    var options= {
      'key': 'rzp_test_1rDTMhJtCsMAPe',
      'amount' :(widget.totalAmounta+noOfPersons*20)*100,
      'name': 'Nidman',
      'description': 'Test Payment',
      'prefill': {'contact' : '','email':''},
      'external' :{
        'wallets' : ['paytm']
      }
    };
  

   try {
   _razorpay.open(options); 
   }
    catch (e) {
     debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "Success:"+ response.paymentId);
  }
  void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "ERROR:"+ response.code.toString() + "." + response.message);
  }
  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "External WALLET:"+ response.walletName);
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: EdgeInsets.only(right: 20),
      /*decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 2),
        borderRadius: BorderRadius.circular(10),
      ),*/
      padding: EdgeInsets.symmetric(vertical: 3),
      width: 210,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
         mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  if (noOfPersons > 0) {
                     noOfPersons=noOfPersons-1;
                  }
                });
              },
              
              child: Text(
                "-",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              ),
            ),
          
          SizedBox(
            width: 20,
           // height: _buttonWidth,
            child:Text(
              
                noOfPersons.toString(),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.red,),
            ),),
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child:Align(
            alignment: Alignment(6,0),
            child: FlatButton(
            padding: EdgeInsets.all(0),
            color: Colors.red,
            onPressed: () {
              setState(() {
                noOfPersons=noOfPersons+1;
              });
            },
              
              child: Text(
                "+",
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            ),
          ),
           SizedBox(
             //height: 35,
              child:Align(
              alignment: Alignment.bottomLeft,
             child:RaisedButton(
               
              shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
              
              child: Text('Pay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
              ),),onPressed: (){
                openCheckout();
              },
              color: Colors.red,
            textColor: Colors.white,
          ),),),
          SizedBox(height:0,)
        ],
      ),
    );
    
  }
}


class CartBody extends StatelessWidget {
  final List<FoodItem> foodItems;

  CartBody(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
             gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.1],
      colors: [Colors.grey[50]])
  ),
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          title(),
          Expanded(
            flex: 1,
            child: foodItems.length > 0 ? foodItemList() : noItemContainer(),
          )
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text(
          "No More Items Left In The Cart",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 20),
        ),
      ),
    );
  }

  ListView foodItemList() {
    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return CartListItem(foodItem: foodItems[index]);
      },
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "My",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
              Text(
                "Order",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  final FoodItem foodItem;

  CartListItem({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      hapticFeedbackOnStart: false,      
      maxSimultaneousDrags: 1,
      data: foodItem,
      feedback: DraggableChildFeedback(foodItem: foodItem),
      child: DraggableChild(foodItem: foodItem),
      childWhenDragging: foodItem.quantity > 1 ? DraggableChild(foodItem: foodItem) : Container(),
      
    );
  }
}

class DraggableChild extends StatelessWidget {
  const DraggableChild({
    Key key,
    @required this.foodItem,
  }) : super(key: key);

  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(
        foodItem: foodItem,

      ),
    );
  }
}

class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    Key key,
    @required this.foodItem,
  }) : super(key: key);

  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return Opacity(
      opacity: 0.7,
      child: Material(
        child: StreamBuilder(
          stream: colorBloc.colorStream,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: snapshot.data != null ? snapshot.data : Colors.white,
              ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.95,
              child: ItemContent(foodItem: foodItem),
            );
          },
        ),
      ),
    );
  }
}

class ItemContent extends StatelessWidget {
  const ItemContent({
    Key key,
    @required this.foodItem,
  }) : super(key: key);

  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          
          Container(
            decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15),border: new Border.all(
          color: Colors.red,
          width: 3.5,

        ), ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                
                foodItem.imgUrl,
                fit: BoxFit.fitHeight,
                height: 55,
                width: 70,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: foodItem.quantity.toString()
                    ),
                  TextSpan(text: " x "),
                  TextSpan(
                    text: foodItem.title,
                  ),
                ]),
          ),
          Text(
            "\₹${foodItem.quantity * foodItem.price}",
            style:
                TextStyle(color: Colors.pink[500], fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        DragTargetWidget(bloc),
      ],
    );
  }
}

class DragTargetWidget extends StatefulWidget {
  final CartListBloc bloc;

  DragTargetWidget(this.bloc);

  @override
  _DragTargetWidgetState createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {
  @override
  Widget build(BuildContext context) {
    FoodItem currentFoodItem;
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return DragTarget<FoodItem>(
      onAccept: (FoodItem foodItem) {
        currentFoodItem = foodItem;
        colorBloc.setColor(Colors.white);
        widget.bloc.removeFromList(currentFoodItem);
      },
      onWillAccept: (FoodItem foodItem) {
        colorBloc.setColor(Colors.red);
        return true;
      },
      onLeave: ( foodItem) {
        colorBloc.setColor(Colors.white);
        
      },
      
      builder: (BuildContext context, List incoming, List rejected) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            CupertinoIcons.delete,
            size: 35,
          ),
        );
      },
    );
  }
}


