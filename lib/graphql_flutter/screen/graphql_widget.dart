import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql_operation/queries/read_repositories.dart' as queries;
import '../helpers.dart' show withGenericHandling;
import '../access_token.dart' show PERSONAL_ACCESS_TOKEN;
import 'starrable_repository.dart';

const bool ENABLE_WEBSOCKETS = false;

class GraphQLWidgetScreen extends StatelessWidget {
  const GraphQLWidgetScreen() : super();

  @override
  Widget build(BuildContext context) {
    final httpLink = HttpLink(
      'https://api.github.com/graphql',
    );

    final authLink = AuthLink(
      // ignore: undefined_identifier
      getToken: () async => 'Bearer $PERSONAL_ACCESS_TOKEN',
    );

    var link = authLink.concat(httpLink);

    if (ENABLE_WEBSOCKETS) {
      final websocketLink = WebSocketLink('ws://localhost:8080/ws/graphql');

      link = Link.split(
        (request) => request.isSubscription,
        websocketLink,
        link,
      );
    }

    final client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: const CacheProvider(
        child: MyHomePage(title: 'GraphQL Widget'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int nRepositories = 50;

  void changeQuery(String number) {
    setState(() {
      nRepositories = int.parse(number) ?? 50;
    });
  }

  @override
  void initState() {
    print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(' build _MyHomePageState again ');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Number of repositories (default 50)',
              ),
              keyboardType: TextInputType.number,
              onSubmitted: changeQuery,
            ),
            Query(
              options: QueryOptions(
                document: gql(queries.readRepositories),
                variables: {
                  'nRepositories': nRepositories,
                },
                //pollInterval: 10,
              ),
              builder: withGenericHandling(
                (QueryResult result, {refetch, fetchMore}) {
                  if (result.data == null && !result.hasException) {
                    return const Text(
                        'Both data and errors are null, this is a known bug after refactoring, you might forget to set Github token');
                  }

                  // result.data can be either a [List<dynamic>] or a [Map<String, dynamic>]
                  final repositoriesMap = result.data['viewer']['repositories'];
                  final repositories =
                      repositoriesMap['nodes'] as List<dynamic>;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: repositories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StarrableRepository(
                          repository: repositories[index],
                          optimistic: result.source ==
                              QueryResultSource.optimisticResult,
                          callBack: () {
                            setState(() {
                              nRepositories = nRepositories + 1;
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            ENABLE_WEBSOCKETS
                ? Subscription(
                    options: SubscriptionOptions(
                      document: gql(queries.testSubscription),
                    ),
                    builder: (result) => result.isLoading
                        ? const Text('Loading...')
                        : Text(result.data.toString()),
                  )
                : const Text(''),
          ],
        ),
      ),
    );
  }
}
