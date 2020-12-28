import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql_operation/mutations/mutations.dart' as mutations;

class StarrableRepository extends StatelessWidget {
  const StarrableRepository({
    Key key,
    @required this.repository,
    @required this.optimistic,
    @required this.callBack,
  }) : super(key: key);

  final Map<String, Object> repository;
  final bool optimistic;
  final Function callBack;

  Map<String, Object> extractRepositoryData(Map<String, Object> data) {
    final action = data['action'] as Map<String, Object>;
    if (action == null) {
      return null;
    }
    return action['starrable'] as Map<String, Object>;
  }

  bool get starred => repository['viewerHasStarred'] as bool;

  Map<String, dynamic> get expectedResult => <String, dynamic>{
        //'__typename': 'Query',
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
              // optimisticResult: expectedResult,
            );
            print(' starred : $starred');
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
        repository['viewerHasStarred'] = extractRepositoryData(resultData)['viewerHasStarred'];
        var msg = starred
            ? 'Thanks for your star!'
            : 'Sorry you changed your mind!';
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
    ).then((value) => callBack());
  }

}
