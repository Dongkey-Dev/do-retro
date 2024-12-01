import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/category_data.dart';

class CategoryMenu extends StatelessWidget {
  final VoidCallback onDismiss;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final Function(String, String)? onSubItemSelected;

  const CategoryMenu({
    super.key,
    required this.onDismiss,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onSubItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryWheel(),
              if (selectedCategory != null) ...[
                const SizedBox(height: 32),
                _buildSubItems(context, selectedCategory!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryWheel() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(150),
      ),
      child: Stack(
        children: CategoryData.categories.entries.map((entry) {
          final index =
              CategoryData.categories.keys.toList().indexOf(entry.key);
          final rotation = index * (360 / CategoryData.categories.length);

          return _buildCategorySegment(entry, rotation);
        }).toList(),
      ),
    ).animate().scale();
  }

  Widget _buildCategorySegment(MapEntry entry, double rotation) {
    return Transform.rotate(
      angle: rotation * (3.14159 / 180), // 각도를 라디안으로 변환
      child: GestureDetector(
        onTap: () => onCategorySelected(entry.key),
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: selectedCategory == entry.key
                ? Colors.blue.withOpacity(0.3)
                : Colors.transparent,
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Icon(entry.value.icon),
              Text(entry.key),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubItems(BuildContext context, String category) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: CategoryData.getLocalizedSubItems(context, category)
            .map(
              (item) => ListTile(
                title: Text(item),
                onTap: () {
                  onSubItemSelected?.call(category, item);
                  onDismiss();
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
