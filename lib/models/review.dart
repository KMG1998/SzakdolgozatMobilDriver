class Review {
  final double score;
  final String reviewText;
  final String? reviewer;
  final String? reviewed;

  Review({required this.score, required this.reviewText, this.reviewer, this.reviewed});

  Review.fromJson(Map<String, dynamic> json)
      : score = json['score'],
        reviewText = json['reviewText'],
        reviewer = json['reviewer'],
        reviewed = json['reviewed'];

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'reviewText': reviewText,
      'reviewer': reviewer,
      'reviewed': reviewed,
    };
  }
}
