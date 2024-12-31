import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
  RxBool isFiltering = false.obs;

  @override
  void onInit() {
    super.onInit();
    initSharedPreferences();
    scrollAndLoadMore();
  }

  void scrollAndLoadMore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !isLoadingMore.value &&
            !isFiltering.value &&
            hasMorePages.value) {
          isLoadingMore.value = true;
          getCharacters(isPagination: true);
        }
      });
    });
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await getCharacters();
    loadFavorites();
  }

  Future<void> getCharacters({bool isPagination = false}) async {
    if (!isPagination) {
      change(null, status: RxStatus.loading());
    }
    try {
      final char = await characterProvider.getCharacters(page: currentPage);

      if (char != null && char.results!.isNotEmpty) {
        if (isPagination) {
          allCharacters.addAll(char.results!);
        } else {
          allCharacters.value = char.results!;
          filteredCharacters.value = allCharacters;
          change(char, status: RxStatus.success());
        }

        if (char.info?.next == null) {
          hasMorePages.value = false;
        } else {
          currentPage++;
        }
      } else {
        if (!isPagination) {
          change(null, status: RxStatus.empty());
        }
        hasMorePages.value = false;
      }
    } catch (e) {
      if (!isPagination) {
        change(null, status: RxStatus.error(e.toString()));
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  void filterCharacters() {
    // Check if any filter has a value
    isFiltering.value = searchController.text.isNotEmpty ||
        selectedStatus.value.isNotEmpty ||
        selectedSpecies.value.isNotEmpty;

    String query = searchController.text.toLowerCase();
    String status = selectedStatus.value;
    String species = selectedSpecies.value;

    // Apply filters on the local dataset
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
