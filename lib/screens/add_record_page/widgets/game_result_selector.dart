import 'package:flutter/material.dart';

class Option {
  final String name;
  final String value;

  Option({required this.name, required this.value});
}

class GameResultSelector extends StatelessWidget {
  final String gameResultType;
  final Function(String) onGameResultTypeChanged;
  final List<Option> options = [
    Option(name: '双扣', value: 'DOUBLE_WIN'),
    Option(name: '单扣', value: 'SINGLE_WIN'),
    Option(name: '平扣', value: 'DRAW'),
    Option(name: '流局', value: 'STALEMATE'),
  ];

  GameResultSelector({
    super.key,
    required this.gameResultType,
    required this.onGameResultTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            options.map((option) {
              final isSelected = option.value == gameResultType;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Colors.purple : Colors.grey.shade100,
                      foregroundColor:
                          isSelected ? Colors.white : Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => onGameResultTypeChanged(option.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
