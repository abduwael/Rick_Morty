import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/character_model.dart';
import '../../../data/proviedr/character_provider.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController with StateMixin<CharacterModel?> {
  CharacterProvider characterProvider = Get.find<CharacterProvider>();
  TextEditingController searchController = TextEditingController();
  RxList<Results> allCharacters = <Results>[].obs;
  RxList<Results> filteredCharacters = <Results>[].obs;
  RxList<Results> favoriteCharacters = <Results>[].obs;
  RxString selectedStatus = ''.obs;
  RxString selectedSpecies = ''.obs;
  SharedPreferences? prefs;
  static const int pageSize = 20;
  int currentPage = 1;
  RxBool isLoadingMore = false.obs;
  RxBool hasMorePages = true.obs;
  ScrollController scrollController = ScrollController();

  final PagingController<int, Results> pagingController =
      PagingController(firstPageKey: 1);
  @override
  void onInit() {
    super.onInit();
    initSharedPreferences();
    scrollAndLoadMore();
  }

  void scrollAndLoadMore() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore.value &&
          hasMorePages.value) {
        isLoadingMore.value = true;
        getCharacters(isPagination: true);
      }
    });
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await getCharacters(); // Ensure characters are loaded
    loadFavorites(); // Then load favorites
  }

  Future<void> getCharacters({bool isPagination = false}) async {
    if (!isPagination) {
      change(null,
          status: RxStatus.loading()); // Keep existing logic for non-pagination
    }

    try {
      final char = await characterProvider.getCharacters(
          page: currentPage); // Pass current page

      if (char != null && char.results!.isNotEmpty) {
        if (isPagination) {
          // Append new data for pagination
          allCharacters.addAll(char.results!);
        } else {
          // Initial load logic
          allCharacters.value = char.results!;
          filteredCharacters.value = allCharacters;
          change(char, status: RxStatus.success());
        }

        // Check if more pages exist
        if (char.info?.next == null) {
          hasMorePages.value = false;
        } else {
          currentPage++; // Increment page for the next request
        }
      } else {
        if (!isPagination) {
          change(null,
              status: RxStatus.empty()); // Keep existing empty data logic
        }
        hasMorePages.value = false; // No more pages to load
      }
    } catch (e) {
      if (!isPagination) {
        change(null,
            status: RxStatus.error(
                e.toString())); // Preserve error handling for non-pagination
      }
    } finally {
      isLoadingMore.value = false; // Reset loading state
    }
  }

  void filterCharacters() {
    String query = searchController.text.toLowerCase();
    String status = selectedStatus.value;
    String species = selectedSpecies.value;

    filteredCharacters.value = allCharacters.where((character) {
      bool? matchesName = character.name?.toLowerCase().contains(query);
      bool matchesStatus = status.isEmpty || character.status == status;
      bool matchesSpecies = species.isEmpty || character.species == species;
      return matchesName! && matchesStatus && matchesSpecies;
    }).toList();
  }

  void toggleFavorite(Results character) {
    if (favoriteCharacters.contains(character)) {
      favoriteCharacters.remove(character);
    } else {
      favoriteCharacters.add(character);
    }
    saveFavorites();
  }

  Future<void> saveFavorites() async {
    final favoriteIds = favoriteCharacters.map((char) => char.id).toList();
    await prefs?.setStringList(
        'favorites', favoriteIds.map((id) => id.toString()).toList());
  }

  void loadFavorites() {
    final favoriteIds = prefs?.getStringList('favorites') ?? [];
    favoriteCharacters.value = allCharacters
        .where((char) => favoriteIds.contains(char.id.toString()))
        .toList();
  }

  void goToCharacterDetails(Results character) {
    Get.toNamed(Routes.CHARACTER_DETAILS, arguments: {'character': character});
  }
}
