import 'package:equatable/equatable.dart';

class RelatedUris extends Equatable {
    final String? gatherer;
    final String tcgplayerInfiniteArticles;
    final String tcgplayerInfiniteDecks;
    final String edhrec;

    const RelatedUris({
        required this.gatherer,
        required this.tcgplayerInfiniteArticles,
        required this.tcgplayerInfiniteDecks,
        required this.edhrec,
    });

    RelatedUris copyWith({
        String? gatherer,
        String? tcgplayerInfiniteArticles,
        String? tcgplayerInfiniteDecks,
        String? edhrec,
    }) => 
        RelatedUris(
            gatherer: gatherer ?? this.gatherer,
            tcgplayerInfiniteArticles: tcgplayerInfiniteArticles ?? this.tcgplayerInfiniteArticles,
            tcgplayerInfiniteDecks: tcgplayerInfiniteDecks ?? this.tcgplayerInfiniteDecks,
            edhrec: edhrec ?? this.edhrec,
        );

    factory RelatedUris.fromJson(Map<String, dynamic> json) => RelatedUris(
        gatherer: json["gatherer"],
        tcgplayerInfiniteArticles: json["tcgplayer_infinite_articles"],
        tcgplayerInfiniteDecks: json["tcgplayer_infinite_decks"],
        edhrec: json["edhrec"],
    );

    Map<String, dynamic> toJson() => {
        "gatherer": gatherer,
        "tcgplayer_infinite_articles": tcgplayerInfiniteArticles,
        "tcgplayer_infinite_decks": tcgplayerInfiniteDecks,
        "edhrec": edhrec,
    };
    
      @override
      List<Object?> get props => [
        gatherer,
        tcgplayerInfiniteArticles,
        tcgplayerInfiniteDecks,
        edhrec,
      ];
}