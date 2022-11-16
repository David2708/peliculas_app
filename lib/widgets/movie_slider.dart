
import 'package:flutter/material.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> moviesPopular;
  final String? title;
  final Function onNextPage;
   
  const MovieSlider({
    Key? key, 
    required this.moviesPopular, 
    required this.onNextPage,
    this.title, 
    }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}


class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() { 
      
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        widget.onNextPage();
      }

    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title!, 
                      style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold)
              ),
            ),

          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.moviesPopular.length,
              itemBuilder: (context, index) => _MoviePoster( movie: widget.moviesPopular[index], 
                                                            heroId: '${widget.title}-$index-${widget.moviesPopular[index].id}', )
            ),
          )
          
        ],
      ),
    );
  }
}


class _MoviePoster extends StatelessWidget {

  final Movie movie;
  final String heroId;
  
  const _MoviePoster({
    Key? key, 
    required this.movie, required this.heroId, 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 100,

      margin: const EdgeInsets.symmetric( horizontal: 10),
      child: Column(
        children: [

         GestureDetector(
           onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
           child: Hero(
             tag: movie.heroId!,
             child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
               child: FadeInImage(
                      placeholder: const AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(movie.fullPosterImg), 
                      width: 130,
                      height: 190,
                      fit: BoxFit.cover,
                ),
             ),
           ),
         ),

          const SizedBox(height: 5,),

          Text(movie.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          )
          
        

        ],
      ),
    );
  }
}