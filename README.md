# claude-skills

Personal Claude Code skills, synced via GitHub.

## Setup on a new machine

```bash
git clone <your-repo-url> ~/claude-skills
cd ~/claude-skills
chmod +x setup.sh
./setup.sh
```

This symlinks `~/.claude/skills` → `~/claude-skills/skills`, so any skill you add here is instantly live in Claude Code.

## Adding a skill

Drop a markdown file into `skills/`:

```
skills/
└── my-skill.md      # Claude invokes with /my-skill
```

Then commit and push:

```bash
git add skills/my-skill.md
git commit -m "add my-skill"
git push
```

On other machines: `git pull` — the symlink picks it up automatically.

## Skill file format

```markdown
# Skill Name

Use this skill when the user wants to...

## Instructions
...
```
