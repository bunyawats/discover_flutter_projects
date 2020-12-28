import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const PERSONAL_ACCESS_TOKEN = 'a40c2f6dd064a3e9963a94b6bdb772b5a00f3e1a';

QueryBuilder withGenericHandling(QueryBuilder builder) {
  
  return (result, {refetch, fetchMore}) {
    if (result.hasException) {
      return Text(result.exception.toString());
    }

    if (result.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return builder(result, fetchMore: fetchMore, refetch: refetch);
  };
}
