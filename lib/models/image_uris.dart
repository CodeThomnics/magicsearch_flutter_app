import 'package:equatable/equatable.dart';

class ImageUris extends Equatable {
    final String? small;
    final String? normal;
    final String? large;
    final String? png;
    final String? artCrop;
    final String? borderCrop;

    const ImageUris({
        required this.small,
        required this.normal,
        required this.large,
        required this.png,
        required this.artCrop,
        required this.borderCrop,
    });

    ImageUris copyWith({
        String? small,
        String? normal,
        String? large,
        String? png,
        String? artCrop,
        String? borderCrop,
    }) => 
        ImageUris(
            small: small ?? this.small,
            normal: normal ?? this.normal,
            large: large ?? this.large,
            png: png ?? this.png,
            artCrop: artCrop ?? this.artCrop,
            borderCrop: borderCrop ?? this.borderCrop,
        );

    factory ImageUris.fromJson(Map<String, dynamic> json) => ImageUris(
        small: json["small"],
        normal: json["normal"],
        large: json["large"],
        png: json["png"],
        artCrop: json["art_crop"],
        borderCrop: json["border_crop"],
    );

    Map<String, dynamic> toJson() => {
        "small": small,
        "normal": normal,
        "large": large,
        "png": png,
        "art_crop": artCrop,
        "border_crop": borderCrop,
    };
    
      @override
      List<Object?> get props => [
        small,
        normal,
        large,
        png,
        artCrop,
        borderCrop,
      ];
}