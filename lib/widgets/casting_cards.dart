import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCard extends StatelessWidget {
  final int movieId;

  const CastingCard({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: moviesProvider.getMovieCast(movieId),
        builder: (context, AsyncSnapshot<List<Cast>> snapshot) {

          if( !snapshot.hasData ){
            return const SizedBox(
              height: 180,
              child: CupertinoActivityIndicator(),
            );
          }

          final cast = snapshot.data!;

          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              height: 180,
              child: ListView.builder(
                itemCount: cast.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _CastCard(actor: cast[index],);
                },
              ));
        });
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({
    Key? key, required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
