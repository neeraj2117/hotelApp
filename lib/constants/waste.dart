// Stack(
//                               children: [
//                                 Container(
//                                   height: 310,
//                                   width: 330,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.white,
//                                     image: const DecorationImage(
//                                       image: AssetImage(
//                                         'lib/assets/hotels/3.png',
//                                       ),
//                                       alignment: Alignment.topCenter,
//                                     ),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                       top: 235.0,
//                                       left: 15,
//                                       right: 15,
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         // hotel name and ratings
//                                         const Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               'Tiny home in Bandra',
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.star,
//                                                   size: 19,
//                                                   color: Colors.red,
//                                                 ),
//                                                 Text('4.96 (217)'),
//                                               ],
//                                             )
//                                           ],
//                                         ),

//                                         const SizedBox(
//                                           height: 3,
//                                         ),

//                                         // amenities
//                                         Row(
//                                           children: [
//                                             Text(
//                                               '4 guests • 2 bedrooms • 2 beds • 1 bathroom',
//                                               style: TextStyle(
//                                                 fontSize: 13,
//                                                 color: Colors.grey[600]!,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),

//                                         // prices
//                                         Row(
//                                           children: [
//                                             Text(
//                                               '€117',
//                                               style: TextStyle(
//                                                 decoration:
//                                                     TextDecoration.lineThrough,
//                                                 fontSize: 13,
//                                                 color: Colors.grey[600]!,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 5,
//                                             ),
//                                             const Text(
//                                               '€91 night',
//                                               style: TextStyle(
//                                                 fontSize: 13,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 5,
//                                             ),
//                                             const Text(
//                                               '€273 total',
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.blue,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),

//                                 // favorate icon
//                                 Positioned(
//                                   right: 10,
//                                   top: 10,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: Colors.blue[400],
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(4.0),
//                                       child: Image.asset(
//                                         'lib/assets/heart1.png',
//                                         height: 30,
//                                         width: 30,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),



