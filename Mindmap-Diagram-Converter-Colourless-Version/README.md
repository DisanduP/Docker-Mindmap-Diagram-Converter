# Mermaid Mindmap to Draw.io XML Converter

This tool converts any Mermaid mindmap diagram into Draw.io XML format that can be imported into Draw.io for editing.

## Features

- Parses Mermaid mindmap syntax
- Supports all Mermaid mindmap shapes (circle, square, rounded, hexagon, cloud, bang)
- Generates radial layout Draw.io XML
- Command-line interface with file input/output and stdin support

## Usage

### Convert a file
```bash
node converter.js input.mmd [output.drawio.xml]
```

### Pipe from stdin
```bash
cat mindmap.mmd | node converter.js
# or
echo "mindmap
  root
    child1
    child2" | node converter.js
```

## Mermaid Mindmap Syntax

The converter supports standard Mermaid mindmap syntax:

```
mindmap
  root((central idea))
    Branch 1
      Sub 1.1
      Sub 1.2
    Branch 2
      Sub 2.1
```

### Shapes

- `((text))` - Circle
- `[text]` - Square
- `(text)` - Rounded rectangle
- `{{text}}` - Hexagon
- `)text(` - Cloud
- `))text((` - Bang
- Default - Rounded rectangle

## Output

The output is a Draw.io XML file that can be imported via File → Import From → Text in Draw.io.

The layout uses a balanced horizontal tree structure with:
- Root stays centered
- First half of main branches extend to the right
- Second half of main branches extend to the left
- Clean orthogonal connections that anchor to node edges
- Neutral white backgrounds with black borders for clean, professional appearance
- Wide nodes (180-250px) that accommodate long text without overflow

## Requirements

- Node.js

## Installation

No installation required, just run with Node.js.

## Docker Usage

For containerized deployment and parallel processing:

### Build the Docker Image

```bash
docker build -t mindmap-converter .
```

### Convert Single File

```bash
docker run --rm -v $(pwd):/data mindmap-converter /data/input.mmd /data/output.drawio.xml
```

### Batch Processing with Parallel Execution

Create `input/` and `output/` directories, then place your `.mmd` files in `input/`.

#### Using Parallel Script (Recommended)

```bash
# Convert all files in input/ directory with 4 parallel processes
./parallel-convert.sh input output 4

# Or with default settings (4 parallel processes)
./parallel-convert.sh
```

#### Using Batch Script

```bash
# Convert all files sequentially in background
./batch-convert.sh input output
```

#### Using Docker Compose

```bash
# Run multiple converters in parallel
docker-compose --profile parallel up

# Or scale a single service
docker-compose up --scale mindmap-converter=4
```

### Performance Benefits

- **Parallel Processing**: Process multiple files simultaneously
- **Scalability**: Easy to scale across multiple CPU cores
- **Isolation**: Each conversion runs in its own container
- **Resource Control**: Limit CPU/memory per conversion task

## Example

Input `sample.mmd`:
```
mindmap
  root((mindmap))
    Origins
      Long history
    Research
      On effectiveness<br/>and features
```

Output: `sample.drawio.xml` (Draw.io XML format)
