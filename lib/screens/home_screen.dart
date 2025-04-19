import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/home_screen_widgets/floating_searchbar.dart';
import 'package:wall_share/home_screen_widgets/home_appbar.dart';
import 'package:wall_share/home_screen_widgets/home_searchbar.dart';
import 'package:wall_share/home_screen_widgets/top_liked_carousel.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/providers/wallpaper_provider.dart';
import 'package:wall_share/screens/create_wallpaper_screen.dart';
import 'package:wall_share/utilities/utilities.dart';
import 'package:wall_share/widgets/wallpapers_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String searcQuery = '';
  bool _isScrolled = false;
  Key _paginationKey = UniqueKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 20 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 20 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  // get a list of wallpapers by category
  List<Wallpaper> getWallpapersByCategory(String category) {
    var filteredWallpapers =
        category == 'All'
            ? Wallpaper.wallpapers
            : Wallpaper.wallpapers
                .where((wallpaper) => wallpaper.category == category)
                .toList();

    if (searcQuery.isNotEmpty) {
      filteredWallpapers =
          filteredWallpapers
              .where(
                (wallpaper) => wallpaper.name.toLowerCase().contains(
                  searcQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    return filteredWallpapers;
  }

  // update filters
  void _updateFilters({String? category, String? search}) {
    setState(() {
      if (category != null) selectedCategory = category;
      if (search != null) searcQuery = search;
      _paginationKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  _scrollListener();
                }
                return true;
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Animated AppBar
                  SliverToBoxAdapter(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _isScrolled ? 0 : 60,
                      child: AnimatedOpacity(
                        opacity: _isScrolled ? 0 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: const HomeAppbar(),
                      ),
                    ),
                  ),

                  // Animated Search Bar
                  SliverToBoxAdapter(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _isScrolled ? 0 : 60,
                      child: AnimatedOpacity(
                        opacity: _isScrolled ? 0 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: HomeSearchbar(
                          onSearch: (value) => _updateFilters(search: value),
                        ),
                      ),
                    ),
                  ),

                  // Carousel widget
                  const SliverToBoxAdapter(child: TopLikedCarousel()),

                  // Categories with frosted glass effect
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      height: 60,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Theme.of(
                              context,
                            ).scaffoldBackgroundColor.withOpacity(0.8),
                            child: _buildCategoryList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Wallpapers Grid
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            200, // Adjust based on your needs
                        child: ClipRRect(
                          child: WallpapersGrid(
                            query: context
                                .read<WallpaperProvider>()
                                .getWallpapersQuery(
                                  category: selectedCategory,
                                  searchQuery: searcQuery,
                                ),
                            onTap: (wallpaper) {
                              // navigate to the wallpaper detail screen
                              Utilities.navigateToWallpaperDetailsScreen(
                                context,
                                wallpaper,
                              );
                            },
                            key: _paginationKey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating search bar
            if (_isScrolled)
              FloatingSearchbar(
                onArrowPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                onChanged: (value) => _updateFilters(search: value),
              ),
          ],
        ),
      ),
      floatingActionButton: AnimatedSlide(
        offset: _isScrolled ? const Offset(0, 2) : Offset.zero,
        duration: const Duration(milliseconds: 200),
        child: AnimatedOpacity(
          opacity: _isScrolled ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: () {
              // navigate to the create wallpaper screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateWallpaperScreen(),
                ),
              );
            },
            tooltip: 'Create Wallper',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Wallpaper.categories.length,
        itemBuilder: (context, index) {
          final category = Wallpaper.categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (selected) {
                _updateFilters(category: Wallpaper.categories[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
