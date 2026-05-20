# OpenSpec Workflow 安装脚本 (PowerShell)
# 将 CLAUDE.md 和 8 个 os-* skill 安装到用户级 ~/.claude/ 目录

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = "$env:USERPROFILE\.claude"
$SkillsDir = "$ClaudeDir\skills"

Write-Host "=== OpenSpec Workflow 安装 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 备份现有文件
if (Test-Path "$ClaudeDir\CLAUDE.md") {
    $Backup = "$ClaudeDir\CLAUDE.md.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item "$ClaudeDir\CLAUDE.md" $Backup
    Write-Host "[✓] 已备份现有 CLAUDE.md → $Backup" -ForegroundColor Green
}

# 2. 安装 CLAUDE.md
Copy-Item "$ScriptDir\CLAUDE.md" "$ClaudeDir\CLAUDE.md" -Force
Write-Host "[✓] 已安装 CLAUDE.md" -ForegroundColor Green

# 3. 安装 skill 文件
$Skills = @("os-plan", "os-spec", "os-design", "os-build", "os-ship", "os-trace", "os-scope", "os-fork")
foreach ($skill in $Skills) {
    $dest = "$SkillsDir\$skill"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item "$ScriptDir\.claude\skills\$skill\SKILL.md" "$dest\SKILL.md" -Force
    Write-Host "[✓] 已安装 skill: $skill" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== 安装完成 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "下次启动 Claude Code 时自动生效。"
Write-Host "如需卸载：删除 $ClaudeDir\CLAUDE.md 并恢复备份文件。"
