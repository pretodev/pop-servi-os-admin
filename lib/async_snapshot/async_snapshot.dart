import 'package:flutter/material.dart';

AsyncSnapshot<T> waiting<T>() => const AsyncSnapshot.nothing();

AsyncSnapshot<T> withData<T>(
  T data, {
  ConnectionState state = ConnectionState.done,
}) {
  return AsyncSnapshot.withData(state, data);
}

AsyncSnapshot<T> withError<T>(
  Exception error, {
  ConnectionState state = ConnectionState.done,
}) {
  return AsyncSnapshot.withError(state, error);
}
