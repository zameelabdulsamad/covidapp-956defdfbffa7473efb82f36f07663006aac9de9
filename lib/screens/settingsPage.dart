import 'package:flutter/material.dart';

import '../constants.dart';
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(children: [
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:()=> null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:primaryRed,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.share,
                                          color: Colors.white,),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Share CovidPoint',style: TextStyle(
                                            color: Colors.white,fontWeight: FontWeight.bold
                                        ),
                                        ),

                                      ],
                                    ),

                                  ],

                                ),
                                Column(
                                  children: [
                                    Icon(Icons.arrow_forward_ios,
                                      color: Colors.white,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:()=> null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:primaryRed,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star_border,
                                          color: Colors.white,),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Rate this app',style: TextStyle(
                                            color: Colors.white,fontWeight: FontWeight.bold
                                        ),
                                        ),

                                      ],
                                    ),

                                  ],

                                ),
                                Column(
                                  children: [
                                    Icon(Icons.arrow_forward_ios,
                                      color: Colors.white,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:()=> null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:primaryRed,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.feedback_outlined,
                                          color: Colors.white,),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Feedback',style: TextStyle(
                                            color: Colors.white,fontWeight: FontWeight.bold
                                        ),
                                        ),

                                      ],
                                    ),

                                  ],

                                ),
                                Column(
                                  children: [
                                    Icon(Icons.arrow_forward_ios,
                                      color: Colors.white,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:()=> null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:primaryRed,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                          color: Colors.white,),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'About',style: TextStyle(
                                            color: Colors.white,fontWeight: FontWeight.bold
                                        ),
                                        ),

                                      ],
                                    ),

                                  ],

                                ),
                                Column(
                                  children: [
                                    Icon(Icons.arrow_forward_ios,
                                      color: Colors.white,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),


              ),
            ],

            ),
          ],
        ),
      ),
    );
  }
}