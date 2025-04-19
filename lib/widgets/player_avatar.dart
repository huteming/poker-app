import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool isWinner;
  final int selectedIndex;

  const PlayerAvatar({
    Key? key,
    required this.name,
    this.isSelected = false,
    this.isWinner = false,
    this.selectedIndex = 0,
  }) : super(key: key);

  Color _getBackgroundColor() {
    if (!isSelected) return Colors.grey.shade200;
    switch (name) {
      case '钱':
        return Colors.amber;
      case '孙':
        return Colors.pink;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: _getBackgroundColor(),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isWinner ? Colors.green : Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  selectedIndex.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
