import 'package:flutter/material.dart';
import './screen/graphql_bloc.dart';
import './screen/graphql_widget.dart';
import './screen/fetch_more.dart';

void main() => runApp(GraphqlApp());

class GraphqlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraphQl App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GraphqlHomePage(),
    );
  }
}

class GraphqlHomePage extends StatefulWidget {
  @override
  _GraphqlHomePageState createState() => _GraphqlHomePageState();
}

class _GraphqlHomePageState extends State<GraphqlHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphql Flutter'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            buildGraphQlButton(
              'GraphQL Widget',
              context,
              GraphQLWidgetScreen(),
            ),
            buildGraphQlButton(
              'GraphQL Bloc pattern',
              context,
              GraphQLBlocPatternScreen(),
            ),
            buildGraphQlButton(
              'Fetch more (Pagination) Example',
              context,
              FetchMoreWidgetScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGraphQlButton(
    String btLabel,
    BuildContext context,
    Widget screen,
  ) {
    return Padding(
      child: RaisedButton(
        child: Text(btLabel),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext _context) => screen,
            ),
          );
        },
      ),
      padding: const EdgeInsets.all(8.0),
    );
  }
}
