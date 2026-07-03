abstract class UseCase<SuccessType, Params> {
  Future<SuccessType> call(Params params);
}

abstract class StreamUseCase<SuccessType, Params> {
  Stream<SuccessType> call(Params params);
}

class NoParams {}
