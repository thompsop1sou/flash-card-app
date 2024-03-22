shader_type spatial;

uniform sampler2D card_texture : source_color, hint_default_white;

void fragment() {
	ALBEDO = texture(card_texture, UV).rgb;
}