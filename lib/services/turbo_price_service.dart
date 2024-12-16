class PricingService {
  double calculateTurboPrice({
    required double originalPrice,
    required int hoursLeft,
    required int timeDiscountValue,
    required double timeDiscount,
    required int peopleDiscountValue,
    required double peopleDiscount,
    required int guaranteesLength,
    required int guaranteesAmount,
  }) {
    int discountHours = (hoursLeft ~/ timeDiscountValue);
    double timeBasedDiscount =
        (timeDiscount / 100) * originalPrice * discountHours;

    int extraGuarantees = guaranteesLength > guaranteesAmount
        ? (guaranteesLength - guaranteesAmount)
        : 0;
    int discountPeopleBlocks = extraGuarantees ~/ peopleDiscountValue;
    double peopleBasedDiscount =
        (peopleDiscount / 100) * originalPrice * discountPeopleBlocks;

    double finalPrice = originalPrice - timeBasedDiscount - peopleBasedDiscount;
    return finalPrice > 0 ? finalPrice : 0;
  }
}
