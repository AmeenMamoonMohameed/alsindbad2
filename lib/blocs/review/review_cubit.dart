import 'package:bloc/bloc.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';

import 'cubit.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewLoading());

  Future<void> onLoad(int id) async {
    ///Notify
    emit(ReviewLoading());

    ///Fetch API
    final result = await ReviewRepository.loadReview(id);
    if (result != null) {
      ///Notify
      emit(
        ReviewSuccess(
          list: result[0],
          rate: result[1],
        ),
      );
    }
  }

  Future<bool> onSave({
    required int id,
    required int productId,
    required String content,
    required double rate,
  }) async {
    ///Fetch API
    final result = await ReviewRepository.saveReview(
      id: id,
      productId: productId,
      content: content,
      rate: rate,
    );
    if (result) {
      final result = await ReviewRepository.loadReview(productId);
      if (result != null) {
        ///Notify
        emit(
          ReviewSuccess(
            productId: productId,
            list: result[0],
            rate: result[1],
          ),
        );
      }
    }
    return result;
  }

  Future<bool> onSaveReplay({
    required int id,
    required int reviewId,
    required int productId,
    required String content,
  }) async {
    ///Fetch API
    final result = await ReviewRepository.saveReplay(
      id: id,
      reviewId: reviewId,
      content: content,
    );
    if (result) {
      final result = await ReviewRepository.loadReview(productId);
      if (result != null) {
        ///Notify
        emit(
          ReviewSuccess(
            productId: productId,
            list: result[0],
            rate: result[1],
          ),
        );
      }
    }
    return result;
  }

  Future<bool> onRemove({
    required int productId,
    required int id,
    required ReviewType type,
  }) async {
    ///Fetch API
    if (type == ReviewType.review) {
      final result = await ReviewRepository.removeReview(
        id: id,
      );
      await onLoad(productId);
      return result;
    } else {
      final result = await ReviewRepository.removeReplay(
        id: id,
      );
      await onLoad(productId);
      return result;
    }

    // if (result) {
    //   final result = await ReviewRepository.loadReview(productId);
    //   if (result != null) {
    //     ///Notify
    //     emit(
    //       ReviewSuccess(
    //         productId: productId,
    //         list: result[0],
    //         rate: result[1],
    //       ),
    //     );
    //   }
    // }
  }
}
