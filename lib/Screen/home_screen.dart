
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          padding: EdgeInsets.all(75),
          child:
          Text("parametres"),
        ),
      ),
      body:
      Stack(
        children: [

          Container(
            height: 200,
            width: 450,
            color: Colors.blue,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJjNEn2h_zo3WX-VpJZuelh1FyDibfAkhXiA&s"),


                ),
                SizedBox(height: 10,),
                Text("ass pro"),
              ],
            ),


          ),

Container(
  height: 800,
  width: 450,
  margin: EdgeInsets.only(top: 200),
  color: Colors.white,
  child: Stack(
    children: [
      Container(
        child: Text("Mon compte",style: TextStyle(color: Colors.blue),),
        margin: EdgeInsets.all(20),
       

      ),

      Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 50, 10, 50),

              child: Stack(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                        padding: EdgeInsets.only(right: 30),
                        child:  Icon(Icons.person,color: Colors.black,),
                      ),


                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Mes information",style: TextStyle(color: Colors.black),),
                      ),


                      Container(
                        padding: EdgeInsets.only(left: 170),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                      )

                    ],
                  )



                ],
              )


            ),

        Container(
          margin: EdgeInsets.fromLTRB(20, 100, 10, 50),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                padding: EdgeInsets.only(right: 30),
                child:  Icon(Icons.lock,color: Colors.black,),
              ),


              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text("changer code pin",style: TextStyle(color: Colors.black),),
              ),


              Container(
                padding: EdgeInsets.only(left: 160),
                child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
              )


            ],
          )

        ),



            Container(
                margin: EdgeInsets.fromLTRB(20, 150, 10, 50),
                child:   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Container(
                      padding: EdgeInsets.only(right: 30),
                      child:  Icon(Icons.shield,color: Colors.black,),
                    ),


                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("A propos",style: TextStyle(color: Colors.black),),
                    ),


                    Container(
                      padding: EdgeInsets.only(left: 210),
                      child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                    )


                  ],
                )

            ),


            Container(
                margin: EdgeInsets.fromLTRB(20, 200, 10, 50),
                child:   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Container(
                      padding: EdgeInsets.only(right: 30),
                      child:  Icon(Icons.settings,color: Colors.black,),
                    ),


                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Confidentialite",style: TextStyle(color: Colors.black),),
                    ),


                    Container(
                      padding: EdgeInsets.only(left: 170),
                      child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                    ),


                  ],
                )

            ),

            Container(
              margin: EdgeInsets.fromLTRB(180, 250, 10, 100),
              height: 50,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),

              child: TextButton(onPressed: (){},
              child: Text("valider mon identite",style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),)
                ,)
            )

          ],
        )
      ),


      Container(
        child: Text("kondaane",style: TextStyle(color: Colors.blue),),
        margin: EdgeInsets.fromLTRB(20, 350, 30, 100),


      ),

      Container(
          margin: EdgeInsets.fromLTRB(20, 390, 10, 50),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                padding: EdgeInsets.only(right: 30),
                child:  Icon(Icons.notifications,color: Colors.black,),
              ),


              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text("Notifications",style: TextStyle(color: Colors.black),),
              ),


              Container(
                padding: EdgeInsets.only(left: 210),
                child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
              )


            ],
          )

      ),


      Container(
          margin: EdgeInsets.fromLTRB(20, 435, 30, 50),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                padding: EdgeInsets.only(right: 60),
                child:  Icon(Icons.shield,color: Colors.black,),
              ),


              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text("wave",style: TextStyle(color: Colors.black),),
              ),


              Container(
                padding: EdgeInsets.only(left: 210),
                child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
              )


            ],
          )

      ),


      Container(
          margin: EdgeInsets.fromLTRB(20, 480, 10, 50),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                padding: EdgeInsets.only(right: 30),
                child:  Icon(Icons.settings,color: Colors.black,),
              ),


              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text("orange money",style: TextStyle(color: Colors.black),),
              ),


              Container(
                padding: EdgeInsets.only(left: 170),
                child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
              ),


            ],
          )

      ),


    ],
  ),
)


        ],



      ),


    );
  }
}
