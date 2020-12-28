import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql_operation/mutations/mutations.dart' as mutations;

class StarrableRepository extends StatefulWidget {
  StarrableRepository(
    Map<String, Object> repository,
    bool optimistic,
  ) : _state = _StarrableRepositoryState(
          repository,
          optimistic,
        );

  final _StarrableRepositoryState _state;
  @override
  _StarrableRepositoryState createState() => _state;
}

class _StarrableRepositoryState extends State<StarrableRepository> {
  _StarrableRepositoryState(
    this.repository,
    this.optimistic,
  );

  Map<String, Object> repository;
  final bool optimistic;

  Map<String, Object> extractRepositoryData(Map<String, Object> data) {
    final action = data['action'] as Map<String, Object>;
    if (action == null) {
      return null;
    }
    return action['starrable'] as Map<String, Object>;
  }

  //bool get starred => repository['viewerHasStarred'] as bool;

  bool starred;

  @override
  void initState() {
    starred = repository['viewerHasStarred'] as bool;
    super.initState();
  }

  Map<String, dynamic> get expectedResult => <String, dynamic>{
        'action': {
          '__typename': 'AddStarPayload',
          'starrable': {
            '__typename': 'Repository',
            'id': repository['id'],
            'viewerHasStarred': starred,
          }
        }
      };

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: buildMutationOptions(context),
      builder: (RunMutation toggleStar, QueryResult result) {
        return ListTile(
          leading: starred
              ? const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : const Icon(Icons.star_border),
          trailing: result.isLoading || optimistic
              ? const CircularProgressIndicator()
              : null,
          title: Text(repository['name'] as String),
          onTap: () {
            toggleStar(
              {'starrableId': repository['id']},
              optimisticResult: expectedResult,
            );

            setState(() {
              starred = !starred;
              print('onTap starred : $starred');
            });
          },
        );
      },
    );
  }

  MutationOptions buildMutationOptions(BuildContext context) {
    return MutationOptions(
      document: gql(starred ? mutations.removeStar : mutations.addStar),
      onError: (OperationException error) {
        var msg = error.toString();
        buildShowDialog(context, msg);
      },
      onCompleted: (dynamic resultData) {
        print('resultData : $resultData');
        repository['viewerHasStarred'] =
            extractRepositoryData(resultData)['viewerHasStarred'];
        var msg =
            starred ? 'Thanks for your star!' : 'Sorry you changed your mind!';
        buildShowDialog(context, msg);
      },
    );
  }

  Future buildShowDialog(BuildContext context, String msg) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            SimpleDialogOption(
              child: const Text('DISMISS'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
