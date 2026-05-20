#!/usr/bin/env bash
# OpenSpec Workflow 安装脚本
# 将 CLAUDE.md 和 8 个 os-* skill 安装到用户级 ~/.claude/ 目录

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"

echo "=== OpenSpec Workflow 安装 ==="
echo ""

# 1. 备份现有文件
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    BACKUP="$CLAUDE_DIR/CLAUDE.md.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP"
    echo "[✓] 已备份现有 CLAUDE.md → $BACKUP"
fi

# 2. 安装 CLAUDE.md
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "[✓] 已安装 CLAUDE.md"

# 3. 安装 skill 文件
for skill in os-plan os-spec os-design os-build os-ship os-trace os-scope os-fork; do
    mkdir -p "$SKILLS_DIR/$skill"
    cp "$SCRIPT_DIR/.claude/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
    echo "[✓] 已安装 skill: $skill"
done

echo ""
echo "=== 安装完成 ==="
echo ""
echo "已安装文件："
echo "  $CLAUDE_DIR/CLAUDE.md"
for skill in os-plan os-spec os-design os-build os-ship os-trace os-scope os-fork; do
    echo "  $SKILLS_DIR/$skill/SKILL.md"
done
echo ""
echo "下次启动 Claude Code 时自动生效。"
echo "如需卸载：删除 $CLAUDE_DIR/CLAUDE.md 并恢复备份文件。"
