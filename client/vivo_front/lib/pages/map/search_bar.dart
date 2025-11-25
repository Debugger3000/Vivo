import 'package:flutter/material.dart';
import 'package:vivo_front/com_ui_widgets/event_chip.dart';
import 'package:vivo_front/types/categories.dart';
import 'package:vivo_front/types/event.dart';

class SearchBarOverlay extends StatefulWidget {
  final Function(List<GetEventPreview>)? onSearch;

  const SearchBarOverlay({super.key, this.onSearch});

  @override
  State<SearchBarOverlay> createState() => _SearchBarOverlayState();
}

class _SearchBarOverlayState extends State<SearchBarOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showDropdown = false;
  final bool _loading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    print("focus changed...");
    if (!_focusNode.hasFocus) {
      setState(() => _showDropdown = false);
    } else {
      setState(() => _showDropdown = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("tapped outsode of search bar area...");
          // click outside closes dropdown and removes focus
          FocusScope.of(context).unfocus();
          setState(() => _showDropdown = false);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onTap: () => setState(() => _showDropdown = true),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),

            // Dropdown: scrollable horizontal row of chips
            if (_showDropdown)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categoriesEnum.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: EventChip(
                          label: category,
                          // onTap: () {
                          //   print('Selected $category');
                          //   setState(() => _showDropdown = false);
                          //   FocusScope.of(context).unfocus();
                          // },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
