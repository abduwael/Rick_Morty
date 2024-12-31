import 'package:flutter/material.dart';

import '../../../../data/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final Results character;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        leading: Image.network(character.image ?? ''),
        title: Text(character.name ?? ''),
        subtitle: Text('${character.species} - ${character.status}'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}
