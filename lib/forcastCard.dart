import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForcastCard extends StatelessWidget {
  final String temperature;
  final IconData icon;
  final String time;
  // constructor
  const ForcastCard({
    super.key,
    required this.temperature,
    required this.icon,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 2,
              ),
              Text(
                temperature,
                style: GoogleFonts.raleway(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 2,
              ),
              Icon(
                icon,
                size: 34,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
