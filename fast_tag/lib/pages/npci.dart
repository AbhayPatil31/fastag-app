import 'package:flutter/material.dart';

class NPCIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'NPCI',
          style: TextStyle(
            fontSize: 20, // 25px size
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), 
            
            Padding(
              
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                
                children: [
                  Expanded(
                    
                    child: Card(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      elevation: 0.7, // Adding shadow to the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Padding(
                        
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle No : WB44J8800',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                               color: Color.fromRGBO(66, 71, 82, 1),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tag ID        : 34161FA820328EE82FAB050',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(66, 71, 82, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Adding space between cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      elevation: 0.7, // Adding shadow to the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle No : SB44J8999',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(66, 71, 82, 1),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tag ID        : 78161FA820328EE82FAB070',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(66, 71, 82, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Adding space before the button
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NPCIPage(),
  ));
}
