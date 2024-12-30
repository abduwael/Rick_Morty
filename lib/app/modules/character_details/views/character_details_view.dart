import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/character_model.dart';
import '../controllers/character_details_controller.dart';

class CharacterDetailsView extends GetView<CharacterDetailsController> {
  const CharacterDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.charDetails.value?.name ?? 'Character Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final character = controller.charDetails.value;

          if (character == null) {
            return const Center(child: Text('No character data available.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character Image
                Image.network(
                  character.image ?? '',
                  height: 200,
                  width: Get.width,
                  fit: BoxFit.fill,
                ),

                const SizedBox(height: 8),
                // Status, Species, and Gender
                Text('Status: ${character.status}'),
                Text('Species: ${character.species}'),
                Text('Gender: ${character.gender}'),
                if (character.type != null && character.type!.isNotEmpty)
                  Text('Type: ${character.type}'),
                const SizedBox(height: 16),
                // Origin Location
                Text(
                  'Origin Location:',
                ),
                Text(character.origin?.name ?? 'Unknown'),
                const SizedBox(height: 8),
                // Current Location
                Text(
                  'Current Location:',
                ),
                Text(character.location?.name ?? 'Unknown'),
                const SizedBox(height: 16),
                // Episodes
                Text(
                  'Episodes:',
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: character.episode?.length,
                  itemBuilder: (context, index) {
                    return Text(
                      '- ${character.episode?[index]}',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
