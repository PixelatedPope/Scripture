#macro EMOTION_NORMAL "normal"
#macro EMOTION_SMILE "smile"
#macro EMOTION_SHOCKED "shocked"
#macro EMOTION_SAD "sad"
#macro EMOTION_ANGRY "angry"
#macro EMOTION_SCARED	"scared"
#macro EMOTION_ANNOYED "annoyed"

#macro VN_FADE (-400)
#macro VN_PART_SYSTEM_UPPER (-300)
#macro VN_TEXTBOX_DEPTH (-200)
#macro VN_PART_SYSTEM_LOWER (-100)
#macro VN_CHARACTER_DEPTH 0
#macro VN_BOY_COLOR $3c2214
#macro VN_GIRL_COLOR $3c1427
#macro VN_BOY "Boy"
#macro VN_GIRL "Girl"

enum Emotion{
	blank,
	normal,
	smile,
	shocked,
	sad,
	scared,
	annoyed,
	angry,
	count,
}

enum Boxes {
	main,
	girl,
	boy
}