// new homes
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     // First
                    //     Padding(
                    //       padding:
                    //           const EdgeInsets.only(left: 20.0, right: 20.0),
                    //       child: Container(
                    //         width: 388.3,
                    //         decoration: const BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10)),
                    //           color: Colors.white,
                    //         ),
                    //         child: Padding(
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 0.0),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Container(
                    //                 height: 175,
                    //                 width: 162,
                    //                 decoration: const BoxDecoration(
                    //                   borderRadius: BorderRadius.all(
                    //                     Radius.circular(12),
                    //                   ),
                    //                   image: DecorationImage(
                    //                     image: AssetImage(
                    //                         'lib/assets/hotels/6.png'),
                    //                     fit: BoxFit.cover,
                    //                     alignment: Alignment.topLeft,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 8.0),
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     const SizedBox(
                    //                       height: 15,
                    //                     ),

                    //                     // hotel name
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                           width: 170,
                    //                           child: const Text(
                    //                             'Crystal Cove Hotel',
                    //                             style: TextStyle(
                    //                               fontSize: 17,
                    //                               color: Colors.black,
                    //                               fontWeight: FontWeight.w800,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     const SizedBox(
                    //                       height: 10,
                    //                     ),
                    //                     // address
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                           width: 170,
                    //                           child: Text(
                    //                             '3746 N Mississippi Ave, Portland, Oregon.',
                    //                             style: TextStyle(
                    //                               fontSize: 14,
                    //                               color: Colors.grey[600]!,
                    //                               fontWeight: FontWeight.w500,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     const SizedBox(
                    //                       height: 33,
                    //                     ),
                    //                     // price and button
                    //                     Row(
                    //                       children: [
                    //                         Column(
                    //                           children: [
                    //                             const Text(
                    //                               '\$15/Night',
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 color: Colors.green,
                    //                                 fontWeight: FontWeight.w800,
                    //                               ),
                    //                             ),
                    //                             Text(
                    //                               '\$19/Night',
                    //                               style: TextStyle(
                    //                                 decoration: TextDecoration
                    //                                     .lineThrough,
                    //                                 fontSize: 13,
                    //                                 color: Colors.grey[500]!,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(width: 16),
                    //                         Container(
                    //                           width: 83,
                    //                           height: 35,
                    //                           child: ElevatedButton(
                    //                             style: ElevatedButton.styleFrom(
                    //                               backgroundColor: Colors.blue,
                    //                             ),
                    //                             onPressed: () {},
                    //                             child: Text(
                    //                               'Book',
                    //                               style: CustomFonts
                    //                                   .secondaryTextStyle(
                    //                                 color: Colors.white,
                    //                                 fontSize: 13,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),

                    //     const SizedBox(
                    //       height: 15,
                    //     ),

                    //     // second
                    //     Padding(
                    //       padding:
                    //           const EdgeInsets.only(left: 20.0, right: 20.0),
                    //       child: Container(
                    //         width: 388.3,
                    //         decoration: const BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10)),
                    //           color: Colors.white,
                    //         ),
                    //         child: Padding(
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 0.0),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Container(
                    //                 height: 175,
                    //                 width: 162,
                    //                 decoration: const BoxDecoration(
                    //                   borderRadius: BorderRadius.all(
                    //                     Radius.circular(12),
                    //                   ),
                    //                   image: DecorationImage(
                    //                     image: AssetImage(
                    //                         'lib/assets/hotels/7.png'),
                    //                     fit: BoxFit.cover,
                    //                     alignment: Alignment.topLeft,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 8.0),
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     const SizedBox(
                    //                       height: 10,
                    //                     ),

                    //                     // hotel name
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                           width: 170,
                    //                           child: const Text(
                    //                             'Serenity Springs Hotel',
                    //                             style: TextStyle(
                    //                               fontSize: 17,
                    //                               color: Colors.black,
                    //                               fontWeight: FontWeight.w800,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     const SizedBox(
                    //                       height: 5,
                    //                     ),
                    //                     // address
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                           width: 170,
                    //                           child: Text(
                    //                             '3746 N Mississippi Ave, Portland, Oregon.',
                    //                             style: TextStyle(
                    //                               fontSize: 14,
                    //                               color: Colors.grey[600]!,
                    //                               fontWeight: FontWeight.w500,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     const SizedBox(
                    //                       height: 25,
                    //                     ),
                    //                     // price and button
                    //                     Row(
                    //                       children: [
                    //                         Column(
                    //                           children: [
                    //                             const Text(
                    //                               '\$15/Night',
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 color: Colors.green,
                    //                                 fontWeight: FontWeight.w800,
                    //                               ),
                    //                             ),
                    //                             Text(
                    //                               '\$19/Night',
                    //                               style: TextStyle(
                    //                                 decoration: TextDecoration
                    //                                     .lineThrough,
                    //                                 fontSize: 13,
                    //                                 color: Colors.grey[500]!,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(width: 16),
                    //                         Container(
                    //                           width: 83,
                    //                           height: 35,
                    //                           child: ElevatedButton(
                    //                             style: ElevatedButton.styleFrom(
                    //                               backgroundColor: Colors.blue,
                    //                             ),
                    //                             onPressed: () {},
                    //                             child: Text(
                    //                               'Book',
                    //                               style: CustomFonts
                    //                                   .secondaryTextStyle(
                    //                                 color: Colors.white,
                    //                                 fontSize: 13,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),

                    //     const SizedBox(
                    //       height: 20,
                    //     )
                    //   ],
                    // )
                  
                  // hotels - images

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         // first
                    //         Container(
                    //           child: Column(
                    //             children: [
                    //               // hotel image and fav icon
                    //               Stack(
                    //                 children: [
                    //                   // image
                    //                   Container(
                    //                     height: 225,
                    //                     width: 330,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: const BorderRadius.only(
                    //                         topLeft: Radius.circular(25),
                    //                         topRight: Radius.circular(25),
                    //                       ),
                    //                       image: _getImageDecoration(),
                    //                     ),
                    //                   ),

                    //                   // Favorite icon
                    //                   Positioned(
                    //                     top: 10,
                    //                     right: 10,
                    //                     child: Container(
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(20),
                    //                         color: Colors.blue[400],
                    //                       ),
                    //                       child: Padding(
                    //                         padding: const EdgeInsets.all(4.0),
                    //                         child: Image.asset(
                    //                           'lib/assets/heart1.png',
                    //                           height: 30,
                    //                           width: 30,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),

                    //               // hotel data
                    //               Container(
                    //                 decoration: const BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.only(
                    //                     bottomLeft: Radius.circular(20),
                    //                     bottomRight: Radius.circular(20),
                    //                   ),
                    //                 ),
                    //                 width: 330,
                    //                 child: Column(
                    //                   children: [
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                         top: 13,
                    //                         left: 15,
                    //                         right: 10,
                    //                         bottom: 10,
                    //                       ),
                    //                       child: Column(
                    //                         children: [
                    //                           // hotel name and ratings
                    //                           Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment
                    //                                     .spaceBetween,
                    //                             children: [
                    //                               Text(
                    //                                 titleController ?? '',
                    //                                 style: const TextStyle(
                    //                                   fontSize: 15,
                    //                                   color: Colors.black,
                    //                                   fontWeight:
                    //                                       FontWeight.w700,
                    //                                 ),
                    //                               ),
                    //                               const Row(
                    //                                 children: [
                    //                                   Icon(
                    //                                     Icons.star,
                    //                                     size: 19,
                    //                                     color: Colors.red,
                    //                                   ),
                    //                                   Text('4.96 (217)'),
                    //                                 ],
                    //                               )
                    //                             ],
                    //                           ),

                    //                           const SizedBox(
                    //                             height: 3,
                    //                           ),

                    //                           // amenities
                    //                           Row(
                    //                             children: [
                    //                               Text(
                    //                                 '4 guests • $selectedBedController bedrooms • $selectedBathController bathroom',
                    //                                 style: TextStyle(
                    //                                   fontSize: 13,
                    //                                   color: Colors.grey[600]!,
                    //                                   fontWeight:
                    //                                       FontWeight.w500,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),

                    //                           // prices
                    //                           Row(
                    //                             children: [
                    //                               Text(
                    //                                 '€117',
                    //                                 style: TextStyle(
                    //                                   decoration: TextDecoration
                    //                                       .lineThrough,
                    //                                   fontSize: 13,
                    //                                   color: Colors.grey[600]!,
                    //                                 ),
                    //                               ),
                    //                               const SizedBox(
                    //                                 width: 5,
                    //                               ),
                    //                               Text(
                    //                                 '€$priceController night',
                    //                                 style: const TextStyle(
                    //                                   fontSize: 13,
                    //                                   color: Colors.black,
                    //                                 ),
                    //                               ),
                    //                               const SizedBox(
                    //                                 width: 5,
                    //                               ),
                    //                               const Text(
                    //                                 '€273 total',
                    //                                 style: TextStyle(
                    //                                   fontSize: 14,
                    //                                   color: Colors.blue,
                    //                                   fontWeight:
                    //                                       FontWeight.w500,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           )
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),

                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
