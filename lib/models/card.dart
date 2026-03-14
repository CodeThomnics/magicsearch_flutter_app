// To parse this JSON data, do
//
//     final card = cardFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:magicsearch_flutter_app/models/image_uris.dart';
import 'package:magicsearch_flutter_app/models/legalities.dart';
import 'package:magicsearch_flutter_app/models/prices.dart';
import 'package:magicsearch_flutter_app/models/purchase_uris.dart';
import 'package:magicsearch_flutter_app/models/related_uris.dart';

MagicCard cardFromJson(String str) => MagicCard.fromJson(json.decode(str));

String cardToJson(MagicCard data) => json.encode(data.toJson());

class CardFace extends Equatable {
    final String? name;
    final String? manaCost;
    final String? typeLine;
    final String? oracleText;
    final String? power;
    final String? toughness;
    final ImageUris? imageUris;

    const CardFace({
        this.name,
        this.manaCost,
        this.typeLine,
        this.oracleText,
        this.power,
        this.toughness,
        this.imageUris,
    });

    factory CardFace.fromJson(Map<String, dynamic> json) => CardFace(
        name: json["name"],
        manaCost: json["mana_cost"],
        typeLine: json["type_line"],
        oracleText: json["oracle_text"],
        power: json["power"],
        toughness: json["toughness"],
        imageUris: json["image_uris"] != null
            ? ImageUris.fromJson(json["image_uris"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "mana_cost": manaCost,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "power": power,
        "toughness": toughness,
        "image_uris": imageUris?.toJson(),
    };

    @override
    List<Object?> get props => [name, manaCost, typeLine, oracleText, power, toughness, imageUris];
}

class MagicCard extends Equatable {
    final String object;
    final String id;
    final String oracleId;
    final List<int> multiverseIds;
    final int? tcgplayerId;
    final int? cardmarketId;
    final String name;
    final String lang;
    final DateTime releasedAt;
    final String uri;
    final String scryfallUri;
    final String layout;
    final bool highresImage;
    final String imageStatus;
    final ImageUris? imageUris;
    final String? manaCost;
    final double cmc;
    final String typeLine;
    final String? oracleText;
    final String? power;
    final String? toughness;
    final List<String> colors;
    final List<String> colorIdentity;
    final List<dynamic> keywords;
    final Legalities legalities;
    final List<String> games;
    final bool reserved;
    final bool gameChanger;
    final bool foil;
    final bool nonfoil;
    final List<String> finishes;
    final bool oversized;
    final bool promo;
    final bool reprint;
    final bool variation;
    final String setId;
    final String cardSet;
    final String setName;
    final String setType;
    final String setUri;
    final String setSearchUri;
    final String scryfallSetUri;
    final String rulingsUri;
    final String printsSearchUri;
    final String collectorNumber;
    final bool digital;
    final String rarity;
    final String? flavorText;
    final String? cardBackId;
    final String artist;
    final List<String> artistIds;
    final String? illustrationId;
    final String borderColor;
    final String frame;
    final bool fullArt;
    final bool textless;
    final bool booster;
    final bool storySpotlight;
    final Prices prices;
    final RelatedUris? relatedUris;
    final List<CardFace>? cardFaces;
    final PurchaseUris? purchaseUris;

    const MagicCard({
        required this.object,
        required this.id,
        required this.oracleId,
        required this.multiverseIds,
        required this.tcgplayerId,
        required this.cardmarketId,
        required this.name,
        required this.lang,
        required this.releasedAt,
        required this.uri,
        required this.scryfallUri,
        required this.layout,
        required this.highresImage,
        required this.imageStatus,
        required this.imageUris,
        required this.manaCost,
        required this.cmc,
        required this.typeLine,
        required this.oracleText,
        required this.power,
        required this.toughness,
        required this.colors,
        required this.colorIdentity,
        required this.keywords,
        required this.legalities,
        required this.games,
        required this.reserved,
        required this.gameChanger,
        required this.foil,
        required this.nonfoil,
        required this.finishes,
        required this.oversized,
        required this.promo,
        required this.reprint,
        required this.variation,
        required this.setId,
        required this.cardSet,
        required this.setName,
        required this.setType,
        required this.setUri,
        required this.setSearchUri,
        required this.scryfallSetUri,
        required this.rulingsUri,
        required this.printsSearchUri,
        required this.collectorNumber,
        required this.digital,
        required this.rarity,
        required this.flavorText,
        required this.cardBackId,
        required this.artist,
        required this.artistIds,
        required this.illustrationId,
        required this.borderColor,
        required this.frame,
        required this.fullArt,
        required this.textless,
        required this.booster,
        required this.storySpotlight,
        required this.prices,
        required this.cardFaces,
        required this.relatedUris,
        required this.purchaseUris,
    });

    MagicCard copyWith({
        String? object,
        String? id,
        String? oracleId,
        List<int>? multiverseIds,
        int? tcgplayerId,
        int? cardmarketId,
        String? name,
        String? lang,
        DateTime? releasedAt,
        String? uri,
        String? scryfallUri,
        String? layout,
        bool? highresImage,
        String? imageStatus,
        ImageUris? imageUris,
        String? manaCost,
        double? cmc,
        String? typeLine,
        String? oracleText,
        String? power,
        String? toughness,
        List<String>? colors,
        List<String>? colorIdentity,
        List<dynamic>? keywords,
        Legalities? legalities,
        List<String>? games,
        bool? reserved,
        bool? gameChanger,
        bool? foil,
        bool? nonfoil,
        List<String>? finishes,
        bool? oversized,
        bool? promo,
        bool? reprint,
        bool? variation,
        String? setId,
        String? cardSet,
        String? setName,
        String? setType,
        String? setUri,
        String? setSearchUri,
        String? scryfallSetUri,
        String? rulingsUri,
        String? printsSearchUri,
        String? collectorNumber,
        bool? digital,
        String? rarity,
        String? flavorText,
        String? cardBackId,
        String? artist,
        List<String>? artistIds,
        String? illustrationId,
        String? borderColor,
        String? frame,
        bool? fullArt,
        bool? textless,
        bool? booster,
        bool? storySpotlight,
        Prices? prices,
        List<CardFace>? cardFaces,
        RelatedUris? relatedUris,
        PurchaseUris? purchaseUris,
    }) => 
        MagicCard(
            object: object ?? this.object,
            id: id ?? this.id,
            oracleId: oracleId ?? this.oracleId,
            multiverseIds: multiverseIds ?? this.multiverseIds,
            tcgplayerId: tcgplayerId ?? this.tcgplayerId,
            cardmarketId: cardmarketId ?? this.cardmarketId,
            name: name ?? this.name,
            lang: lang ?? this.lang,
            releasedAt: releasedAt ?? this.releasedAt,
            uri: uri ?? this.uri,
            scryfallUri: scryfallUri ?? this.scryfallUri,
            layout: layout ?? this.layout,
            highresImage: highresImage ?? this.highresImage,
            imageStatus: imageStatus ?? this.imageStatus,
            imageUris: imageUris ?? this.imageUris,
            manaCost: manaCost ?? this.manaCost,
            cmc: cmc ?? this.cmc,
            typeLine: typeLine ?? this.typeLine,
            oracleText: oracleText ?? this.oracleText,
            power: power ?? this.power,
            toughness: toughness ?? this.toughness,
            colors: colors ?? this.colors,
            colorIdentity: colorIdentity ?? this.colorIdentity,
            keywords: keywords ?? this.keywords,
            legalities: legalities ?? this.legalities,
            games: games ?? this.games,
            reserved: reserved ?? this.reserved,
            gameChanger: gameChanger ?? this.gameChanger,
            foil: foil ?? this.foil,
            nonfoil: nonfoil ?? this.nonfoil,
            finishes: finishes ?? this.finishes,
            oversized: oversized ?? this.oversized,
            promo: promo ?? this.promo,
            reprint: reprint ?? this.reprint,
            variation: variation ?? this.variation,
            setId: setId ?? this.setId,
            cardSet: cardSet ?? this.cardSet,
            setName: setName ?? this.setName,
            setType: setType ?? this.setType,
            setUri: setUri ?? this.setUri,
            setSearchUri: setSearchUri ?? this.setSearchUri,
            scryfallSetUri: scryfallSetUri ?? this.scryfallSetUri,
            rulingsUri: rulingsUri ?? this.rulingsUri,
            printsSearchUri: printsSearchUri ?? this.printsSearchUri,
            collectorNumber: collectorNumber ?? this.collectorNumber,
            digital: digital ?? this.digital,
            rarity: rarity ?? this.rarity,
            flavorText: flavorText ?? this.flavorText,
            cardBackId: cardBackId ?? this.cardBackId,
            artist: artist ?? this.artist,
            artistIds: artistIds ?? this.artistIds,
            illustrationId: illustrationId ?? this.illustrationId,
            borderColor: borderColor ?? this.borderColor,
            frame: frame ?? this.frame,
            fullArt: fullArt ?? this.fullArt,
            textless: textless ?? this.textless,
            booster: booster ?? this.booster,
            storySpotlight: storySpotlight ?? this.storySpotlight,
            prices: prices ?? this.prices,
            cardFaces: cardFaces ?? this.cardFaces,
            relatedUris: relatedUris ?? this.relatedUris,
            purchaseUris: purchaseUris ?? this.purchaseUris,
        );

    factory MagicCard.fromJson(Map<String, dynamic> json) => MagicCard(
        object: json["object"],
        id: json["id"],
        oracleId: json["oracle_id"],
        multiverseIds: List<int>.from(json["multiverse_ids"].map((x) => x)),
        tcgplayerId: json["tcgplayer_id"],
        cardmarketId: json["cardmarket_id"],
        name: json["name"],
        lang: json["lang"],
        releasedAt: DateTime.parse(json["released_at"]),
        uri: json["uri"],
        scryfallUri: json["scryfall_uri"],
        layout: json["layout"],
        highresImage: json["highres_image"],
        imageStatus: json["image_status"],
        imageUris: json["image_uris"] != null
            ? ImageUris.fromJson(json["image_uris"])
            : null,
        manaCost: json["mana_cost"],
        cmc: json["cmc"],
        typeLine: json["type_line"],
        oracleText: json["oracle_text"],
        power: json["power"],
        toughness: json["toughness"],
        colors: List<String>.from(json["colors"]?.map((x) => x) ?? []),
        colorIdentity: List<String>.from(json["color_identity"]?.map((x) => x) ?? []),
        keywords: List<dynamic>.from(json["keywords"]?.map((x) => x) ?? []),
        legalities: Legalities.fromJson(json["legalities"]),
        games: List<String>.from(json["games"]?.map((x) => x) ?? []),
        reserved: json["reserved"],
        gameChanger: json["game_changer"],
        foil: json["foil"],
        nonfoil: json["nonfoil"],
        finishes: List<String>.from(json["finishes"]?.map((x) => x) ?? []),
        oversized: json["oversized"],
        promo: json["promo"],
        reprint: json["reprint"],
        variation: json["variation"],
        setId: json["set_id"],
        cardSet: json["set"],
        setName: json["set_name"],
        setType: json["set_type"],
        setUri: json["set_uri"],
        setSearchUri: json["set_search_uri"],
        scryfallSetUri: json["scryfall_set_uri"],
        rulingsUri: json["rulings_uri"],
        printsSearchUri: json["prints_search_uri"],
        collectorNumber: json["collector_number"],
        digital: json["digital"],
        rarity: json["rarity"],
        flavorText: json["flavor_text"],
        cardBackId: json["card_back_id"],
        artist: json["artist"],
        artistIds: List<String>.from(json["artist_ids"]?.map((x) => x) ?? []),
        illustrationId: json["illustration_id"],
        borderColor: json["border_color"],
        frame: json["frame"],
        fullArt: json["full_art"],
        textless: json["textless"],
        booster: json["booster"],
        storySpotlight: json["story_spotlight"],
        cardFaces: json["card_faces"] != null
            ? List<CardFace>.from(json["card_faces"].map((x) => CardFace.fromJson(x)))
            : null,
        prices: Prices.fromJson(json["prices"]),
        relatedUris: RelatedUris.fromJson(json["related_uris"]),
        purchaseUris: PurchaseUris.fromJson(json["purchase_uris"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "oracle_id": oracleId,
        "multiverse_ids": List<dynamic>.from(multiverseIds.map((x) => x)),
        "tcgplayer_id": tcgplayerId,
        "cardmarket_id": cardmarketId,
        "name": name,
        "lang": lang,
        "released_at": "${releasedAt.year.toString().padLeft(4, '0')}-${releasedAt.month.toString().padLeft(2, '0')}-${releasedAt.day.toString().padLeft(2, '0')}",
        "uri": uri,
        "scryfall_uri": scryfallUri,
        "layout": layout,
        "highres_image": highresImage,
        "image_status": imageStatus,
        "image_uris": imageUris?.toJson(),
        "mana_cost": manaCost,
        "cmc": cmc,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "power": power,
        "toughness": toughness,
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "color_identity": List<dynamic>.from(colorIdentity.map((x) => x)),
        "keywords": List<dynamic>.from(keywords.map((x) => x)),
        "legalities": legalities.toJson(),
        "games": List<dynamic>.from(games.map((x) => x)),
        "reserved": reserved,
        "game_changer": gameChanger,
        "foil": foil,
        "nonfoil": nonfoil,
        "finishes": List<dynamic>.from(finishes.map((x) => x)),
        "oversized": oversized,
        "promo": promo,
        "reprint": reprint,
        "variation": variation,
        "set_id": setId,
        "set": cardSet,
        "set_name": setName,
        "set_type": setType,
        "set_uri": setUri,
        "set_search_uri": setSearchUri,
        "scryfall_set_uri": scryfallSetUri,
        "rulings_uri": rulingsUri,
        "prints_search_uri": printsSearchUri,
        "collector_number": collectorNumber,
        "digital": digital,
        "rarity": rarity,
        "flavor_text": flavorText,
        "card_back_id": cardBackId,
        "artist": artist,
        "artist_ids": List<dynamic>.from(artistIds.map((x) => x)),
        "illustration_id": illustrationId,
        "border_color": borderColor,
        "frame": frame,
        "full_art": fullArt,
        "textless": textless,
        "booster": booster,
        "story_spotlight": storySpotlight,
        "card_faces": cardFaces?.map((x) => x.toJson()).toList(),
        "prices": prices.toJson(),
        "related_uris": relatedUris?.toJson(),
        "purchase_uris": purchaseUris?.toJson(),
    };
    
      @override
      List<Object?> get props => [
        object,
        id,
        oracleId,
        multiverseIds,
        tcgplayerId,
        cardmarketId,
        name,
        lang,
        releasedAt,
        uri,
        scryfallUri,
        layout,
        highresImage,
        imageStatus,
        imageUris,
        manaCost,
        cmc,
        typeLine,
        oracleText,
        power,
        toughness,
        colors,
        colorIdentity,
        keywords,
        legalities,
        games,
        reserved,
        gameChanger,
        foil,
        nonfoil,
        finishes,
        oversized,
        promo,
        reprint,
        variation,
        setId,
        cardSet,
        setName,
        setType,
        setUri,
        setSearchUri,
        scryfallSetUri,
        rulingsUri,
        printsSearchUri,
        collectorNumber,
        digital,
        rarity,
        flavorText,
        cardBackId,
        artist,
        artistIds,
        illustrationId,
        borderColor,
        frame,
        fullArt,
        textless,
        booster,
        storySpotlight,
        prices,
        relatedUris,
        cardFaces,
        purchaseUris,
      ];
}
