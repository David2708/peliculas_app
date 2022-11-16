

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('builResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    Widget _emtyCenter(){
      return const Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black45, size: 100,)
      );
    }

    if( query.isEmpty ){
      return _emtyCenter();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false );
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        
        if(!snapshot.hasData) return _emtyCenter();

        final movie = snapshot.data!;

        return ListView.builder(
          itemCount: movie.length,
          itemBuilder: (_, int index) => _MovieItem(movie: movie[index])
        );

      },
    );

  }

}


class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'), 
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      trailing: const Icon(Icons.arrow_right),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}