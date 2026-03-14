import 'package:equatable/equatable.dart';

class PurchaseUris extends Equatable {
    final String? tcgplayer;
    final String? cardmarket;
    final String? cardhoarder;

    const PurchaseUris({
        required this.tcgplayer,
        required this.cardmarket,
        required this.cardhoarder,
    });

    PurchaseUris copyWith({
        String? tcgplayer,
        String? cardmarket,
        String? cardhoarder,
    }) => 
        PurchaseUris(
            tcgplayer: tcgplayer ?? this.tcgplayer,
            cardmarket: cardmarket ?? this.cardmarket,
            cardhoarder: cardhoarder ?? this.cardhoarder,
        );

    factory PurchaseUris.fromJson(Map<String, dynamic> json) => PurchaseUris(
        tcgplayer: json["tcgplayer"],
        cardmarket: json["cardmarket"],
        cardhoarder: json["cardhoarder"],
    );

    Map<String, dynamic> toJson() => {
        "tcgplayer": tcgplayer,
        "cardmarket": cardmarket,
        "cardhoarder": cardhoarder,
    };
    
      @override
      List<Object?> get props => [
        tcgplayer,
        cardmarket,
        cardhoarder,
      ];
}