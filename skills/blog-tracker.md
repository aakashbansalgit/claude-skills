# Blog Tracker Skill

Use this skill when the user wants to:
- Add or remove blog URLs to track
- List tracked blogs
- Check for new blog posts
- Get summaries of recent posts

## Data Storage

All data is stored in `~/.claude/blog-tracker/data.json` with this shape:
```json
{
  "blogs": ["https://example.com/blog", "..."],
  "seen_posts": {
    "https://example.com/blog": ["https://example.com/blog/post-1", "..."]
  }
}
```

## Commands & How to Handle Them

### `/blog-tracker add <url>`
1. Read `~/.claude/blog-tracker/data.json`
2. Add the URL to the `blogs` array (if not already present)
3. Write back the updated JSON
4. Confirm to the user

### `/blog-tracker remove <url>`
1. Read `~/.claude/blog-tracker/data.json`
2. Remove the URL from `blogs` and delete its key from `seen_posts`
3. Write back the updated JSON
4. Confirm to the user

### `/blog-tracker list`
1. Read `~/.claude/blog-tracker/data.json`
2. Display all tracked blog URLs

### `/blog-tracker check` (also runs on the morning cron)
This is the main command. Follow these steps carefully:

1. Read `~/.claude/blog-tracker/data.json`
2. For each blog URL in `blogs`:
   a. Use WebFetch to fetch the page
   b. Look for post links — check for RSS/Atom feed links first (e.g. `<link rel="alternate" type="application/rss+xml">`), then try common feed paths like `/feed`, `/rss`, `/atom.xml`, `/feed.xml`
   c. If an RSS/Atom feed is found, fetch it and parse all `<item>` or `<entry>` elements to extract: title, link/URL, publication date, and description/summary
   d. If no feed found, scrape the HTML page for article/post links (look for `<article>`, `<h2 a href>`, or similar patterns)
   e. Collect the list of post URLs found
3. Compare collected post URLs against `seen_posts[blog_url]`
4. New posts = posts NOT in `seen_posts[blog_url]`
5. For each new post, use WebFetch to fetch its full content and write a 2–3 sentence summary
6. Update `seen_posts[blog_url]` with ALL currently found post URLs (merge, don't replace, to avoid re-reporting old posts after a blog removes them)
7. Write the updated `data.json` back to disk
8. Print a formatted report:

```
## Blog Update Report — <date>

### <Blog Name / URL>
**<Post Title>** — <date if available>
<URL>
<2-3 sentence summary>

---
(no new posts) — if nothing new
```

If the `blogs` list is empty, remind the user to add blogs first with `/blog-tracker add <url>`.

## Special Sources

- **YouTube RSS feeds** (`youtube.com/feeds/videos.xml?channel_id=...`) — these are Atom feeds. Parse `<entry>` elements; title is in `<title>`, video URL is in `<link rel="alternate">`, published date in `<published>`, and description in `<media:description>`.
- **Substack** (`oneusefulthing.org`) — has a standard RSS feed at `/feed`. Parse `<item>` elements.
- **arena.ai leaderboard** — no feed; scrape the page for model ranking changes. Compare top-10 model list against previous snapshot stored in `seen_posts`.

## Notes
- Always read the data file before writing it, to avoid overwriting concurrent changes
- Keep `seen_posts` growing (append-only per blog) so already-reported posts are never re-reported
- Handle fetch errors gracefully: if a blog is unreachable, note it in the report and skip it
