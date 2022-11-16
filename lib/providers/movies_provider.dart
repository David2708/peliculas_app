
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_movies_response.dart';
 

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = '78cf59473606cba33b2ae0f103b50791';
  final String _baseUrl ='api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = []; 
  Map<int, List<Cast>> movieCast = {};
  
  int _popularPage= 0;

  final debouncer = Debouncer(
    duration: const Duration( milliseconds: 500 ),
  );

  final StreamController<List<Movie>> _suggestionStreamContoller = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamContoller.stream;


  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData( String endpoint, [int page = 1] ) async{
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,
      'language': _language,
      'page' : '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

    

  getOnDisplayMovies() async{

    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();

  }

  getPopularMovies() async {

    _popularPage++;
    
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();

  }

  Future<List<Cast>> getMovieCast(int movieId) async{

    if( movieCast.containsKey(movieId) ) return movieCast[movieId]!;
    print('pidiendo data');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovie(String query) async {
    var url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;

  }

  void getSuggestionByQuery(String searchTerm) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      // print('Tenemos valor a buscar: $value');
      final results = await searchMovie(value);
      _suggestionStreamContoller.add( results );
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration( milliseconds: 301)).then(( _ ) => timer.cancel());

  }

}