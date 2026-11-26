"""生成任务四 B 所需的小图片：200x200，蓝色方块 + 数字 7。

不依赖 Pillow 等第三方库，仅用 Python 标准库写出 PNG。
运行：python make_test_image.py
"""
import struct
import zlib
from pathlib import Path

W = H = 200
WHITE = (255, 255, 255)
BLUE = (30, 100, 220)
BLACK = (0, 0, 0)

pixels = [[WHITE for _ in range(W)] for _ in range(H)]

# 蓝色方块：左上角 (15, 40)，边长 110
for y in range(40, 150):
    for x in range(15, 125):
        pixels[y][x] = BLUE

# 数字 7 的 5x7 点阵，放大 9 倍，放在方块右侧
SEVEN = [
    "11111",
    "00001",
    "00010",
    "00100",
    "00100",
    "01000",
    "01000",
]
scale, ox, oy = 9, 135, 60
for row_i, row in enumerate(SEVEN):
    for col_i, ch in enumerate(row):
        if ch != "1":
            continue
        for dy in range(scale):
            for dx in range(scale):
                x, y = ox + col_i * scale + dx, oy + row_i * scale + dy
                if 0 <= x < W and 0 <= y < H:
                    pixels[y][x] = BLACK


def png_chunk(tag: bytes, data: bytes) -> bytes:
    return (
        struct.pack(">I", len(data))
        + tag
        + data
        + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
    )


raw = b"".join(b"\x00" + b"".join(bytes(px) for px in row) for row in pixels)
png = b"\x89PNG\r\n\x1a\n"
png += png_chunk(b"IHDR", struct.pack(">IIBBBBB", W, H, 8, 2, 0, 0, 0))
png += png_chunk(b"IDAT", zlib.compress(raw, 9))
png += png_chunk(b"IEND", b"")

out = Path(__file__).with_name("test-image.png")
out.write_bytes(png)
print(f"已生成 {out}  {W}x{H}  {out.stat().st_size} bytes")
