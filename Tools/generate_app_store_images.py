from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Screenshot"
OUT = SOURCE / "AppStore"

FONT_REGULAR = "/System/Library/Fonts/SFNS.ttf"
FONT_BOLD = "/System/Library/Fonts/SFNS.ttf"


def font(size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(FONT_REGULAR, size=size)


def text_size(draw: ImageDraw.ImageDraw, text: str, fnt: ImageFont.ImageFont) -> tuple[int, int]:
    box = draw.textbbox((0, 0), text, font=fnt)
    return int(box[2] - box[0]), int(box[3] - box[1])


def wrapped_lines(draw: ImageDraw.ImageDraw, text: str, fnt: ImageFont.ImageFont, max_width: int) -> list[str]:
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        candidate = word if not current else f"{current} {word}"
        if text_size(draw, candidate, fnt)[0] <= max_width:
            current = candidate
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def draw_wrapped(
    draw: ImageDraw.ImageDraw,
    xy: tuple[int, int],
    text: str,
    fnt: ImageFont.ImageFont,
    fill: tuple[int, int, int, int],
    max_width: int,
    line_gap: int,
) -> int:
    x, y = xy
    for line in wrapped_lines(draw, text, fnt, max_width):
        draw.text((x, y), line, font=fnt, fill=fill)
        y += text_size(draw, line, fnt)[1] + line_gap
    return y


def copy_height(draw: ImageDraw.ImageDraw, title: str, subtitle: str, title_fnt: ImageFont.ImageFont, subtitle_fnt: ImageFont.ImageFont, max_width: int) -> int:
    title_gap = max(10, title_fnt.size // 6)
    subtitle_gap = max(8, subtitle_fnt.size // 3)
    height = 0
    for line in wrapped_lines(draw, title, title_fnt, max_width):
        height += text_size(draw, line, title_fnt)[1] + title_gap
    height += max(26, subtitle_fnt.size)
    for line in wrapped_lines(draw, subtitle, subtitle_fnt, max_width):
        height += text_size(draw, line, subtitle_fnt)[1] + subtitle_gap
    return height


def assert_no_overlap(copy_box: tuple[int, int, int, int], image_box: tuple[int, int, int, int], label: str) -> None:
    cx, cy, cw, ch = copy_box
    ix, iy, iw, ih = image_box
    copy_rect = (cx, cy, cx + cw, cy + ch)
    image_rect = (ix, iy, ix + iw, iy + ih)
    separated = (
        copy_rect[2] <= image_rect[0]
        or image_rect[2] <= copy_rect[0]
        or copy_rect[3] <= image_rect[1]
        or image_rect[3] <= copy_rect[1]
    )
    if not separated:
        raise ValueError(f"Layout overlap detected for {label}: copy={copy_rect}, image={image_rect}")


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
    return mask


def cover_resize(image: Image.Image, size: tuple[int, int]) -> Image.Image:
    sw, sh = image.size
    tw, th = size
    scale = max(tw / sw, th / sh)
    resized = image.resize((int(sw * scale), int(sh * scale)), Image.Resampling.LANCZOS)
    left = (resized.width - tw) // 2
    top = (resized.height - th) // 2
    return resized.crop((left, top, left + tw, top + th))


def contain_resize(image: Image.Image, max_size: tuple[int, int]) -> Image.Image:
    copy = image.copy()
    copy.thumbnail(max_size, Image.Resampling.LANCZOS)
    return copy


def make_background(source: Image.Image, size: tuple[int, int]) -> Image.Image:
    base = cover_resize(source, size).filter(ImageFilter.GaussianBlur(radius=max(size) // 32))
    tint = Image.new("RGBA", size, (246, 247, 248, 210))
    return Image.alpha_composite(base.convert("RGBA"), tint)


def paste_card(
    canvas: Image.Image,
    screenshot: Image.Image,
    box: tuple[int, int, int, int],
    radius: int,
    shadow: int,
) -> None:
    x, y, w, h = box
    shot = contain_resize(screenshot, (w, h)).convert("RGBA")
    x += (w - shot.width) // 2
    y += (h - shot.height) // 2
    mask = rounded_mask(shot.size, radius)

    shadow_img = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_img)
    shadow_draw.rounded_rectangle(
        (x, y + shadow // 4, x + shot.width, y + shot.height + shadow // 4),
        radius=radius,
        fill=(0, 0, 0, 58),
    )
    shadow_img = shadow_img.filter(ImageFilter.GaussianBlur(radius=shadow))
    canvas.alpha_composite(shadow_img)

    border = Image.new("RGBA", shot.size, (255, 255, 255, 0))
    border_draw = ImageDraw.Draw(border)
    border_draw.rounded_rectangle((0, 0, shot.width - 1, shot.height - 1), radius=radius, outline=(255, 255, 255, 145), width=max(2, radius // 16))

    canvas.paste(shot, (x, y), mask)
    canvas.alpha_composite(border, (x, y))


def draw_copy(
    canvas: Image.Image,
    title: str,
    subtitle: str,
    origin: tuple[int, int],
    max_width: int,
    title_size: int,
    subtitle_size: int,
    dark: bool = True,
) -> None:
    draw = ImageDraw.Draw(canvas)
    fill = (24, 24, 27, 255) if dark else (255, 255, 255, 245)
    subfill = (66, 69, 73, 230) if dark else (255, 255, 255, 205)
    y = draw_wrapped(draw, origin, title, font(title_size), fill, max_width, max(10, title_size // 6))
    y += max(26, subtitle_size)
    draw_wrapped(draw, (origin[0], y), subtitle, font(subtitle_size), subfill, max_width, max(8, subtitle_size // 3))


def make_portrait(source_path: Path, out_path: Path, title: str, subtitle: str) -> None:
    shot = Image.open(source_path).convert("RGBA")
    w, h = shot.size
    canvas = make_background(shot, (w, h))
    margin = int(w * 0.085)
    title_size = int(w * 0.105)
    subtitle_size = int(w * 0.05)
    copy_width = int(w * 0.80)
    copy_y = int(h * 0.065)
    copy_h = copy_height(ImageDraw.Draw(canvas), title, subtitle, font(title_size), font(subtitle_size), copy_width)
    card_y = max(int(h * 0.365), copy_y + copy_h + int(h * 0.06))
    card_box = (int(w * 0.145), card_y, int(w * 0.71), h - card_y - int(h * 0.055))
    assert_no_overlap((margin, copy_y, copy_width, copy_h), card_box, str(out_path))
    draw_copy(canvas, title, subtitle, (margin, copy_y), copy_width, title_size, subtitle_size)
    paste_card(
        canvas,
        shot,
        card_box,
        radius=int(w * 0.07),
        shadow=int(w * 0.035),
    )
    canvas.convert("RGB").save(out_path, quality=96)


def make_landscape(source_path: Path, out_path: Path, title: str, subtitle: str, platform: str) -> None:
    shot = Image.open(source_path).convert("RGBA")
    w, h = shot.size
    canvas = make_background(shot, (w, h))
    if platform == "Apple TV":
        copy_x, copy_y, copy_w = int(w * 0.075), int(h * 0.105), int(w * 0.315)
        title_size, subtitle_size = int(w * 0.052), int(w * 0.024)
        card_box = (int(w * 0.465), int(h * 0.245), int(w * 0.455), int(h * 0.53))
        radius, shadow = int(w * 0.025), int(w * 0.018)
    elif platform == "Mac":
        copy_x, copy_y, copy_w = int(w * 0.07), int(h * 0.105), int(w * 0.315)
        title_size, subtitle_size = int(w * 0.049), int(w * 0.024)
        card_box = (int(w * 0.465), int(h * 0.24), int(w * 0.455), int(h * 0.54))
        radius, shadow = int(w * 0.018), int(w * 0.014)
    else:
        copy_x, copy_y, copy_w = int(w * 0.07), int(h * 0.105), int(w * 0.315)
        title_size, subtitle_size = int(w * 0.055), int(w * 0.021)
        card_box = (int(w * 0.465), int(h * 0.22), int(w * 0.455), int(h * 0.58))
        radius, shadow = int(w * 0.022), int(w * 0.016)
    copy_h = copy_height(ImageDraw.Draw(canvas), title, subtitle, font(title_size), font(subtitle_size), copy_w)
    assert_no_overlap((copy_x, copy_y, copy_w, copy_h), card_box, str(out_path))
    draw_copy(canvas, title, subtitle, (copy_x, copy_y), copy_w, title_size, subtitle_size)
    paste_card(canvas, shot, card_box, radius=radius, shadow=shadow)
    canvas.convert("RGB").save(out_path, quality=96)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    groups = {
        "iPhone": sorted((SOURCE / "iPhone").glob("*.png")),
        "iPad": sorted((SOURCE / "iPad").glob("*.png")),
        "Apple TV": sorted((SOURCE / "Apple TV").glob("*.png")),
        "Mac": sorted((SOURCE / "Mac").glob("*.png")),
    }
    copy = [
        ("A calmer way to see time", "Lumen turns your screen into a quiet ambient clock."),
        ("Designed for focus", "Choose a visual mood and let the background breathe."),
        ("Time, weather, and ambience", "A soft glanceable display for every Apple screen."),
    ]
    for platform, paths in groups.items():
        platform_dir = OUT / platform.replace(" ", "-")
        platform_dir.mkdir(parents=True, exist_ok=True)
        for index, path in enumerate(paths[:3], start=1):
            title, subtitle = copy[index - 1]
            out_path = platform_dir / f"{index:02d}-{platform.lower().replace(' ', '-')}-app-store.png"
            if platform == "iPhone":
                make_portrait(path, out_path, title, subtitle)
            else:
                make_landscape(path, out_path, title, subtitle, platform)
            print(out_path.relative_to(ROOT))


if __name__ == "__main__":
    main()
