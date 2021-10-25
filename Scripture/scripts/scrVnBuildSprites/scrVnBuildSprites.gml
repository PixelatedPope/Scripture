function scrVnBuildSprites() {
		sprHeart = scripture_register_sprite("Heart",sprHearts,{});
		sprCry = scripture_register_sprite("Cry",sprEmojiCry,{
			xScale: .2,
			yScale: .2,
			kerning: 20,
		});
}
