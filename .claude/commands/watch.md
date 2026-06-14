---
description: Fetch a YouTube video's transcript and produce a structured summary.
allowed-tools: Bash, WebFetch, WebSearch
---

# /watch — YouTube Video Summariser

Summarise the YouTube video given below.

**Input:** $ARGUMENTS

## Instructions

1. **Extract the video ID** from the URL (the `v=` query-param value, or the last path segment for youtu.be links).

2. **Fetch the transcript** using the following strategy in order, stopping at the first that succeeds:

   a. Try the `yt-dlp` CLI if available:
      ```bash
      yt-dlp --write-auto-sub --sub-lang en --skip-download --output "/tmp/yt_%(id)s" "<URL>"
      ```
      Then read the generated `.vtt` or `.srt` file.

   b. Try the YouTube transcript page via WebFetch:
      `https://www.youtubetranscript.com/?v=<VIDEO_ID>`

   c. Fetch the raw YouTube watch page via WebFetch and extract the `"captionTracks"` JSON block embedded in the page source, then fetch the first caption track URL to get the XML transcript.

   d. If no transcript is available, fetch the video's description and top-level comments to produce a best-effort summary, and note that no captions were found.

3. **Clean the transcript** — strip timestamps, HTML tags, and duplicate lines.

4. **Produce a structured summary** with these sections:
   - **Title & Channel** (from the page or yt-dlp metadata)
   - **TL;DR** — one sentence capturing the core point
   - **Key Points** — 5–8 bullet points covering the main ideas
   - **Detailed Summary** — 3–5 paragraphs with enough detail to replace watching the video
   - **Quotes Worth Noting** — 2–4 verbatim quotes (if available)
   - **Action Items / Takeaways** — practical next steps the viewer could take (if applicable)

5. End with: `> Source: <original YouTube URL>`
