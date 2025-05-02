import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Colors.white])),
      child: Stack(
        children: [
          Opacity(
            // opacity: 0.4,
            opacity: 0.4,
            child: Image.asset(
              'assets/images/background.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.format_list_bulleted),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    // height: 20,
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter text',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.cancel),
                        fillColor: Colors.white,
                        filled: true,
                        focusColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.notifications)),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.message)),
                ],
              ))
        ],
      ),
    );
  }
}
