import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TopNavbar extends StatefulWidget {
  const TopNavbar({super.key});

  @override
  State<TopNavbar> createState() => _TopNavbarState();
}

class _TopNavbarState extends State<TopNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: const Color.fromARGB(255, 7, 106, 255),
      ),

      child: Padding(
        padding: const EdgeInsets.only(
          top: 70,
          bottom: 50,
          left: 20,
          right: 20,
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to ToDoo !",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(221, 255, 255, 255),
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  DateFormat('MMMM d, yyyy').format(DateTime.now()).toString(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(233, 244, 244, 244),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
