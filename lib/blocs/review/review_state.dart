import 'package:akarak/models/model.dart';

abstract class ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final int? productId;
  final List<CommentModel> list;
  final RateModel rate;

  ReviewSuccess({
    this.productId,
    required this.list,
    required this.rate,
  });
}
