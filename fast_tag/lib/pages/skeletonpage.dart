import 'package:fast_tag/utility/colorfile.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: colorfile().shadowcolor,
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  blurStyle: BlurStyle.normal,
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          //  period: Duration(seconds: 10),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SizedBox(
                            width: 30,
                            height: 15,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SizedBox(
                            width: 100,
                            height: 10,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SizedBox(
                        width: 100,
                        height: 10,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SizedBox(
                    width: 200,
                    height: 10,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Shimmer.fromColors(
                //       baseColor: Colors.grey[300]!,
                //       highlightColor: Colors.grey[100]!,
                //       child: SizedBox(
                //         width: 100,
                //         height: 10,
                //         child: Container(
                //           padding: EdgeInsets.all(8),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(4),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.2),
                //                 spreadRadius: 0,
                //                 blurRadius: 0,
                //                 offset: Offset(0, 0),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Shimmer.fromColors(
                //       baseColor: Colors.grey[300]!,
                //       highlightColor: Colors.grey[100]!,
                //       child: SizedBox(
                //         width: 100,
                //         height: 10,
                //         child: Container(
                //           padding: EdgeInsets.all(8),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(4),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.2),
                //                 spreadRadius: 0,
                //                 blurRadius: 0,
                //                 offset: Offset(0, 0),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Shimmer.fromColors(
                //       baseColor: Colors.grey[300]!,
                //       highlightColor: Colors.grey[100]!,
                //       child: SizedBox(
                //         width: 100,
                //         height: 10,
                //         child: Container(
                //           padding: EdgeInsets.all(8),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(4),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.2),
                //                 spreadRadius: 0,
                //                 blurRadius: 0,
                //                 offset: Offset(0, 0),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Shimmer.fromColors(
                //       baseColor: Colors.grey[300]!,
                //       highlightColor: Colors.grey[100]!,
                //       child: SizedBox(
                //         width: 150,
                //         height: 10,
                //         child: Container(
                //           padding: EdgeInsets.all(8),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(4),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.2),
                //                 spreadRadius: 0,
                //                 blurRadius: 0,
                //                 offset: Offset(0, 0),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
