texture gTexture;
technique replace
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}