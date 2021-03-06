// Mocks generated by Mockito 5.0.15 from annotations
// in lil_rap_app/test/features/artist_list/presentation/bloc/rapper_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:lil_rap_app/core/error/failures.dart' as _i6;
import 'package:lil_rap_app/features/artist_list/domain/entities/rapper.dart'
    as _i7;
import 'package:lil_rap_app/features/artist_list/domain/repositories/rapper_repo.dart'
    as _i2;
import 'package:lil_rap_app/features/artist_list/domain/usecases/get_concrete_rapper.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeRapperRepo_0 extends _i1.Fake implements _i2.RapperRepo {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetConcreteRapperList].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetConcreteRapperList extends _i1.Mock
    implements _i4.GetConcreteRapperList {
  MockGetConcreteRapperList() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RapperRepo get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeRapperRepo_0()) as _i2.RapperRepo);
  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.Rapper>>> call(dynamic _) =>
      (super.noSuchMethod(Invocation.method(#call, [_]),
          returnValue: Future<_i3.Either<_i6.Failure, List<_i7.Rapper>>>.value(
              _FakeEither_1<_i6.Failure, List<_i7.Rapper>>())) as _i5
          .Future<_i3.Either<_i6.Failure, List<_i7.Rapper>>>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [GetConcreteRapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetConcreteRapper extends _i1.Mock implements _i4.GetConcreteRapper {
  MockGetConcreteRapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RapperRepo get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeRapperRepo_0()) as _i2.RapperRepo);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.Rapper>> call(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#call, [uuid]),
              returnValue: Future<_i3.Either<_i6.Failure, _i7.Rapper>>.value(
                  _FakeEither_1<_i6.Failure, _i7.Rapper>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i7.Rapper>>);
  @override
  String toString() => super.toString();
}
