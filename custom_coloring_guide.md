# How to Create Custom Coloring Images

To add your own custom coloring images via the Admin Panel, you need two things: **SVG Markup** and a **Legend Configuration (JSON)**.

## 1. SVG Markup
The SVG Markup is the actual drawing. It must be prepared carefully so the app knows which parts can be colored.

### Steps to prepare the SVG:
1. **Remove fill colors**: Ensure all shapes that need to be colored have `fill="none"` or `fill="#f1f5f9"`.
2. **Add Region IDs**: Every path or shape that can be colored MUST have a unique `id` attribute (e.g., `id="leaf-left"`, `id="flower-center"`).
3. **Set ViewBox**: Make sure the root `<svg>` tag has a `viewBox` (e.g., `viewBox="0 0 400 400"`).

**Example SVG Markup:**
```xml
<svg viewBox="0 0 400 400" width="400" height="400">
    <!-- Center of the flower -->
    <circle id="flower-center" cx="200" cy="200" r="40" fill="none" stroke="#000" stroke-width="6"/>
    
    <!-- Left petal -->
    <path id="petal-left" d="M160,200 C100,150 100,250 160,200 Z" fill="none" stroke="#000" stroke-width="6"/>
    
    <!-- Right petal -->
    <path id="petal-right" d="M240,200 C300,150 300,250 240,200 Z" fill="none" stroke="#000" stroke-width="6"/>
</svg>
```
*Note: Make sure your `d` attributes or shapes have proper coordinate spaces, usually within 0-400.*

---

## 2. Legend Configuration (JSON format)
The legend tells the game which Dhivehi letter (or English/Number code) belongs to which region of the SVG.

### JSON Structure:
The JSON format must be a simple Object (Key-Value pairs), where the **Key** is the Region ID from your SVG, and the **Value** is the "path" data used to automatically calculate the center coordinate to place the letter label. For standard SVGs uploaded directly from Illustrator or Figma, just map the ID to the letter.

Because the Admin Panel uses an advanced parser, you can format your Legend in two ways:

#### Option A: Simple Object (Recommended for Auto-Centering)
Map your SVG `id` to the `d` path data (for `<path>`) or basic coordinates. The app will automatically assign Dhivehi letters and Hex Colors to each region.

```json
{
  "flower-center": "M160,160 L240,160 L240,240 L160,240 Z",
  "petal-left": "M160,200 C100,150 100,250 160,200 Z",
  "petal-right": "M240,200 C300,150 300,250 240,200 Z"
}
```
*When using this format, the app automatically cycles through the Thaana alphabet (`ހ`, `ށ`, `ނ`, etc.) and default colors for each region.*

#### Option B: Full Array (Advanced Customization)
If you want to manually specify the exact letters and exact hex colors for the palette, use the Array format. 

```json
[
  { "code": "ހ", "name": "Yellow", "hex": "#eab308" },
  { "code": "ށ", "name": "Red", "hex": "#ef4444" },
  { "code": "ނ", "name": "Blue", "hex": "#3b82f6" }
]
```
*Note: If you use this Array format, you MUST manually add `data-code` and `data-correct` attributes directly to your SVG Markup tags so the app knows which color maps to which shape.*

## Summary Workflow:
1. Draw your image in Illustrator, Figma, or Inkscape.
2. Export as SVG.
3. Open the SVG in a text editor.
4. Add `id="..."` to the shapes you want kids to color.
5. Copy the SVG into the **SVG Markup** box.
6. Create the JSON mapping the IDs to their paths, and paste it into the **Legend** box.
