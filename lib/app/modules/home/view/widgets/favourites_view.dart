import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/controller.dart';
import 'character_card.dart';

class FavoritesView extends GetView<HomeController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Obx(() {
          // Check if favorites are empty
          if (controller.favoriteCharacters.isEmpty) {
            return const Center(
                child:
                    Text('No favorites yet.', style: TextStyle(fontSize: 20)));
          }

          // Display the favorites list
          return ListView.builder(
            itemCount: controller.favoriteCharacters.length,
            itemBuilder: (context, index) {
              final character = controller.favoriteCharacters[index];
              return CharacterCard(
                isFavorite: true,
                character: character,
                onFavoriteToggle: () {
                  controller.toggleFavorite(character);

                  controller.loadFavorites();
                },
              );
            },
          );
        }),
      ),
    );
  }
}
