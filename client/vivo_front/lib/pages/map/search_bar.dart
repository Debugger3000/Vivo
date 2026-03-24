import 'package:flutter/material.dart';
import 'package:vivo_front/api/Events/get_events.dart';
import 'package:vivo_front/api/api_service.dart';
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
  final ApiService api = ApiService(); 
  String? _selectedCategory; // Tracks the active filter for category

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

  // ---------------------------
  // Search functionality

  // search by event name...
  Future<void> onTextChanged(String title) async{
    // print("Searching for text: $value");


    // api call here
    List<GetEventPreview> results = await getEventsByTitle(api, title);

    // send results back to map to populate new markers...
    widget.onSearch?.call(results);
  }

  // search by event category...
  Future<void> onCategorySelected(String category) async {
    print("Searching by category: $category");
    
    // UI Feedback: remove all but one category
    setState(() {
      _selectedCategory = category; // Set the active filter
      _showDropdown = false;
    });
    FocusScope.of(context).unfocus();

    // 
    List<GetEventPreview> results = await getEventsByCategory(api, category);
    // send results back to map to populate new markers...
    widget.onSearch?.call(results);
  }


  void _clearFilter() async {
    setState(() {
      _selectedCategory = null;
      _controller.clear();
    });
    // Fetch all events again (using your existing getEvents)
    List<GetEventPreview> results = await getEvents(api); 
    widget.onSearch?.call(results);
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
                      onTap: () => setState(() => _showDropdown = true), // on Top for search field
                      onChanged: onTextChanged, // <--- Add this line
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

            // active category filters
            if (_selectedCategory != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: double.infinity, // Ensures it matches search bar width
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "Filter",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EventChip(
                          label: _selectedCategory!,
                          onTap: _clearFilter, 
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: _clearFilter,
                          child: const Icon(Icons.cancel_outlined, size: 25, color: Colors.black),
                        ),
                      ],
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
                          onTap: () => onCategorySelected(category),
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
