import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/core/theme/app_text_styles.dart';
import 'package:photo_remix/core/utils/gap.dart';
import 'package:photo_remix/features/home/presentation/widgets/category_tag.dart';
import 'package:photo_remix/features/image_generation/domain/models/category.dart';
import 'package:photo_remix/features/image_generation/presentation/data/category_presets.dart';

/// Category selector with search/filtering for image generation prompts.
class SelectCategoryWidget extends StatefulWidget {
  final ValueChanged<Category>? onCategorySelected;
  final String? initialCategoryId;

  const SelectCategoryWidget({super.key, this.onCategorySelected, this.initialCategoryId});

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialCategoryId;
  }

  @override
  void didUpdateWidget(covariant SelectCategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategoryId != widget.initialCategoryId) {
      _selectedId = widget.initialCategoryId;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        kImageCategories.where((category) {
          if (_query.isEmpty) return true;
          return category.name.toLowerCase().contains(_query.toLowerCase());
        }).toList();

    Category? selectedCategory;
    if (_selectedId != null) {
      try {
        selectedCategory = kImageCategories.firstWhere(
          (category) => category.id == _selectedId,
        );
      } catch (_) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Category',
          style: AppTextStyles.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap.h(12),
        if (selectedCategory != null) ...[
          Row(
            children: [
              const Icon(
                CupertinoIcons.tag,
                size: 18,
                color: AppColors.primary,
              ),
              Gap.w(8),
              Expanded(
                child: Text(
                  selectedCategory.name,
                  style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap.h(12),
        ],
        SearchBar(
          controller: _searchController,
          leading: const Icon(
            CupertinoIcons.search,
            color: AppColors.textSecondary,
          ),
          hintText: 'Search categories',
          textStyle: WidgetStatePropertyAll(AppTextStyles.textTheme.bodyMedium),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
          ),
          backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
          elevation: const WidgetStatePropertyAll(0),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.border),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.px)),
          ),
          onChanged:
              (value) => setState(() {
                _query = value;
              }),
        ),
        Gap.h(16),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10.px,
              runSpacing: 10.px,
              children:
                  filtered
                      .map(
                        (category) => CategoryTag(
                          label: category.name,
                          selected: category.id == _selectedId,
                          onTap: () {
                            setState(() => _selectedId = category.id);
                            widget.onCategorySelected?.call(category);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
