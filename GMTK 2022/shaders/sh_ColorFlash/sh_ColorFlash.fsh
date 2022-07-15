varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec4 u_color;
uniform float u_strength;
uniform float u_image_alpha;

void main()
{
	// Get the rgba vector from the current texture
	//vec2 uv = v_vTexcoord.xy;
	//uv.x += 128.0;
	vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
	// Create a new vector of u_color with u_strength. This uses an alpha of 1.
	vec4 varColor = vec4(u_color.rgb * vec3(u_strength),u_color.a); 
    // Create a new vector using the original "old" color while applying the inverse of strength to it. 
		// This uses original alpha to only affect visible pixels.
	vec4 oldColor = vec4(texColor.rgb * vec3(1.0-u_strength),texColor.a); 
	// Combine oldColor with varColor to make new color.
		// Keep original alpha to only affect visible pixels of original texture * the image_alpha uniform
	vec4 newColor = vec4(varColor.rgb+oldColor.rgb,texColor.a*u_image_alpha);
	// Pass through newColor to fragcolor
	gl_FragColor = vec4(newColor.rgba);
}
