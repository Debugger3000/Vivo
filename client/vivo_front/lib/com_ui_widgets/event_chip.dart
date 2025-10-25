
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // or your preferred icon set



// display chips for : Categories | Tags
//  
class EventChip extends StatelessWidget {
  final String label;
  final bool isCategory;
  final Color? color;

  const EventChip({
    super.key,
    required this.label,
    this.isCategory = true,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon(label);
    final color = _getColor(label);
    
    if(isCategory){
      return Chip(
      avatar: icon != null ? Icon(icon, size: 18, color: Colors.white) : null,
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );

    }
    else{
      return Chip(
      avatar: icon != null ? Icon(icon, size: 18, color: Colors.white) : null,
      label: Text(label),
      );
    }

    
  }

  // 🎨 Choose an icon based on label
  IconData? _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'entertainment':
        return LucideIcons.tv;
      case 'sports':
        return LucideIcons.dumbbell;
      case 'food':
        return LucideIcons.utensils;
      case 'gaming':
        return LucideIcons.gamepad2;
      case 'alcohol':
        return LucideIcons.beer;
      default:
        return null;
    }
  }

  // 🌈 Optional: color per category
  Color? _getColor(String name) {
    switch (name.toLowerCase()) {
      case 'entertainment':
        return Colors.purpleAccent;
      case 'sports':
        return Colors.green;
      case 'food':
        return Colors.orange;
      case 'gaming':
        return Colors.blue;
      case 'alcohol':
        return Colors.redAccent;
      default:
        return null;
    }
  }
}
