https://www.eztree.dev -> Export to treename.glb
drag your gld file of the tree to import in the trees, then do this to apply the shader:
Right-Click treename.glb - New Inherited scene

Save it (ctrl-s) under res://Courses/Environments/trees and give it tree name

Click on Mesh2 -> Surface Material Override
0 -> New ShaderMaterial
(Open shader)
Shader -> Load -> res://Courses/Environments/Shaders/trees_shader.gdshader

Shader Parameters
Albedo (pick a green colors or something that make sense)
Albedo Texture -> Load -> res://Courses/Environments/tress/treename_4.png will be the texture

Texture Roughness will be res://Courses/Environments/tress/treename_3.png

You can adjust the:
Sway Speed
Sway Strength
Sway Phase Length 

Save the tree (CTRL+S)

The tree is always too big
Transform -> scale around 0.2
