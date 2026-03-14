import 'package:equatable/equatable.dart';

class Prices extends Equatable {
    final String? usd;
    final dynamic usdFoil;
    final dynamic usdEtched;
    final String? eur;
    final dynamic eurFoil;
    final dynamic tix;

    const Prices({
        required this.usd,
        required this.usdFoil,
        required this.usdEtched,
        required this.eur,
        required this.eurFoil,
        required this.tix,
    });

    Prices copyWith({
        String? usd,
        dynamic usdFoil,
        dynamic usdEtched,
        String? eur,
        dynamic eurFoil,
        dynamic tix,
    }) => 
        Prices(
            usd: usd ?? this.usd,
            usdFoil: usdFoil ?? this.usdFoil,
            usdEtched: usdEtched ?? this.usdEtched,
            eur: eur ?? this.eur,
            eurFoil: eurFoil ?? this.eurFoil,
            tix: tix ?? this.tix,
        );

    factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        usd: json["usd"],
        usdFoil: json["usd_foil"],
        usdEtched: json["usd_etched"],
        eur: json["eur"],
        eurFoil: json["eur_foil"],
        tix: json["tix"],
    );

    Map<String, dynamic> toJson() => {
        "usd": usd,
        "usd_foil": usdFoil,
        "usd_etched": usdEtched,
        "eur": eur,
        "eur_foil": eurFoil,
        "tix": tix,
    };
    
      @override
      List<Object?> get props => [
        usd,
        usdFoil,
        usdEtched,
        eur,
        eurFoil,
        tix,
      ];
}