
import 'package:flutter/material.dart';
import 'package:peliculas_app/widgets/widgets.dart';

import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return  Scaffold(
      body: CustomScrollView(
        // physics: BouncingScrollPhysics(),
        slivers: [
          _CustomAppBar( movie: movie, ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle( movie: movie, ),
              const SizedBox(height: 10,),
              _OverView( movie: movie, ),
              const SizedBox(height: 15,),
              CastingCard(movieId: movie.id,),
              const SizedBox(height: 200,),
            ])
          )
        ],
      ),
    );
  }
}


class _CustomAppBar extends StatelessWidget {

  final Movie movie;
   
  const _CustomAppBar({
    Key? key, 
    required this.movie
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: Colors.indigo,
        expandedHeight: 200,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            color: Colors.black12,
            padding: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                movie.title,
                style: const TextStyle(fontSize: 16),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                ),
            ),
          ),
          background: FadeInImage(
            placeholder: const AssetImage('assets/loading.gif'), 
            image: NetworkImage(movie.fullBackdropPath),
            fit: BoxFit.cover,
          ),
        ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle({
    Key? key, 
    required this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only( top: 20 ),
      padding: const EdgeInsets.symmetric( horizontal: 20 ),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg), 
                height: 150,
              ),
            ),
          ),

          const SizedBox( width: 20, ),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2,),
                Text(movie.originalTitle, style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2,),
                Row(
                  children: [
                    const Icon(Icons.star_border_outlined, size: 15, color: Colors.grey,),
                    const SizedBox( width: 8, ),
                    Text('${movie.voteAverage}', style: textTheme.caption, overflow: TextOverflow.ellipsis, maxLines: 2,),   
                  ],
                ),
              ],
            ),
          ),

          
        ],
      ),
    );
  }
}

class _OverView extends StatelessWidget {

  final Movie movie;
   
  const _OverView({
    Key? key, 
    required this.movie
    }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}