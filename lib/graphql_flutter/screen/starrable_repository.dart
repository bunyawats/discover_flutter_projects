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
            'viewerHasStarred': !starred,
          }
        }
      };

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(starred ? mutations.removeStar : mutations.addStar),
        update: (cache, result) {
          if (result.hasException) {
            print(result.exception);
          } else {
            final updated = {
              ...repository,
              ...extractRepositoryData(result.data),
            };
            cache.writeFragment(
              Fragment(
                document: gql(
                  '''
                  fragment fields on Repository {
                    id
                    name
                    viewerHasStarred
                  }
                  ''',
                ),
              ).asRequest(idFields: {
                '__typename': updated['__typename'],
                'id': updated['id'],
              }),
              data: updated,
              broadcast: false,
            );
          }
        },
        onError: (OperationException error) {
          showDialog<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(error.toString()),
                actions: <Widget>[
                  SimpleDialogOption(
                    child: const Text('DISMISS'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            },
          );
        },
        onCompleted: (dynamic resultData) {

          callBack();

          // showDialog<AlertDialog>(
          //   context: context,
          //   builder: (BuildContext context) {
          //     var viewerHasStarred =
          //         extractRepositoryData(resultData)['viewerHasStarred'] as bool;
          //
          //     return AlertDialog(
          //       title: Text(
          //         viewerHasStarred
          //             ? 'Thanks for your star!'
          //             : 'Sorry you changed your mind!',
          //       ),
          //       actions: <Widget>[
          //         SimpleDialogOption(
          //           child: const Text('DISMISS'),
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //           },
          //         )
          //       ],
          //     );
          //   },
          // ).then((value) => callBack());
        },
      ),
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
          },
        );
      },
    );
  }
}
