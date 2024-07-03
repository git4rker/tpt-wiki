import sys
from PIL import Image

if len(sys.argv) < 4:
    print(f"Usage: {sys.argv[0]} <font map .png file> <character width> <character height>")
    sys.exit(1)

char_width = int(sys.argv[2])
char_height = int(sys.argv[3])

code = "local font = {\n"

with Image.open(sys.argv[1], ) as fmap_img:
    fmap_img = fmap_img.convert("1")
    
    if fmap_img.size[0] % char_width != 0 or fmap_img.size[1] % char_height:
        print("ERROR: image width/height is not a multiple of character width/height!")

    # 95
    for i in range(95):
        ci = i + 32

        code += f"  [{ci}] = {{\n"

        for y in range(char_height):
            code += f"    {{"
            for x in range(char_width):
                code += f"{fmap_img.getpixel((i * char_width + x, y)) // 255},"
            code += f"}},\n"

        code += "  },\n"

code += "}\nreturn font"

print(code)
