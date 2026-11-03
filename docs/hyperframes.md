# HyperFrames notes

HyperFrames (HeyGen, github.com/heygen-com/hyperframes, Apache-2.0) turns HTML, CSS, media
and seekable animations into deterministic MP4 video: you author a composition in markup,
animate it with GSAP, and render it with headless Chrome + FFmpeg. It is a rendering engine,
not a generative video model and not HeyGen's avatar product. Output is animated HTML, and
should be labeled as motion design, never as AI-generated footage.

Why it is in this stack: social content pipelines already build animated branded slides;
HyperFrames gives them real typography, easing and reusable, version-controlled templates
instead of hand-rolled ffmpeg filter graphs. Renders are deterministic: our test card
produced byte-identical file size and identical frames across re-renders.

## Requirements

Node 22+, FFmpeg, and headless Chrome (the toolchain downloads it on first run). No account
or credentials. Rendering is CPU work: a 4-second 720p card took 17-42 seconds on a small
2-4 vCPU VM. Keep compositions short; the format's sweet spot is 30-90 seconds.

## Lessons baked into this repo's scripts

1. **Temp space**: renders write large temp files. Machines with a small /tmp fail with
   "Low disk space". `scripts/render-intro.sh` sets TMPDIR to a project-local folder.
2. **Vendor your animation libraries**: scripts loaded from a CDN fail inside the render
   sandbox (the timeline never initializes and the render is blocked). `install.sh`
   downloads GSAP 3.15.0 into the example's `assets/` folder and the composition references
   it relatively.
3. **One scene, one clip**: timed elements each get a full-frame box in this framework, so
   stacking several `class="clip"` elements in a flex column overlaps them. Structure a
   scene as a single clip containing ordinary child elements, and animate the children.
4. **Always run the checker**: `hyperframes check` (lint, runtime, layout, motion,
   contrast) before rendering; it caught both defects above before we shipped the example.

## The example

`hyperframes/techaura-intro/`: a 4-second, 1280x720, 30 fps title card (accent bar, wordmark,
tagline) in TechAura navy (#0b2335 / #102b3e) and cyan (#16c8e8). Verified output: H.264 MP4,
4.000 s, about 145 KB. Edit text and colors in `index.html`, render with
`scripts/render-intro.sh`.
