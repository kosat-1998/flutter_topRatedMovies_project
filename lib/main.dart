import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MovieHomePage());
  }
}

class Movies {
  final String original_title;
  final String poster_path;
  final String overview;
  final double vote_average;
  final String release_date;

  Movies(this.original_title, this.poster_path, this.overview,
      this.vote_average, this.release_date);
}

class MovieHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieState();
  }
}

class MovieState extends State<MovieHomePage> {
  Future<List<Movies>> getMovies() async {
    var data = await http.get(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=85cd01088c47c4b5e700ab0ee81b6d69');
    var jsondata = json.decode(data.body);
    var moviedata = jsondata['results'];

    List<Movies> movies = [];
    for (var data in moviedata) {
      Movies item = Movies(data['original_title'], data['poster_path'],
          data['overview'], data['vote_average'], data['release_date']);
      movies.add(item);
    }
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Rated Movies"),
      ),
      body: Container(
        child: FutureBuilder(
            future: getMovies(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                print(snapshot.data);
                return GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(snapshot.data.length, (index) {
                      return InkWell(
                        onTap: () {
                          Movies movies = new Movies(
                              snapshot.data[index].original_title,
                              snapshot.data[index].poster_path,
                              snapshot.data[index].overview,
                              snapshot.data[index].vote_average,
                              snapshot.data[index].release_date);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  new Details(movies: movies)));
                        },
                        child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    snapshot.data[index].original_title,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width: 200.0,
                                    height: 200.0,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: (snapshot.data[index].poster_path ==
                                            null)
                                            ? Image.network(
                                            'https://image.tmdb.org/t/p/w600_and_h900_bestv2/KoYWXbnYuS3b0GyQPkbuexlVK9.jpg')
                                            : Image.network(
                                          'https://image.tmdb.org/t/p/w500/${snapshot.data[index].poster_path}',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.fitHeight,
                                        )),
                                  ),
                                )
                              ],
                            )),
                      );
                    }));
              }
            }),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final Movies movies;
  Details({this.movies});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500/${this.movies.poster_path}',
                    width: 200,
                    height: 300,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                    child: Container(
                      height: 300,
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Text(
                              this.movies.original_title,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.1,
                                wordSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 50,
                                color: Colors.red,
                              ),
                              Container(
                                child: Text(
                                  this.movies.vote_average.toString(),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 50,
                                color: Colors.red,
                              ),
                              Container(
                                child: Text(
                                  this.movies.release_date.toString(),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  color: Colors.black45,
                  child: Text(
                    this.movies.overview,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      wordSpacing: 0.6,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
