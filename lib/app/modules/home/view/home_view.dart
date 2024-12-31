import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rick_and_morty/app/modules/home/view/widgets/character_card.dart';
import 'package:rick_and_morty/app/modules/home/view/widgets/favourites_view.dart';

import '../../../shared_widgets/custom_text_form_field.dart';
import '../controller/controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to FavoritesView
                  Get.to(() => const FavoritesView());
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF172249),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: controller.obx(
          (state) {
            return Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomTextFormField(
                        controller: controller.searchController,
                        onChanged: (value) {
                          controller.filterCharacters();
                        }),
                    const Gap(16),
                    DropdownButton<String>(
                      value: controller.selectedStatus.value.isEmpty
                          ? null
                          : controller.selectedStatus.value,
                      hint: const Text('Select Status'),
                      isExpanded: true,
                      items: ['Alive', 'Dead', 'unknown']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedStatus.value = value ?? '';
                        controller.filterCharacters();
                      },
                    ),
                    const SizedBox(width: 8),
                    // Species Dropdown
                    DropdownButton<String>(
                      value: controller.selectedSpecies.value.isEmpty
                          ? null
                          : controller.selectedSpecies.value,
                      hint: const Text('Select Species'),
                      isExpanded: true,
                      items: [
                        'Human',
                        'Alien',
                        'Other'
                      ] // Add other species as needed
                          .map((species) => DropdownMenuItem(
                                value: species,
                                child: Text(species),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedSpecies.value = value ?? '';
                        controller.filterCharacters();
                      },
                    ),

                    Expanded(
                      child: Obx(() {
                        if (controller.filteredCharacters.isEmpty) {
                          return const Center(
                              child: Text('No characters found.'));
                        }
                        return ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.filteredCharacters.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.filteredCharacters.length) {
                              debugPrint(
                                  'isFiltering: ${controller.isFiltering.value}');
                              return controller.isFiltering.value
                                  ? const SizedBox() // No loader during filtering
                                  : controller.hasMorePages.value
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : const Center(
                                          child: Text('No more characters.'));
                            }

                            final character =
                                controller.filteredCharacters[index];

                            return Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  controller.goToCharacterDetails(character);
                                },
                                child: CharacterCard(
                                  isFavorite: controller.favoriteCharacters
                                      .contains(character),
                                  character:
                                      controller.filteredCharacters[index],
                                  onFavoriteToggle: () {
                                    controller.toggleFavorite(character);
                                  },
                                ),
                              );
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              );
            });
          },
          onLoading: const Center(
            child: CircularProgressIndicator(),
          ),
          onError: (e) {
            return Center(
              child: Text(e.toString()),
            );
          },
          onEmpty: const Center(
            child: Text('No Data'),
          ),
        ));
  }
}
