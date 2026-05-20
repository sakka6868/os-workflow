# os Workflow

**适用于 Claude Code 的 OpenSpec 规范驱动开发 + TDD 工作流技能包。**

将 OpenSpec 6 步工作流（propose → specs → design → tasks → implement → archive）拆分为 8 个按需加载的 `os-*` skill，配合精简版 CLAUDE.md 路由器，基础 context 消耗从 1095 行降至 284 行（↓74%）。

## 架构

```
CLAUDE.md  (284 行，始终加载 — 判定表 + 路由规则)
  ├── os-scope    需求澄清（一次一问、多选题、场景三问）
  ├── os-plan     提案设计（方案对比、YAGNI、分段确认）
  ├── os-spec     规约编写（GIVEN/WHEN/THEN、Spec↔测试映射）
  ├── os-design   设计 + 任务拆分（测试策略、RED→GREEN→REFACTOR、依赖声明）
  ├── os-build    TDD 实施 + 代码审查（RED→GREEN→REFACTOR、并行调度、两阶段审查）
  ├── os-ship     归档发布（合并 delta spec、全量测试）
  ├── os-trace    系统化调试（四阶段根因分析、数据流溯源、3次上限规则）
  └── os-fork     Git Worktree 隔离（多模块并行开发）
```

## 快速安装

### Windows (Git Bash / WSL)

```bash
cd openspec-workflow
bash install.sh
```

### Windows (PowerShell)

```powershell
cd openspec-workflow
.\install.ps1
```

### macOS / Linux

```bash
cd openspec-workflow
bash install.sh
```

### 手动安装

将以下文件复制到对应位置：

| 源文件 | 目标位置 |
|--------|---------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `.claude/skills/os-*/SKILL.md` | `~/.claude/skills/os-*/SKILL.md` |

## 卸载

```bash
rm ~/.claude/CLAUDE.md
mv ~/.claude/CLAUDE.md.bak.* ~/.claude/CLAUDE.md    # 恢复备份
rm -rf ~/.claude/skills/os-*
```

## 使用方式

安装后无需额外配置。下次启动 Claude Code 时，系统自动加载 CLAUDE.md 路由器并注册 8 个 skill。

触发流程：
1. 你发出代码变更请求
2. Claude Code 根据 CLAUDE.md 中的判定表匹配场景
3. 输出 `[WORKFLOW]` header（含"应调用 skill"字段）
4. 按阶段依次调用对应 `os-*` skill
5. 每个 skill 末尾指示下一个应调用的 skill

## 依赖

- Claude Code（任意版本）
- 无其他外部依赖
