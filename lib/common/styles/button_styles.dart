import 'package:flutter/material.dart';

final class ButtonStyles {
    ButtonStyles._();

    static final ButtonStyle letterButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(4),
        textStyle: const TextStyle(fontSize: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),            
        ),        
    );

    static final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade900,
        padding: const EdgeInsets.all(4),
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),            
        ),        
    );
}