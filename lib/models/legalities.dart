import 'package:equatable/equatable.dart';

class Legalities extends Equatable {
    final String standard;
    final String future;
    final String historic;
    final String timeless;
    final String gladiator;
    final String pioneer;
    final String modern;
    final String legacy;
    final String pauper;
    final String vintage;
    final String penny;
    final String commander;
    final String oathbreaker;
    final String standardbrawl;
    final String brawl;
    final String alchemy;
    final String paupercommander;
    final String duel;
    final String oldschool;
    final String premodern;
    final String predh;

    const Legalities({
        required this.standard,
        required this.future,
        required this.historic,
        required this.timeless,
        required this.gladiator,
        required this.pioneer,
        required this.modern,
        required this.legacy,
        required this.pauper,
        required this.vintage,
        required this.penny,
        required this.commander,
        required this.oathbreaker,
        required this.standardbrawl,
        required this.brawl,
        required this.alchemy,
        required this.paupercommander,
        required this.duel,
        required this.oldschool,
        required this.premodern,
        required this.predh,
    });

    Legalities copyWith({
        String? standard,
        String? future,
        String? historic,
        String? timeless,
        String? gladiator,
        String? pioneer,
        String? modern,
        String? legacy,
        String? pauper,
        String? vintage,
        String? penny,
        String? commander,
        String? oathbreaker,
        String? standardbrawl,
        String? brawl,
        String? alchemy,
        String? paupercommander,
        String? duel,
        String? oldschool,
        String? premodern,
        String? predh,
    }) => 
        Legalities(
            standard: standard ?? this.standard,
            future: future ?? this.future,
            historic: historic ?? this.historic,
            timeless: timeless ?? this.timeless,
            gladiator: gladiator ?? this.gladiator,
            pioneer: pioneer ?? this.pioneer,
            modern: modern ?? this.modern,
            legacy: legacy ?? this.legacy,
            pauper: pauper ?? this.pauper,
            vintage: vintage ?? this.vintage,
            penny: penny ?? this.penny,
            commander: commander ?? this.commander,
            oathbreaker: oathbreaker ?? this.oathbreaker,
            standardbrawl: standardbrawl ?? this.standardbrawl,
            brawl: brawl ?? this.brawl,
            alchemy: alchemy ?? this.alchemy,
            paupercommander: paupercommander ?? this.paupercommander,
            duel: duel ?? this.duel,
            oldschool: oldschool ?? this.oldschool,
            premodern: premodern ?? this.premodern,
            predh: predh ?? this.predh,
        );

    factory Legalities.fromJson(Map<String, dynamic> json) => Legalities(
        standard: json["standard"],
        future: json["future"],
        historic: json["historic"],
        timeless: json["timeless"],
        gladiator: json["gladiator"],
        pioneer: json["pioneer"],
        modern: json["modern"],
        legacy: json["legacy"],
        pauper: json["pauper"],
        vintage: json["vintage"],
        penny: json["penny"],
        commander: json["commander"],
        oathbreaker: json["oathbreaker"],
        standardbrawl: json["standardbrawl"],
        brawl: json["brawl"],
        alchemy: json["alchemy"],
        paupercommander: json["paupercommander"],
        duel: json["duel"],
        oldschool: json["oldschool"],
        premodern: json["premodern"],
        predh: json["predh"],
    );

    Map<String, dynamic> toJson() => {
        "standard": standard,
        "future": future,
        "historic": historic,
        "timeless": timeless,
        "gladiator": gladiator,
        "pioneer": pioneer,
        "modern": modern,
        "legacy": legacy,
        "pauper": pauper,
        "vintage": vintage,
        "penny": penny,
        "commander": commander,
        "oathbreaker": oathbreaker,
        "standardbrawl": standardbrawl,
        "brawl": brawl,
        "alchemy": alchemy,
        "paupercommander": paupercommander,
        "duel": duel,
        "oldschool": oldschool,
        "premodern": premodern,
        "predh": predh,
    };
    
      @override
      List<Object?> get props => [
        standard,
        future,
        historic,
        timeless,
        gladiator,
        pioneer,
        modern,
        legacy,
        pauper,
        vintage,
        penny,
        commander,
        oathbreaker,
        standardbrawl,
        brawl,
        alchemy,
        paupercommander,
        duel,
        oldschool,
        premodern,
        predh,
      ];
}