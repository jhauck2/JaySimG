shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_disabled, diffuse_burley, specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo :  source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128) = 0;
uniform float roughness : hint_range(0,1) = 1;
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular = 0.13;
uniform float metallic = 0;
uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16) = 1.5;
uniform vec4 backlight : source_color;
uniform sampler2D texture_backlight : hint_default_black,filter_linear_mipmap,repeat_enable;
uniform vec3 uv1_scale = vec3(1,1,1);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale = vec3(1,1,1);
uniform vec3 uv2_offset;
uniform float sway_speed = 0.5;
uniform float sway_strength = 0.5;
uniform float sway_phase_len = 0.5;

void vertex() {
	float strength = COLOR.r * sway_strength;
	VERTEX.x += sin(VERTEX.x * sway_phase_len * 1.123 + TIME * sway_speed) * strength;
	VERTEX.y += sin(VERTEX.y * sway_phase_len + TIME * sway_speed * 1.12412) * strength;
	VERTEX.z += sin(VERTEX.z * sway_phase_len * 0.9123 + TIME * sway_speed * 1.3123) * strength;
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() { 
	vec2 base_uv = UV; 
	vec4 albedo_tex = texture(texture_albedo, base_uv); 
	
	// Combine albedo color and texture 
	vec3 final_albedo = albedo.rgb * albedo_tex.rgb; 
	float final_alpha = albedo.a * albedo_tex.a; 
	// Discard fully transparent pixels 
	if (final_alpha < 0.4) { discard; } 
	// Set final outputs 
	ALBEDO = final_albedo; 
	ALPHA = 1.0; 
	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel); 
	METALLIC = metallic_tex * metallic; 
	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0); 
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel); 
	ROUGHNESS = roughness_tex * roughness; 
	SPECULAR = specular; 
	NORMAL_MAP = texture(texture_normal, base_uv).rgb; 
	NORMAL_MAP_DEPTH = normal_scale; 
	vec3 backlight_tex = texture(texture_backlight, base_uv).rgb; 
	BACKLIGHT = backlight.rgb + backlight_tex; 
}